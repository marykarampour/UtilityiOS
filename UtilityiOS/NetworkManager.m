//
//  NetworkManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NetworkManager.h"
#import "NSData+Compression.h"

const NSInteger REQUEST_TIMEOUT = 60;

static NSDictionary<NSNumber *, NSValue *> *selectors;
static NSDictionary<NSNumber *, NSString *> *requestTypeStrings;
static NSDictionary<NSNumber *, NSString *> *contentTypes;

typedef AFHTTPSessionManager *(* operator)(id manager, SEL cmd, id url, id parameters, id success, id failure);

@implementation MultipartInfo

@end


@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager

+ (instancetype)instance {
    
    static NetworkManager *instanceM = nil;
    static dispatch_once_t once = 0;
    
    dispatch_once(&once, ^{
        instanceM = [[NetworkManager alloc] init];
    });
    return instanceM;
}

+ (void)initialize {
    if (!selectors) {
        selectors = @{@(NetworkRequestType_GET):[NSValue valueWithPointer:@selector(GET:parameters:success:failure:)],
                      @(NetworkRequestType_POST):[NSValue valueWithPointer:@selector(POST:parameters:success:failure:)],
                      @(NetworkRequestType_PUT):[NSValue valueWithPointer:@selector(PUT:parameters:success:failure:)],
                      @(NetworkRequestType_DELETE):[NSValue valueWithPointer:@selector(DELETE:parameters:success:failure:)],
                      @(NetworkRequestType_HEAD):[NSValue valueWithPointer:@selector(HEAD:parameters:success:failure:)],
                      @(NetworkRequestType_PATCH):[NSValue valueWithPointer:@selector(PATCH:parameters:success:failure:)]};
    }
    if (!requestTypeStrings) {
        requestTypeStrings = @{@(NetworkRequestType_GET):@"GET",
                               @(NetworkRequestType_POST):@"POST",
                               @(NetworkRequestType_PUT):@"PUT",
                               @(NetworkRequestType_DELETE):@"DELETE",
                               @(NetworkRequestType_HEAD):@"HEAD",
                               @(NetworkRequestType_PATCH):@"PATCH"};
    }
    if (!contentTypes) {
        contentTypes = @{@(NetworkContentType_OCTET):@"application/octet-stream",
                         @(NetworkContentType_JSON):@"application/json",
                         @(NetworkContentType_HTML):@"text/html;charset=utf-8",
                         @(NetworkContentType_GZIP):@"application/x-gzip",
                         @(NetworkContentType_JPEG):@"image/jpeg"};
    }
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[Constants BaseURL]];
        DEBUGLOG(@"Base url: %@", [Constants BaseURL]);
        
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        self.manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:contentTypes.allValues]];
    }
    return self;
}

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    
    SEL selector = [selectors[@(type)] pointerValue];
    operator requestOperator = (operator)[self.manager methodForSelector:selector];
    DEBUGLOG(@"Request Headers: %@", [self.manager.requestSerializer HTTPRequestHeaders]);
    DEBUGLOG(@"Parameters: %@", parameters.description);

    return requestOperator(self.manager, selector, url, parameters,
                           ^(NSURLSessionDataTask *task, id responseObject) {
                               DEBUGLOG(@"Success Response: %@ - %@", task.response, responseObject);

                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)responseObject;
                               if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                                   DEBUGLOG(@"Success Response Headers: %@", [httpResponse allHeaderFields]);
                               }
                               completion(responseObject, nil);
                           },
                           ^(NSURLSessionDataTask *task, NSError *error) {
                               DEBUGLOG(@"Error Response: %@ - %@", task.response, error.localizedDescription);
                               DEBUGLOG(@"Parameters: %@", parameters.description);

                               completion(nil, error);
                           });
}

- (AFHTTPSessionManager *)downloadURL:(NSString *)url toFile:(NSString *)filname completion:(void (^)(id, NSError *))completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self urlWithEndpoint:url]]];
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *docsDirPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        NSURL *fileURL = [docsDirPath URLByAppendingPathComponent:filname];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200) {
            [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
        }
        return fileURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completion(filePath, error);
    }];
    [downloadTask resume];
    return self.manager;
}

- (NSMutableURLRequest *)requestMultipartFormURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters data:(NSArray<MultipartInfo *> *)data completion:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completion {
    
    NSString *typeStr = requestTypeStrings[@(type)];
    NSString *urlStr = [self urlWithEndpoint:url];
    
    NSMutableURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:typeStr URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (MultipartInfo *info in data) {
            
            NSData *fileData;
            if (info.data.length) {
                fileData = info.data;
                fileData = [info.data streamCompress:COMPRESSION_STREAM_ENCODE];
            }
            else {
                NSData *dbData = [NSData dataWithContentsOfFile:info.filePath];
                fileData = [dbData streamCompress:COMPRESSION_STREAM_ENCODE];
            }
            
            [formData appendPartWithFileData:fileData name:info.fileName fileName:info.fileName mimeType:contentTypes[@(info.contentType)]];
        }
    } error:nil];
    
    NSString *tmpDir = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp_%d", arc4random()]];
    NSURL *fileURL = [NSURL fileURLWithPath:tmpDir];
    
    return [self.manager.requestSerializer requestWithMultipartFormRequest:request writingStreamContentsToFile:fileURL completionHandler:^(NSError * _Nullable error) {
        NSURLSessionUploadTask *task = [self.manager uploadTaskWithRequest:request fromFile:fileURL progress:nil completionHandler:completion];
        [task resume];
    }];
    
}

#pragma mark - helpers

- (void)setHeaders:(NSDictionary *)headers {
    [self.manager.requestSerializer clearAuthorizationHeader];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

- (NSString *)urlWithEndpoint:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@", self.manager.baseURL, url];
}

- (void)resetAuthorizationHeader {
    [self.manager.requestSerializer clearAuthorizationHeader];
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[Constants authorizationUsername] password:[Constants authorizationPassword]];
}


@end

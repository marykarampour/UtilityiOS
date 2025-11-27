//
//  NetworkManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKURESTNetworkManager.h"
#import "NSData+Compression.h"
#import "NSString+Utility.h"

static NSInteger const REQUEST_TIMEOUT = 60;
/** Set this to YES to remove \\ and \n from logs */
static BOOL const CLEAR_LOGS = NO;

static NSDictionary<NSNumber *, NSValue *> *selectors;
static NSDictionary<NSNumber *, NSString *> *requestTypeStrings;
static NSDictionary<NSNumber *, NSString *> *contentTypes;

typedef AFHTTPSessionManager *(* operator)(id manager, SEL cmd, id url, id parameters, id headers, id success, id failure);

@interface AFHTTPSessionManager (Operators)

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(id)parameters
                                headers:(NSDictionary <NSString *, NSString *> *)headers
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      headers:(NSDictionary <NSString *, NSString *> *)headers
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

@implementation AFHTTPSessionManager (Operators)

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(id)parameters
                                headers:(NSDictionary <NSString *, NSString *> *)headers
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    return [self POST:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      headers:(NSDictionary <NSString *, NSString *> *)headers
                      success:(void (^)(NSURLSessionDataTask *, id ))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    return [self GET:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

@end

@interface MKURESTNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation MKURESTNetworkManager

+ (void)initialize {
    if (!selectors) {
        selectors = @{@(MKU_NETWORK_REQUEST_TYPE_GET)    : [NSValue valueWithPointer:@selector(GET:parameters:headers:success:failure:)],
                      @(MKU_NETWORK_REQUEST_TYPE_POST)   : [NSValue valueWithPointer:@selector(POST:parameters:headers:success:failure:)],
                      @(MKU_NETWORK_REQUEST_TYPE_PUT)    : [NSValue valueWithPointer:@selector(PUT:parameters:headers:success:failure:)],
                      @(MKU_NETWORK_REQUEST_TYPE_DELETE) : [NSValue valueWithPointer:@selector(DELETE:parameters:headers:success:failure:)],
                      @(MKU_NETWORK_REQUEST_TYPE_HEAD)   : [NSValue valueWithPointer:@selector(HEAD:parameters:headers:success:failure:)],
                      @(MKU_NETWORK_REQUEST_TYPE_PATCH)  : [NSValue valueWithPointer:@selector(PATCH:parameters:headers:success:failure:)]};
    }
    if (!requestTypeStrings) {
        requestTypeStrings = @{@(MKU_NETWORK_REQUEST_TYPE_GET)    : @"GET",
                               @(MKU_NETWORK_REQUEST_TYPE_POST)   : @"POST",
                               @(MKU_NETWORK_REQUEST_TYPE_PUT)    : @"PUT",
                               @(MKU_NETWORK_REQUEST_TYPE_DELETE) : @"DELETE",
                               @(MKU_NETWORK_REQUEST_TYPE_HEAD)   : @"HEAD",
                               @(MKU_NETWORK_REQUEST_TYPE_PATCH)  : @"PATCH"};
    }
    if (!contentTypes) {
        contentTypes = @{@(MKU_NETWORK_CONTENT_TYPE_OCTET) : @"application/octet-stream",
                         @(MKU_NETWORK_CONTENT_TYPE_JSON)  : @"application/json",
                         @(MKU_NETWORK_CONTENT_TYPE_HTML)  : @"text/html;charset=utf-8",
                         @(MKU_NETWORK_CONTENT_TYPE_GZIP)  : @"application/x-gzip",
                         @(MKU_NETWORK_CONTENT_TYPE_JPEG)  : @"image/jpeg"};
    }
}

+ (id<MKUServicesProtocol>)managerWithBaseURLString:(NSString *)URL {
    MKURESTNetworkManager *obj = [[MKURESTNetworkManager alloc] init];
    obj.serverBaseURL = URL;
    return obj;
}

- (void)requestWithEndpointPrefix:(NSString *)endpointPrefix service:(NSString *)service action:(NSString *)action type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *,NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion {
    
    NSString *URL = [NSString combineString:service withString:action delimiter:@"/"];
    [self requestWithPath:URL type:type parameters:parameters headers:headers completionHandler:completion];
}

- (void)requestWithPath:(NSString *)path type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *,NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion {
    
    if (!self.manager) {
        if (completion) completion(0, nil, nil);
        return;
    }
    
    if (headers) [self setHeaders:headers];
    
    SEL selector = [selectors[@(type)] pointerValue];
    operator requestOperator = (operator)[self.manager methodForSelector:selector];
    DEBUGLOG(@"Request Headers: %@", [self.manager.requestSerializer HTTPRequestHeaders]);
    DEBUGLOG(@"Parameters: %@", parameters.description);
    [MKURESTNetworkManager prettyPrintJSON:parameters];
    
    requestOperator(self.manager, selector, path, parameters, nil, ^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        NSDictionary *headers;
        
        DEBUGLOG(@"Success Response: %@ - %@ - %ld", task.response, responseObject, httpResponse.statusCode);
        if ([responseObject respondsToSelector:@selector(description)]) {
            DEBUGLOG(@"Response size in bytes: %ld", [[responseObject description] lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        }
        
        if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
            headers = [httpResponse allHeaderFields];
            DEBUGLOG(@"Success Response Headers: %@", headers);
        }
        completion(httpResponse.statusCode, responseObject, nil);
    },
    ^(NSURLSessionDataTask *task, NSError *error) {
        NSDictionary *failureBody = [self resultFromError:error];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;

        DEBUGLOG(@"Error Response: %@ - %@ - %@", task.response, error.localizedDescription, failureBody);
        completion(httpResponse.statusCode, failureBody, error);
    });
}

- (void)requestMultipartFormURL:(NSString *)url type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters data:(NSArray<MKUMultipartInfo *> *)data completion:(void (^)(NSURLResponse *, id, NSError *))completion {
    
    NSString *typeStr = [self requesNameForType:type];
    NSString *path = [NSString stringWithFormat:@"%@%@", self.manager.baseURL, url];
    NSMutableURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:typeStr URLString:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (MKUMultipartInfo *info in data) {
            
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
    
    [self.manager.requestSerializer requestWithMultipartFormRequest:request writingStreamContentsToFile:fileURL completionHandler:^(NSError *error) {
        NSURLSessionUploadTask *task = [self.manager uploadTaskWithRequest:request fromFile:fileURL progress:nil completionHandler:completion];
        [task resume];
    }];
}

- (void)downloadURL:(NSString *)url toFile:(NSString *)filname completion:(MKUServerResultErrorBlock)completion {
    
    NSString *path = [NSString stringWithFormat:@"%@%@", self.manager.baseURL, url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *docsDirPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        NSURL *fileURL = [docsDirPath URLByAppendingPathComponent:filname];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200) {
            [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
        }
        return fileURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *  filePath, NSError *error) {
        completion(filePath, error);
    }];
    [downloadTask resume];
}

#pragma mark - headers

- (void)setHeaders:(NSDictionary *)headers {
    [self.manager.requestSerializer clearAuthorizationHeader];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

- (void)resetHeaders:(NSArray *)headers {
    [self.manager.requestSerializer clearAuthorizationHeader];
    [headers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:obj];
    }];
}

- (void)resetAuthorizationHeader {
    [self.manager.requestSerializer clearAuthorizationHeader];
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[Constants authorizationUsername] password:[Constants authorizationPassword]];
}

#pragma mark - helpers

+ (void)prettyPrintJSON:(NSDictionary *)dictionaryData {
    if (dictionaryData) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:&error];
        if (jsonData) {
            NSString *logs = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (CLEAR_LOGS) {
                logs = [logs stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                logs = [logs stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            }
            DEBUGLOG(@"Prettyprinted parameters: %@", logs);
        }
    }
}

- (NSDictionary *)resultFromError:(NSError *)error {
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (data.length) {
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        if (dict && !err) {
            return dict;
        }
    }
    return nil;
}

- (void)setServerBaseURL:(NSString *)serverBaseURL {
    [super setServerBaseURL:serverBaseURL];
    
    NSURL *url = [NSURL URLWithString:serverBaseURL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    DEBUGLOG(@"Base url: %@", manager.baseURL);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:contentTypes.allValues]];
    
    self.manager = manager;
}

- (NSString *)requesNameForType:(MKU_NETWORK_REQUEST_TYPE)type {
    return [requestTypeStrings objectForKey:@(type)];
}

- (void)encodeParametersForRequestTypes:(NSIndexSet *)types {
    NSMutableSet *set = [[NSMutableSet alloc] init];
    [types enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = [self requesNameForType:idx];
        if (0 < name.length) [set addObject:name];
    }];
    
    self.manager.requestSerializer.HTTPMethodsEncodingParametersInURI = set;
}

- (void)defaultEncodeParametersInURL {
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    [set addIndex:MKU_NETWORK_REQUEST_TYPE_GET];
    [set addIndex:MKU_NETWORK_REQUEST_TYPE_HEAD];
    [self encodeParametersForRequestTypes:set];
}

@end


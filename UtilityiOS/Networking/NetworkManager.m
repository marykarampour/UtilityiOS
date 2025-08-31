//
//  NetworkManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NetworkManager.h"
#import "NSData+Compression.h"

static NSInteger const REQUEST_TIMEOUT = 60;

/** Set this to YES to remove \\ and \n from logs */
static BOOL const CLEAR_LOGS = NO;

static NSDictionary<NSNumber *, NSValue *> *selectors;
static NSDictionary<NSNumber *, NSString *> *requestTypeStrings;
static NSDictionary<NSNumber *, NSString *> *contentTypes;

typedef AFHTTPSessionManager *(* operator)(id manager, SEL cmd, id url, id parameters, id headers, id success, id failure);

@implementation MultipartInfo

@end

@interface AFHTTPSessionManager (Operators)

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                      success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

@end

@implementation AFHTTPSessionManager (Operators)

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    return [self POST:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                      headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                      success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    return [self GET:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

@end

@interface NetworkManager ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AFHTTPSessionManager *> *managers;

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
        selectors = @{@(NETWORK_REQUEST_TYPE_GET)    :[NSValue valueWithPointer:@selector(GET:parameters:headers:success:failure:)],
                      @(NETWORK_REQUEST_TYPE_POST)   :[NSValue valueWithPointer:@selector(POST:parameters:headers:success:failure:)],
                      @(NETWORK_REQUEST_TYPE_PUT)    :[NSValue valueWithPointer:@selector(PUT:parameters:headers:success:failure:)],
                      @(NETWORK_REQUEST_TYPE_DELETE) :[NSValue valueWithPointer:@selector(DELETE:parameters:headers:success:failure:)],
                      @(NETWORK_REQUEST_TYPE_HEAD)   :[NSValue valueWithPointer:@selector(HEAD:parameters:headers:success:failure:)],
                      @(NETWORK_REQUEST_TYPE_PATCH)  :[NSValue valueWithPointer:@selector(PATCH:parameters:headers:success:failure:)]};
    }
    if (!requestTypeStrings) {
        requestTypeStrings = @{@(NETWORK_REQUEST_TYPE_GET):@"GET",
                               @(NETWORK_REQUEST_TYPE_POST):@"POST",
                               @(NETWORK_REQUEST_TYPE_PUT):@"PUT",
                               @(NETWORK_REQUEST_TYPE_DELETE):@"DELETE",
                               @(NETWORK_REQUEST_TYPE_HEAD):@"HEAD",
                               @(NETWORK_REQUEST_TYPE_PATCH):@"PATCH"};
    }
    if (!contentTypes) {
        contentTypes = @{@(NETWORK_CONTENT_TYPE_OCTET):@"application/octet-stream",
                         @(NETWORK_CONTENT_TYPE_JSON):@"application/json",
                         @(NETWORK_CONTENT_TYPE_HTML):@"text/html;charset=utf-8",
                         @(NETWORK_CONTENT_TYPE_GZIP):@"application/x-gzip",
                         @(NETWORK_CONTENT_TYPE_JPEG):@"image/jpeg"};
    }
}

- (instancetype)init {
    if (self = [super init]) {
        self.managers = [[NSMutableDictionary alloc] init];
        [self addManagerWithBaseURL:[Constants BaseURL]];
    }
    return self;
}

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    return [self requestURL:url type:type parameters:parameters completionHeaders:^(id result, NSDictionary *headers, NSError *error) {
        completion(result, error);
    }];
}

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters completionHeaders:(ServerResultHeaderErrorBlock)completion {
    return [self requestManagerAtIndex:0 URL:url type:type parameters:parameters completionHeaders:completion];
}

- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion {
    return [self requestManagerAtIndex:index URL:url type:type parameters:parameters completionHeaders:^(id result, NSDictionary *headers, NSError *error) {
        completion(result, error);
    }];
}

- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters completionHeaders:(ServerResultHeaderErrorBlock)completion {
    return [self requestManagerAtIndex:index URL:url type:type parameters:parameters headers:nil completionHeaders:completion];
}

- (AFHTTPSessionManager *)downloadURL:(NSString *)url toFile:(NSString *)filname completion:(void (^)(id, NSError *))completion {
    return [self downloadManagerAtIndex:0 URL:url toFile:filname completion:completion];
}

- (NSMutableURLRequest *)requestMultipartFormURL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters data:(NSArray<MultipartInfo *> *)data completion:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completion {
    return [self requestManagerAtIndex:0 multipartFormURL:url type:type parameters:parameters data:data completion:completion];
}

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completion:(ServerResultErrorBlock)completion {
    return [self requestManagerAtIndex:0 URL:url type:type parameters:parameters headers:headers completionHeaders:^(id result, NSDictionary *headers, NSError *error) {
        completion(result, error);
    }];
}

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completionHeaders:(ServerResultHeaderErrorBlock)completion {
    return [self requestManagerAtIndex:0 URL:url type:type parameters:parameters headers:headers completionHeaders:completion];
}

- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completion:(ServerResultErrorBlock)completion {
    return [self requestManagerAtIndex:index URL:url type:type parameters:parameters headers:headers completion:completion];
}

- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completionHeaders:(ServerResultHeaderErrorBlock)completion {
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return nil;
    
    if (headers) {
        [manager.requestSerializer clearAuthorizationHeader];
        [self setHeaders:headers];
    }
    
    SEL selector = [selectors[@(type)] pointerValue];
    operator requestOperator = (operator)[manager methodForSelector:selector];
    DEBUGLOG(@"Request Headers: %@", [manager.requestSerializer HTTPRequestHeaders]);
    DEBUGLOG(@"Parameters: %@", parameters.description);
    [NetworkManager prettyPrintJSON:parameters];
    
    return requestOperator(manager, selector, url, parameters, nil, ^(NSURLSessionDataTask *task, id responseObject) {
        
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
        completion(responseObject, headers, nil);
    },
    ^(NSURLSessionDataTask *task, NSError *error) {
        
        NSDictionary *failureBody = [self resultFromError:error];
        DEBUGLOG(@"Error Response: %@ - %@ - %@", task.response, error.localizedDescription, failureBody);
        completion(failureBody, nil, error);
    });
}

- (NSMutableURLRequest *)requestManagerAtIndex:(NSUInteger)index multipartFormURL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters data:(NSArray<MultipartInfo *> *)data completion:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completion {
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return nil;
    
    NSString *typeStr = [self requesNameForType:type];
    NSString *urlStr = [self urlWithEndpoint:url managerAtIndex:index];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:typeStr URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    
    return [manager.requestSerializer requestWithMultipartFormRequest:request writingStreamContentsToFile:fileURL completionHandler:^(NSError * _Nullable error) {
        NSURLSessionUploadTask *task = [manager uploadTaskWithRequest:request fromFile:fileURL progress:nil completionHandler:completion];
        [task resume];
    }];
}

- (AFHTTPSessionManager *)downloadManagerAtIndex:(NSUInteger)index URL:(NSString *)url toFile:(NSString *)filname completion:(ServerResultErrorBlock)completion {
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self urlWithEndpoint:url managerAtIndex:index]]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
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
    return manager;
}

#pragma mark - helpers

- (void)setHeaders:(NSDictionary *)headers {
    [self setHeaders:headers managerAtIndex:0];
}

- (void)resetHeaders:(NSArray *)headers {
    [self resetHeaders:headers managerAtIndex:0];
}

- (void)resetAuthorizationHeader {
    [self resetAuthorizationHeaderForManagerAtIndex:0];
}

- (void)setHeaders:(NSDictionary *)headers managerAtIndex:(NSUInteger)index {
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return;
    
    [manager.requestSerializer clearAuthorizationHeader];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

- (void)resetHeaders:(NSArray *)headers managerAtIndex:(NSUInteger)index {
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return;
    
    [manager.requestSerializer clearAuthorizationHeader];
    [headers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:nil forHTTPHeaderField:obj];
    }];
}

- (void)resetAuthorizationHeaderForManagerAtIndex:(NSUInteger)index {
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return;
    
    [manager.requestSerializer clearAuthorizationHeader];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[Constants authorizationUsername] password:[Constants authorizationPassword]];
}

#pragma mark - helpers

- (NSString *)urlWithEndpoint:(NSString *)url managerAtIndex:(NSUInteger)index {
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return @"";
    
    return [NSString stringWithFormat:@"%@%@", manager.baseURL, url];
}

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

- (void)addManagerWithBaseURLString:(NSString *)url {
    [self addManagerWithBaseURL:[NSURL URLWithString:url]];
}

- (void)addManagerWithBaseURL:(NSURL *)url {
    AFHTTPSessionManager *manager = [self managerWithBaseURL:url];
    [self.managers setObject:manager forKey:@([self.managers.allKeys count])];
}

- (AFHTTPSessionManager *)managerWithBaseURL:(NSURL *)url {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    DEBUGLOG(@"Base url: %@", manager.baseURL);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:contentTypes.allValues]];
    return manager;
}

- (NSString *)requesNameForType:(NETWORK_CONTENT_TYPE)type {
    return [requestTypeStrings objectForKey:@(type)];
}

- (void)encodeParametersForRequestTypes:(NSIndexSet *)types inURLForManagerAtIndex:(NSUInteger)index {
        
    NSMutableSet *set = [[NSMutableSet alloc] init];
    [types enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = [self requesNameForType:idx];
        if (0 < name.length) [set addObject:name];
    }];
    
    AFHTTPSessionManager *manager = [self.managers objectForKey:@(index)];
    if (!manager) return;
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = set;
}

- (void)defaultEncodeParametersInURLForManagerAtIndex:(NSUInteger)index {
    
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    [set addIndex:NETWORK_REQUEST_TYPE_GET];
    [set addIndex:NETWORK_REQUEST_TYPE_HEAD];
    [self encodeParametersForRequestTypes:set inURLForManagerAtIndex:index];
}

@end


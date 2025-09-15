//
//  ServerController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "ServerController.h"
#import "NSData+Compression.h"
#import "ServerEndpoints.h"
#import "MKUModel.h"

static NSDictionary *headers;

@implementation ServerController

+ (void)requestURL:(NSString *)url type:(NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] requestURL:url type:type parameters:parameters headers:[self headers] completion:completion];
}

+ (void)auth:(NSString *)username password:(NSString *)password completion:(ServerResultErrorBlock)completion {

    NSDictionary *params = @{@"username":username, @"password":password};
    [self authWithParameters:params completion:completion];
}

+ (void)authWithParameters:(NSDictionary *)params completion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] requestURL:[ServerEndpoints AUTH] type:NETWORK_REQUEST_TYPE_POST parameters:params completionHeaders:^(id result, NSDictionary *headers, NSError *error) {
        [self processLogin:result headers:headers error:error completionHeaders:completion];
    }];
}

+ (void)logoutUserWithCompletion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] requestURL:[ServerEndpoints LOGOUT] type:NETWORK_REQUEST_TYPE_GET parameters:nil completion:^(id result, NSError *error) {
        if (!error) {
            [self setHeaders:@{[self tokenKey]:@""}];
        }
        completion(result, error);
    }];
}
//sample
+ (void)getWithCompletion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] requestURL:@"" type:NETWORK_REQUEST_TYPE_GET parameters:nil headers:[self basicAuthHeaders] completion:^(id result, NSError *error) {
        [self processValuesInResult:result error:error completion:completion];
    }];
}
//sample
+ (void)getListWithCompletion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] requestURL:@"" type:NETWORK_REQUEST_TYPE_GET parameters:nil headers:[self headers] completion:^(id result, NSError *error) {
        [self processResult:result error:error class:[MKUModel class] completion:completion];
    }];
}

#pragma mark - send/get file

+ (AFHTTPSessionManager *)sendFile:(NSData *)data filename:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion {
    MultipartInfo *info = [[MultipartInfo alloc] init];
    info.fileName = filename;
    info.data = data;
    info.contentType = NETWORK_CONTENT_TYPE_OCTET;
    [[NetworkManager instance] setHeaders:[self headers]];
    return [[NetworkManager instance] requestMultipartFormURL:endpoint type:NETWORK_REQUEST_TYPE_POST parameters:nil data:@[info] completion:^(NSURLResponse *response, id   responseObject, NSError *error) {
        DEBUGLOG(@"%@", response);
        completion (response, error);
    }];
}

+ (AFHTTPSessionManager *)getFile:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] setHeaders:[self headers]];
    NSString *url = [NSString stringWithFormat:@"%@/%@", endpoint, filename];
    return [[NetworkManager instance] downloadURL:url toFile:filename completion:^(id result, NSError *error) {
        [self processDataURLResult:result error:error completion:completion];
    }];
}

#pragma mark - swizzled in category

+ (void)authWithUserID:(__kindof NSObject *)userID password:(NSString *)password completion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] requestURL:@"" type:NETWORK_REQUEST_TYPE_POST parameters:nil completion:completion];
}

#pragma mark - helpers

+ (void)processLogin:(id)result headers:(NSDictionary *)headers error:(NSError *)error completionHeaders:(void(^)(id result, NSError *error))completion {
    
    if (!error && result) {
        NSString *token = [result objectForKey:[self authTokenKey]];
        if (token.length == 0) {
            token = [headers objectForKey:[self authTokenKey]];
        }
        if (token) {
            [self setHeaders:@{[self tokenKey]:token}];
        }
    }
    if (completion) completion(result, error);
}

+ (void)processResult:(id)resultObject error:(NSError *)error class:(Class)modelClass key:(NSString *)key completion:(ServerResultErrorBlock)completion {
    if (resultObject) {
        if ([resultObject isKindOfClass:[NSDictionary class]]) {
            if (!key) {
                [self processResult:resultObject error:error class:modelClass completion:^(id result, NSError *error) {
                    if (completion) completion(result, error);
                }];
            }
            else {
                id values = resultObject[key];
                if (values) {
                    [self processResult:values error:error class:modelClass completion:^(id result, NSError *error) {
                        if (completion) completion(result, error);
                    }];
                }
                else {
                    if (completion) completion(nil, [self noContent]);
                }
            }
        }
        else if ([resultObject isKindOfClass:[NSArray class]]) {
            [self processResult:resultObject error:error class:modelClass completion:^(id result, NSError *error) {
                if (completion) completion(result, error);
            }];
        }
        else {
            if (completion) completion(nil, [self noContent]);
        }
    }
    else {
        if (completion) completion(nil, error);
    }
}

+ (NSDictionary *)headers {
    return headers;
}

+ (void)setHeaders:(NSDictionary *)dict {
    [[NetworkManager instance] setHeaders:dict];
    headers = dict;
}

+ (NSDictionary *)headersForUsername:(NSString *)username {
    return @{};
}

+ (NSDictionary *)basicAuthHeaders {
    return @{};
}

+ (NSString *)authTokenKey {
    return @"token";
}

+ (NSString *)tokenKey {
    return @"x-token";
}

#pragma mark - errors

+ (NSError *)unauthorizedWithMessage:(NSString *)message {
    return [NSError errorWithDomain:NSNetServicesErrorDomain code:401 userInfo:@{NSLocalizedDescriptionKey:message.length ? message : @"Unauthorized"}];
}

+ (NSError *)noContent {
    return [NSError errorWithDomain:NSNetServicesErrorDomain code:204 userInfo:@{NSLocalizedDescriptionKey:@"No Content"}];
}

@end

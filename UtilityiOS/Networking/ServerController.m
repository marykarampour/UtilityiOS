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
#import "MKModel.h"

@implementation ServerController

+ (void)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] requestURL:url type:type parameters:parameters headers:[self headers] completion:completion];
}

+ (AFHTTPSessionManager *)auth:(NSString *)username password:(NSString *)password completion:(ServerResultErrorBlock)completion {

    NSDictionary *params = @{@"username":username, @"password":password};
    
    return [[NetworkManager instance] requestURL:[ServerEndpoints AUTH] type:NetworkRequestType_POST parameters:params headers:[ServerController headersForUsername:username] completion:^(id result, NSError *error) {
        if (!error && result) {
            if ([result objectForKey:@"token"]) {
                [[NetworkManager instance] setHeaders:@{@"x-token":[result objectForKey:@"token"]}];
            }
        }
        completion(result, error);
    }];
}

+ (AFHTTPSessionManager *)logoutUserWithCompletion:(ServerResultErrorBlock)completion {
    return [[NetworkManager instance] requestURL:[ServerEndpoints LOGOUT] type:NetworkRequestType_GET parameters:nil completion:^(id result, NSError *error) {
        if (!error && result) {
            if ([result objectForKey:@"token"]) {
                [[NetworkManager instance] setHeaders:@{@"x-token":@""}];
            }
        }
        completion(result, error);
    }];
}
//sample
+ (AFHTTPSessionManager *)getWithCompletion:(ServerResultErrorBlock)completion {
    return [[NetworkManager instance] requestURL:@"" type:NetworkRequestType_GET parameters:nil headers:[ServerController basicAuthHeaders] completion:^(id result, NSError *error) {
        [self processValuesInResult:result error:error completion:completion];
    }];
}
//sample
+ (AFHTTPSessionManager *)getListWithCompletion:(ServerResultErrorBlock)completion {
    return [[NetworkManager instance] requestURL:@"" type:NetworkRequestType_GET parameters:nil headers:[ServerController headers] completion:^(id result, NSError *error) {
        [self processResult:result error:error class:[MKModel class] completion:completion];
    }];
}

#pragma mark - send/get file

+ (AFHTTPSessionManager *)sendFile:(NSData *)data filename:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion {
    MultipartInfo *info = [[MultipartInfo alloc] init];
    info.fileName = filename;
    info.data = data;
    info.contentType = NetworkContentType_OCTET;
    [[NetworkManager instance] setHeaders:[ServerController headers]];
    return [[NetworkManager instance] requestMultipartFormURL:endpoint type:NetworkRequestType_POST parameters:nil data:@[info] completion:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        DEBUGLOG(@"%@", response);
        completion (response, error);
    }];
}

+ (AFHTTPSessionManager *)getFile:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion {
    [[NetworkManager instance] setHeaders:[ServerController headers]];
    NSString *url = [NSString stringWithFormat:@"%@/%@", endpoint, filename];
    return [[NetworkManager instance] downloadURL:url toFile:filename completion:^(id result, NSError *error) {
        [self processDataURLResult:result error:error completion:completion];
    }];
}

#pragma mark - swizzled in category

+ (AFHTTPSessionManager *)authWithUserID:(__kindof NSObject *)userID password:(NSString *)password completion:(ServerResultErrorBlock)completion {
    return [[NetworkManager instance] requestURL:@"" type:NetworkRequestType_POST parameters:nil completion:completion];
}

#pragma mark - helpers

+ (void)processResult:(id)resultObject error:(NSError *)error class:(Class)modelClass key:(NSString *)key completion:(ServerResultErrorBlock)completion {
    if (resultObject) {
        if ([resultObject isKindOfClass:[NSDictionary class]]) {
            if (!key) {
                [self processResult:resultObject error:error class:modelClass completion:^(id result, NSError *error) {
                    completion(result, error);
                }];
            }
            else {
                id values = resultObject[key];
                if (values) {
                    [self processResult:values error:error class:modelClass completion:^(id result, NSError *error) {
                        completion(result, error);
                    }];
                }
                else {
                    completion(nil, [self noContent]);
                }
            }
        }
        else if ([resultObject isKindOfClass:[NSArray class]]) {
            [self processResult:resultObject error:error class:modelClass completion:^(id result, NSError *error) {
                completion(result, error);
            }];
        }
        else {
            completion(nil, [self noContent]);
        }
    }
    else {
        completion(nil, error);
    }
}

+ (NSDictionary *)headers {
    return @{};
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

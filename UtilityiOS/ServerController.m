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

- (AFHTTPSessionManager *)auth:(NSString *)username password:(NSString *)password completion:(void (^)(id, NSError *))completion {
    [[NetworkManager instance] setHeaders:[ServerController headersForUsername:username]];
    NSDictionary *params = @{@"username":username, @"password":password};
    return [[NetworkManager instance] requestURL:[ServerEndpoints AUTH] type:NetworkRequestType_POST parameters:params completion:^(id result, NSError *error) {
        if (!error && result) {
            if ([result objectForKey:@"token"]) {
                [[NetworkManager instance] setHeaders:@{@"x-token":[result objectForKey:@"token"]}];
            }
        }
        completion(result, error);
    }];
}

- (AFHTTPSessionManager *)logoutWithCompletion:(void (^)(id, NSError *))completion {
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
- (AFHTTPSessionManager *)getWithCompletion:(void (^)(id, NSError *))completion {
    [[NetworkManager instance] setHeaders:[ServerController basicAuthHeaders]];
    [[NetworkManager instance] resetAuthorizationHeader];
    return [[NetworkManager instance] requestURL:@"" type:NetworkRequestType_GET parameters:nil completion:^(id result, NSError *error) {
        [self processValuesInResult:result error:error completion:completion];
    }];
}
//sample
- (AFHTTPSessionManager *)getListWithCompletion:(void (^)(id, NSError *))completion {
    [[NetworkManager instance] setHeaders:[ServerController headers]];
    return [[NetworkManager instance] requestURL:@"" type:NetworkRequestType_GET parameters:nil completion:^(id result, NSError *error) {
        [self processResult:result error:error class:[MKModel class] completion:completion];
    }];
}

#pragma mark - send/get file

- (AFHTTPSessionManager *)sendFile:(NSData *)data filename:(NSString *)filename endpoint:(NSString *)endpoint completion:(void (^)(id, NSError *))completion {
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

- (AFHTTPSessionManager *)getFile:(NSString *)filename endpoint:(NSString *)endpoint completion:(void (^)(id, NSError *))completion {
    [[NetworkManager instance] setHeaders:[ServerController headers]];
    NSString *url = [NSString stringWithFormat:@"%@/%@", endpoint, filename];
    return [[NetworkManager instance] downloadURL:url toFile:filename completion:^(id result, NSError *error) {
        [self processDataURLResult:result error:error completion:completion];
    }];
}



#pragma mark - helpers


+ (NSDictionary *)headers {
    return @{};
}

+ (NSDictionary *)headersForUsername:(NSString *)username {
    return @{};
}

+ (NSDictionary *)basicAuthHeaders {
    return @{};
}

- (void)processResult:(id)result error:(NSError *)error class:(Class)modelClass completion:(void (^)(id, NSError *))completion {
    if (error || !result || !modelClass) {
        completion(nil, error);
    }
    else if (result) {
        if (modelClass == [NSString class] || modelClass == [NSDictionary class] || modelClass == [NSNumber class]) {
            completion(result, nil);
        }
        else {
            id modelObject;
            NSError *modelError;
            
            if ([result isKindOfClass:[NSArray class]]) {
                if (modelClass == [NSString class] || modelClass == [NSNumber class]) {
                    modelObject = result;
                }
                else {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in result) {
                        id obj = [[modelClass alloc] initWithDictionary:dict error:&modelError];
                        if (obj && [obj isKindOfClass:modelClass]) {
                            [arr addObject:obj];
                        }
                    }
                    modelObject = arr;
                }
            }
            else {
                modelObject = [[modelClass alloc] initWithDictionary:result error:&modelError];
            }
            completion(modelObject, modelError);
        }
    }
    else {
        completion(nil, nil);//TODO: fix
    }
}

- (void)processValuesInResult:(id)result error:(NSError *)error completion:(void (^)(id, NSError *))completion {
    if (error || !result) {
        completion(nil, error);
    }
    else if (result) {
        if ([result isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in result) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [arr addObjectsFromArray:dict.allValues];
                }
            }
            completion(arr, error);
        }
        else {
            completion(result, error);
        }
    }
    else {
        completion(nil, nil);//TODO: fix
    }
}

- (void)processDataURLResult:(id)result error:(NSError *)error completion:(void (^)(id result, NSError *error))completion {
    if (!error && result) {
        if ([result isKindOfClass:[NSURL class]]) {
            NSError *err = nil;
            NSString *path = [((NSURL *)result).absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&err];
            
            if (data && !err) {
                NSData *decompressed = [data streamCompress:COMPRESSION_STREAM_DECODE];
                DEBUGLOG(@"%lu", (unsigned long)decompressed.length);
                [[NSFileManager defaultManager] removeItemAtURL:result error:nil];
                completion(decompressed, error);
            }
            else {
                completion(nil, error);
            }
        }
        else {
            completion(nil, error);
        }
    }
    else {
        completion(nil, error);
    }
}

@end

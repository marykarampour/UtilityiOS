//
//  ServerController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "ServerController.h"
#import "ServiceEndpoints.h"

@implementation ServerController

- (AFHTTPSessionManager *)service:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    [[NetworkManager instance] setHeaders:[self headers]];
    return [[NetworkManager instance] requestURL:kServiceEndpointURL type:NetworkRequestType_POST parameters:params completion:^(id result, NSError *error) {
        
    }];
}



#pragma mark - helpers

- (NSDictionary *)headers {
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

@end

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
    return [[NetworkManager instance] requestURL:kServiceEndpointURL type:NetworkRequestTypePOST parameters:params completion:^(id result, NSError *error) {
        
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
                    modelObject = [[modelClass alloc] initWithDictionary:result error:&modelError];
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

@end

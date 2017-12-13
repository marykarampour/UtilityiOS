//
//  NetworkManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "JSONModel.h"
#import "Constants.h"

typedef NS_ENUM(NSUInteger, NetworkRequestType) {
    NetworkRequestTypeGET,
    NetworkRequestTypePOST,
    NetworkRequestTypePUT,
    NetworkRequestTypeDELETE,
    NetworkRequestTypeHEAD,
    NetworkRequestTypePATCH
};

@interface NetworkManager : NSObject

+ (instancetype)instance;

/** 
 @param headers the keys are keys for header, values are header value
 **/
- (void)setHeaders:(NSDictionary *)headers;

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(void (^)(id result, NSError *error))completion;

@end

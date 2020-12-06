//
//  ServerController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ProcessModel.h"
#import "NetworkManager.h"

/** @brief Apps should subclass this, the methods here are samples */
@interface ServerController : NSObject

/** @brief Utiltiy method  that uses [self headers] as headers for the requests */
+ (void)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion;

#pragma mark - sample services - subclass may override

+ (void)auth:(NSString *)username password:(NSString *)password completion:(ServerResultErrorBlock)completion;
+ (void)authWithParameters:(NSDictionary *)params completion:(ServerResultErrorBlock)completion;

/** @brief It will be called by default from authWithParameters:completion to set auth token based on headers or result */
+ (void)processLogin:(id)result headers:(NSDictionary *)headers error:(NSError *)error completionHeaders:(void(^)(id result, NSError *error))completion;
+ (void)logoutUserWithCompletion:(ServerResultErrorBlock)completion;

+ (AFHTTPSessionManager *)sendFile:(NSData *)data filename:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion;

+ (AFHTTPSessionManager *)getFile:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion;

#pragma mark - swizzled in category
/** @brief these are generic methods, you need to define a category of ServerController class and define the implementation */
+ (void)authWithUserID:(__kindof NSObject *)userID password:(NSString *)password completion:(ServerResultErrorBlock)completion;

#pragma mark - helper set header and processing result methods

+ (void)processResult:(id)resultObject error:(NSError *)error class:(Class)modelClass key:(NSString *)key completion:(ServerResultErrorBlock)completion;

+ (NSDictionary *)headers;
+ (void)setHeaders:(NSDictionary *)dict;
+ (NSDictionary *)headersForUsername:(NSString *)username;
+ (NSDictionary *)basicAuthHeaders;
+ (NSString *)authTokenKey;
+ (NSString *)tokenKey;
+ (NSError *)unauthorizedWithMessage:(NSString *)message;
+ (NSError *)noContent;

@end

//
//  ServerController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

/** @brief Apps should subclass this, the methods here are samples */
@interface ServerController : NSObject

#pragma mark - sample services - subclass may override

+ (AFHTTPSessionManager *)auth:(NSString *)username password:(NSString *)password completion:(ServerResultErrorBlock)completion;

+ (AFHTTPSessionManager *)logoutUserWithCompletion:(ServerResultErrorBlock)completion;

+ (AFHTTPSessionManager *)sendFile:(NSData *)data filename:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion;

+ (AFHTTPSessionManager *)getFile:(NSString *)filename endpoint:(NSString *)endpoint completion:(ServerResultErrorBlock)completion;

#pragma mark - swizzled in category
/** @brief these are generic methods, you need to define a category of ServerController class and define the implementation */
+ (AFHTTPSessionManager *)authWithUserID:(__kindof NSObject *)userID password:(NSString *)password completion:(ServerResultErrorBlock)completion;


#pragma mark - helper set header and processing result methods

+ (NSDictionary *)headers;
+ (NSDictionary *)headersForUsername:(NSString *)username;
+ (NSDictionary *)basicAuthHeaders;

/** @brief Use when deserialized values from JSON to model objects are needed */
+ (void)processResult:(id)result error:(NSError *)error class:(Class)modelClass completion:(ServerResultErrorBlock)completion;
/** @brief Use when raw values from JSON are needed */
+ (void)processValuesInResult:(id)result error:(NSError *)error completion:(ServerResultErrorBlock)completion;
/** @brief Use to process data/file downloaded from url, it returns NSData object in completion */
+ (void)processDataURLResult:(id)result error:(NSError *)error completion:(ServerResultErrorBlock)completion;

@end

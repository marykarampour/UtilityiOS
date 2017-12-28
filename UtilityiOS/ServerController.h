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

- (AFHTTPSessionManager *)auth:(NSString *)username password:(NSString *)password completion:(void (^)(id result, NSError *error))completion;

- (AFHTTPSessionManager *)logoutWithCompletion:(void (^)(id result, NSError *error))completion;

- (AFHTTPSessionManager *)sendFile:(NSData *)data filename:(NSString *)filename endpoint:(NSString *)endpoint completion:(void (^)(id result, NSError *error))completion;

- (AFHTTPSessionManager *)getFile:(NSString *)filename endpoint:(NSString *)endpoint completion:(void (^)(id result, NSError *error))completion;


#pragma mark - helper set header and processing result methods

+ (NSDictionary *)headers;
+ (NSDictionary *)headersForUsername:(NSString *)username;
+ (NSDictionary *)basicAuthHeaders;

- (void)processResult:(id)result error:(NSError *)error class:(Class)modelClass completion:(void (^)(id result, NSError *error))completion;
- (void)processValuesInResult:(id)result error:(NSError *)error completion:(void (^)(id result, NSError *error))completion;
- (void)processDataURLResult:(id)result error:(NSError *)error completion:(void (^)(id result, NSError *error))completion;

@end

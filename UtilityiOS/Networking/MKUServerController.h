//
//  ServerController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUServicesProtocol.h"

/** @brief Apps should subclass this class and override methods. The subclass can be a singleton.
 @note To support SOAP
 
 Link these framwworks:
 
 @code
 Security.framework
 Accounts.framework
 Foundation.framework
 UIKit.framework
 libxml2.dylib
 SOAPEngine64
 @endcode
 
 SOAPEngine64 requires a license for production use.
 SOAPEngine64 directory should be at the same level as UtilityiOS submodule.
 
 How to add SOAPEngine64:
 https://github.com/priore/SOAPEngine/wiki/Standard-Installation
 
 Enable SOAP by defining a macro ENABLE_SOAP.
 If you don't want the bloat of SOAP be added to your code, simply don't define that macro
 and don't add the frameworks and the corresponding MKU files to the project.
 
 */
@interface MKUServerController : NSObject <MKUNetworkManagerProtocol, MKUServicesDelegate>

/** @brief Adds a networking manager with the give base url.
 
 @param url Base url string
 @param type Corresponds to serverType in MKUServicesProtocol's methods
 @param isSOAP If YES it creates a SOAPEngine, if NO it creates a AFHTTPSessionManager.
 @param isAuth Is this manager responsible for log in and out services?
 */
- (void)addManagerWithType:(NSUInteger)type baseURLString:(NSString *)URL isSOAP:(BOOL)isSOAP isAuth:(BOOL)isAuth;
/** @brief The manager responsible for log in and out services. */
- (id<MKUServicesProtocol>)authManager;

#pragma mark - sample services - subclass may override

/** @brief Sets auth token based on headers or result. */
+ (void)processLogin:(id)result forManager:(id<MKUServicesProtocol>)manager headers:(NSDictionary *)headers error:(NSError *)error completionHeader:(void(^)(id result, NSError *error))completion;
/** @brief Sets auth token to empty. */
+ (void)processLogoutForManager:(id<MKUServicesProtocol>)manager error:(NSError *)error completionHeader:(void(^)(id result, NSError *error))completion;

#pragma mark - swizzled in category

/** @brief these are generic methods, you need to define a category of ServerController class and define the implementation. */
+ (void)authWithUserID:(__kindof NSObject *)userID password:(NSString *)password completion:(MKUServerResultErrorBlock)completion;
/** @brief Sets auth token to empty string. Call in override in completion. */
+ (void)logoutUserWithCompletion:(MKUServerResultErrorBlock)completion;

#pragma mark - helper set header and processing result methods

+ (void)processResult:(id)resultObject error:(NSError *)error class:(Class)modelClass key:(NSString *)key completion:(MKUServerResultErrorBlock)completion;

- (void)setHeaders:(NSDictionary *)headers serverType:(NSUInteger)serverType;
- (void)resetHeaders:(NSArray *)headers serverType:(NSUInteger)serverType;
- (void)resetAuthorizationHeaderForServerType:(NSUInteger)serverType;
+ (NSDictionary *)headersForUsername:(NSString *)username;
+ (NSDictionary *)basicAuthHeaders;
+ (NSString *)authTokenKey;
+ (NSString *)tokenKey;
+ (NSError *)unauthorizedWithMessage:(NSString *)message;
+ (NSError *)noContent;

@end

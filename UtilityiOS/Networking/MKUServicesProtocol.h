//
//  MKUServicesProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-10-02.
//  Copyright © 2025 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUServerDefinitions.h"

@class MKUMultipartInfo;
@protocol MKUServicesDelegate;

@protocol MKUNetworkManagerProtocol <NSObject>

/** @brief Utiltiy method that uses [self headers] as headers for the requests.
 @code
 REST
 https://baseurl/service/action
 @endcode
 
 @code
 SOAP
 URL: https://baseurl/service
 SOAP Action: endpointPrefix/action
 @endcode
 
 @param serverType Indicates which server to connect to. Each server corresponds to a NetworkManager instance.
 @param endpointPrefix The URL prefix of SOAP action. This is not used in REST and can be nil.
 @param service A webservice.asmx in SOAP or a main path component in REST.
 @param action The final component of path in REST or action in SOAP.
 */
- (void)requestWithServerType:(NSUInteger)serverType endpointPrefix:(NSString *)endpointPrefix service:(NSString *)service action:(NSString *)action type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *, NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion;

@end

@protocol MKUServicesProtocol <NSObject>

@required
- (BOOL)isSOAP;
/** @brief Returns a manager with base URL for each different server that you want to reach. */
+ (id<MKUServicesProtocol>)managerWithBaseURLString:(NSString *)URL;

- (void)setHeaders:(NSDictionary *)headers;
- (void)resetHeaders:(NSArray *)headers;
- (void)resetAuthorizationHeader;

/** @brief Utiltiy method that uses [self headers] as headers for the requests.
 @code
 REST
 https://baseurl/service/action
 @endcode
 
 @code
 SOAP
 URL: https://baseurl/service
 SOAP Action: endpointPrefix/action
 @endcode
 
 @param serverType Indicates which server to connect to. Each server corresponds to a NetworkManager instance.
 @param endpointPrefix The URL prefix of SOAP action. This is not used in REST and can be nil.
 @param service A webservice.asmx in SOAP or a main path component in REST.
 @param action The final component of path in REST or action in SOAP.
 */
- (void)requestWithEndpointPrefix:(NSString *)endpointPrefix service:(NSString *)service action:(NSString *)action type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *, NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion;

#pragma - mark form

- (void)requestMultipartFormURL:(NSString *)url type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters data:(NSArray<MKUMultipartInfo *> *)data completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completion;
- (void)downloadURL:(NSString *)url toFile:(NSString *)filname completion:(MKUServerResultErrorBlock)completion;

@property (nonatomic, weak) id<MKUServicesDelegate> serviceDelegate;

@end

@protocol MKUServicesDelegate <NSObject>

@optional

#pragma mark - SOAPEngine

- (NSString *)SOAPEngineLicenseKey;
- (NSMutableURLRequest *)service:(id<MKUServicesProtocol>)service didBeforeSendingURLRequest:(NSMutableURLRequest *)request;
- (NSData *)service:(id<MKUServicesProtocol>)service didBeforeParsingResponseData:(NSData *)data;
- (void)service:(id<MKUServicesProtocol>)service didFailWithError:(NSError *)error;
- (void)service:(id<MKUServicesProtocol>)service didFinishLoading:(NSString *)stringXML dictionary:(NSDictionary *)dict;
- (BOOL)service:(id<MKUServicesProtocol>)service didReceiveResponseCode:(NSInteger)statusCode;

@end

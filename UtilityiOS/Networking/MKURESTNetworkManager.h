//
//  NetworkManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUNetworkManager.h"
#import "NSError+Utility.h"
#import "AFNetworking.h"

@interface MKURESTNetworkManager : MKUNetworkManager

/** @brief Encodes the parameters for request types
 @param types Any of MKU_NETWORK_CONTENT_TYPE */
- (void)encodeParametersForRequestTypes:(NSIndexSet *)types;
/** @brief By default encodes the parameters for HEAD and GET */
- (void)defaultEncodeParametersInURL;
+ (void)prettyPrintJSON:(NSDictionary *)dictionaryData;
- (void)requestWithPath:(NSString *)path type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *,NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion;

@end

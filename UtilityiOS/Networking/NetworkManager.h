//
//  NetworkManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+AFNetworking.h"
#import "ServerDefinitions.h"
#import "AFNetworking.h"

enum {
    NETWORK_MANAGER_TYPE_DEFAULT = 0,
    NETWORK_MANAGER_TYPE_BASE
};

@interface MultipartInfo : NSObject

@property (nonatomic, assign) NetworkContentType contentType;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSData *data;

@end

@interface NetworkManager : NSObject

+ (instancetype)instance;

/** @brief Adds a manger with the give base url. The managers are in a dictionary as follows:
 @code
 NSMutableDictionary<NSNumber *, AFHTTPSessionManager *> *managers
 @endcode
 The keys can come from an enum to keep track of by developer
 @note All services use managers[@0] by default, use the following for
 requests using added managers:
 @code
 - (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion;
 
 - (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completionHeaders:(ServerResultHeaderErrorBlock)completion;
 @endcode
 
 @param url Base url string
 */
- (void)addManagerWithBaseURLString:(NSString *)url;

/** @brief Adds a manger with the give base url. The managers are in a dictionary as follows:
 @code
 NSMutableDictionary<NSNumber *, AFHTTPSessionManager *> *managers
 @endcode
 The keys can come from an enum to keep track of by developer
 @note All services use managers[@0] by default, use the following for
 requests using added managers:
 @code
 - (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion;
 
 - (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completionHeaders:(ServerResultHeaderErrorBlock)completion;
 @endcode
 
 @param url Base url
 */
- (void)addManagerWithBaseURL:(NSURL *)url;

/** @param headers the keys are keys for header, values are header value */
- (void)setHeaders:(NSDictionary *)headers;
- (void)resetHeaders:(NSArray *)headers;
- (void)resetAuthorizationHeader;

/** @param headers the keys are keys for header, values are header value */
- (void)setHeaders:(NSDictionary *)headers managerAtIndex:(NSUInteger)index;
- (void)resetHeaders:(NSArray *)headers managerAtIndex:(NSUInteger)index;
- (void)resetAuthorizationHeaderForManagerAtIndex:(NSUInteger)index;

/** @brief Encodes the parameters for request types
 @param types Any of NetworkContentType */
- (void)encodeParametersForRequestTypes:(NSIndexSet *)types inURLForManagerAtIndex:(NSUInteger)index;
/** @brief By default encodes the parameters for HEAD and GET */
- (void)defaultEncodeParametersInURLForManagerAtIndex:(NSUInteger)index;

+ (void)prettyPrintJSON:(NSDictionary *)dictionaryData;

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion;
- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completionHeaders:(ServerResultHeaderErrorBlock)completion;

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completion:(ServerResultErrorBlock)completion;
- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completionHeaders:(ServerResultHeaderErrorBlock)completion;

- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion;
- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completionHeaders:(ServerResultHeaderErrorBlock)completion;

- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completion:(ServerResultErrorBlock)completion;
- (AFHTTPSessionManager *)requestManagerAtIndex:(NSUInteger)index URL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers completionHeaders:(ServerResultHeaderErrorBlock)completion;


- (NSMutableURLRequest *)requestMultipartFormURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters data:(NSArray<MultipartInfo *> *)data completion:(void (^ _Nullable )(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error))completion;
- (NSMutableURLRequest *)requestManagerAtIndex:(NSUInteger)index multipartFormURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters data:(NSArray<MultipartInfo *> *)data completion:(void (^ _Nullable )(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error))completion;

- (AFHTTPSessionManager *)downloadURL:(NSString *)url toFile:(NSString *)filname completion:(ServerResultErrorBlock)completion;
- (AFHTTPSessionManager *)downloadManagerAtIndex:(NSUInteger)index URL:(NSString *)url toFile:(NSString *)filname completion:(ServerResultErrorBlock)completion;

@end

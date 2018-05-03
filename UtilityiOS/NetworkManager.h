//
//  NetworkManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Constants.h"

typedef NS_ENUM(NSUInteger, NetworkRequestType) {
    NetworkRequestType_GET,
    NetworkRequestType_POST,
    NetworkRequestType_PUT,
    NetworkRequestType_DELETE,
    NetworkRequestType_HEAD,
    NetworkRequestType_PATCH
};

typedef NS_ENUM(NSUInteger, NetworkContentType) {
    NetworkContentType_JSON,
    NetworkContentType_HTML,
    NetworkContentType_OCTET,
    NetworkContentType_GZIP,
    NetworkContentType_JPEG
};

typedef void (^ServerResultErrorBlock) (id result, NSError *error);
typedef void (^ServerNumberErrorBlock) (NSNumber *num, NSError *error);
typedef void (^ServerArrayErrorBlock) (NSArray *arr, NSError *error);

@interface MultipartInfo : NSObject

@property (nonatomic, assign) NetworkContentType contentType;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSData *data;

@end

@interface NetworkManager : NSObject

+ (instancetype)instance;

/** 
 @param headers the keys are keys for header, values are header value
 **/
- (void)setHeaders:(NSDictionary *)headers;
- (void)resetHeaders:(NSArray *)headers;
- (void)resetAuthorizationHeader;

- (AFHTTPSessionManager *)requestURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters completion:(ServerResultErrorBlock)completion;

- (AFHTTPSessionManager *)requestMultipartFormURL:(NSString *)url type:(NetworkRequestType)type parameters:(NSDictionary *)parameters data:(NSArray<MultipartInfo *> *)data completion:(void (^ _Nullable )(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error))completion;

- (AFHTTPSessionManager *)downloadURL:(NSString *)url toFile:(NSString *)filname completion:(ServerResultErrorBlock)completion;

@end

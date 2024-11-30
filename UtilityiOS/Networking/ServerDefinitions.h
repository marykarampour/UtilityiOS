//
//  ServerDefinitions.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-11-28.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#ifndef ServerDefinitions_h
#define ServerDefinitions_h

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

typedef void (^ServerResultHeaderErrorBlock) (id result, NSDictionary *headers, NSError *error);
typedef void (^ServerResultErrorBlock) (id result, NSError *error);
typedef void (^ServerNumberErrorBlock) (NSNumber *num, NSError *error);
typedef void (^ServerArrayErrorBlock) (NSArray *arr, NSError *error);

#endif /* ServerDefinitions_h */

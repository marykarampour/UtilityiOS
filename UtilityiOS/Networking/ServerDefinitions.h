//
//  ServerDefinitions.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-11-28.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#ifndef ServerDefinitions_h
#define ServerDefinitions_h

#import "Constants.h"

typedef NS_ENUM(NSUInteger, NETWORK_REQUEST_TYPE) {
    NETWORK_REQUEST_TYPE_GET,
    NETWORK_REQUEST_TYPE_POST,
    NETWORK_REQUEST_TYPE_PUT,
    NETWORK_REQUEST_TYPE_DELETE,
    NETWORK_REQUEST_TYPE_HEAD,
    NETWORK_REQUEST_TYPE_PATCH
};

typedef NS_ENUM(NSUInteger, NETWORK_CONTENT_TYPE) {
    NETWORK_CONTENT_TYPE_JSON,
    NETWORK_CONTENT_TYPE_HTML,
    NETWORK_CONTENT_TYPE_OCTET,
    NETWORK_CONTENT_TYPE_GZIP,
    NETWORK_CONTENT_TYPE_JPEG
};

typedef void (^ServerResultHeaderErrorBlock) (id result, NSDictionary *headers, NSError *error);
typedef void (^ServerResultErrorBlock) (id result, NSError *error);
typedef void (^ServerNumberErrorBlock) (NSNumber *num, NSError *error);
typedef void (^ServerArrayErrorBlock) (NSArray *arr, NSError *error);

#endif /* ServerDefinitions_h */

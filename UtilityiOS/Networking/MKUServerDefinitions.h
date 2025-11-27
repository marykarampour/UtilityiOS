//
//  MKUServerDefinitions.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-11-28.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#ifndef MKUServerDefinitions_h
#define MKUServerDefinitions_h

#import "Constants.h"

typedef NS_ENUM(NSUInteger, MKU_NETWORK_REQUEST_TYPE) {
    MKU_NETWORK_REQUEST_TYPE_GET,
    MKU_NETWORK_REQUEST_TYPE_POST,
    MKU_NETWORK_REQUEST_TYPE_PUT,
    MKU_NETWORK_REQUEST_TYPE_DELETE,
    MKU_NETWORK_REQUEST_TYPE_HEAD,
    MKU_NETWORK_REQUEST_TYPE_PATCH
};

typedef NS_ENUM(NSUInteger, MKU_NETWORK_CONTENT_TYPE) {
    MKU_NETWORK_CONTENT_TYPE_JSON,
    MKU_NETWORK_CONTENT_TYPE_HTML,
    MKU_NETWORK_CONTENT_TYPE_OCTET,
    MKU_NETWORK_CONTENT_TYPE_GZIP,
    MKU_NETWORK_CONTENT_TYPE_JPEG
};

typedef void (^MKUServerResultHeaderErrorBlock) (id result, NSDictionary *headers, NSError *error);
typedef void (^MKUServerResultErrorBlock) (id result, NSError *error);
typedef void (^MKUServerStatusCodeResultErrorBlock) (NSInteger statusCode, id result, NSError *error);
typedef void (^MKUServerStatusCodeResultKeyErrorBlock) (NSInteger statusCode, id result, NSString *key, NSError *error);
typedef void (^MKUServerNumberErrorBlock) (NSNumber *num, NSError *error);
typedef void (^MKUServerArrayErrorBlock) (NSArray *arr, NSError *error);

#endif /* MKUServerDefinitions_h */

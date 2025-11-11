//
//  MKUNetworkManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-10-02.
//  Copyright © 2025 Prometheus Software. All rights reserved.
//

#import "MKUNetworkManager.h"
#import "MKURESTNetworkManager.h"

#ifdef ENABLE_SOAP
#import "MKUSOAPNetworkManager.h"
#endif

@implementation MKUMultipartInfo

@end

@interface MKUNetworkManager ()

@end

@implementation MKUNetworkManager

@synthesize serviceDelegate;

- (BOOL)isSOAP {
    return NO;
}

- (void)setHeaders:(NSDictionary *)headers {
}

- (void)resetHeaders:(NSArray *)headers {
}

- (void)resetAuthorizationHeader {
}

- (void)requestWithEndpointPrefix:(NSString *)endpointPrefix service:(NSString *)service action:(NSString *)action type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *,NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion {
}

- (void)downloadURL:(NSString *)url toFile:(NSString *)filname completion:(MKUServerResultErrorBlock)completion {
}


+ (id<MKUServicesProtocol>)managerWithBaseURLString:(NSString *)URL { 
    return [[self alloc] init];
}


- (void)requestMultipartFormURL:(NSString *)url type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters data:(NSArray<MKUMultipartInfo *> *)data completion:(void (^)(NSURLResponse *, id, NSError *))completion { 
}


@end

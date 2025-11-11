//
//  MKUSOAPNetworkManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-10-02.
//  Copyright © 2025 Prometheus Software. All rights reserved.
//

#import "MKUSOAPNetworkManager.h"
#import <SOAPEngine64/SOAPEngine.h>
#import "NSString+Utility.h"

@interface MKUSOAPNetworkManager () <SOAPEngineDelegate>

@end

@implementation MKUSOAPNetworkManager

- (BOOL)isSOAP {
    return YES;
}

+ (id<MKUServicesProtocol>)managerWithBaseURLString:(NSString *)URL {
    MKUSOAPNetworkManager *obj = [[MKUSOAPNetworkManager alloc] init];
    obj.serverBaseURL = URL;
    return obj;
}

- (void)requestWithEndpointPrefix:(NSString *)endpointPrefix service:(NSString *)service action:(NSString *)action type:(MKU_NETWORK_REQUEST_TYPE)type parameters:(NSDictionary *)parameters headers:(NSDictionary<NSString *,NSString *> *)headers completionHandler:(MKUServerStatusCodeResultErrorBlock)completion {
    
    NSString *URL = [NSString combineString:self.serverBaseURL withString:service delimiter:nil];
    NSString *SOAPAction = [NSString combineString:endpointPrefix withString:action delimiter:nil];
    SOAPEngine *obj = [self SOAPObject];
    
    [obj requestURL:URL soapAction:SOAPAction value:parameters completeWithDictionary:^(NSInteger statusCode, NSDictionary *dict) {
        completion(statusCode, dict, nil);
    } failWithError:^(NSError *error) {
        completion(obj.statusCode, nil, error);
    }];
}

- (SOAPEngine *)SOAPObject {
    SOAPEngine *soap = [[SOAPEngine alloc] init];
    
    if ([self.serviceDelegate respondsToSelector:@selector(SOAPEngineLicenseKey)])
        soap.licenseKey = [self.serviceDelegate SOAPEngineLicenseKey];
    
    soap.userAgent = @"SOAPEngine";
    soap.actionNamespaceSlash = YES;
    soap.replaceNillable = YES;
    soap.escapingHTML = YES;
    soap.defaultTagName = nil;
    soap.delegate = self;
    soap.requestTimeout = 60.0;
    soap.dateFormat = DateFormatFullStyle;
    //soap.retrievesAttributes = YES;
    return soap;
}

#pragma mark - SOAPEngine Delegate

- (NSMutableURLRequest *)soapEngine:(SOAPEngine *)soapEngine didBeforeSendingURLRequest:(NSMutableURLRequest *)request {
    if ([self.serviceDelegate respondsToSelector:@selector(service:didBeforeSendingURLRequest:)]) {
        return [self.serviceDelegate service:self didBeforeSendingURLRequest:request];
    }
    return request;
}

- (NSData *)soapEngine:(SOAPEngine *)soapEngine didBeforeParsingResponseData:(NSData *)data {
    if ([self.serviceDelegate respondsToSelector:@selector(service:didBeforeParsingResponseData:)]) {
        return [self.serviceDelegate service:self didBeforeParsingResponseData:data];
    }
    return data;
}

- (void)soapEngine:(SOAPEngine *)soapEngine didFailWithError:(NSError *)error {
    if ([self.serviceDelegate respondsToSelector:@selector(service:didFailWithError:)]) {
        [self.serviceDelegate service:self didFailWithError:error];
    }
}

- (void)soapEngine:(SOAPEngine *)soapEngine didFinishLoading:(NSString *)stringXML dictionary:(NSDictionary *)dict {
    if ([self.serviceDelegate respondsToSelector:@selector(service:didFinishLoading:dictionary:)]) {
        [self.serviceDelegate service:self didFinishLoading:stringXML dictionary:dict];
    }
}

- (BOOL)soapEngine:(SOAPEngine *)soapEngine didReceiveResponseCode:(NSInteger)statusCode {
    if ([self.serviceDelegate respondsToSelector:@selector(service:didReceiveResponseCode:)]) {
        [self.serviceDelegate service:self didReceiveResponseCode:statusCode];
    }
    return YES;
}

@end

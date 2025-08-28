//
//  NSError+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-11-30.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "NSError+Utility.h"

static NSErrorDomain const GENERIC_ERROR_DOMAIN = @"GENERIC_ERROR_DOMAIN";
static NSErrorUserInfoKey const GENERIC_ERROR_KEY = @"GENERIC_ERROR_KEY";

@implementation NSError (AFNetworking)

- (NSInteger)statusCode {
    NSHTTPURLResponse *resp = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    return resp.statusCode;
}

@end

@implementation NSError (Utility)

- (BOOL)isInternetConnectionOffline {
    return [self.localizedDescription isEqualToString:@"The Internet connection appears to be offline."];
}

+ (NSError *)errorWithMessage:(NSString *)message {
    if (message.length == 0) return nil;
    return [NSError errorWithDomain:NSLocalizedDescriptionKey code:0 userInfo:@{NSLocalizedDescriptionKey : message}];
}

+ (NSError *)errorWithCode:(NSInteger)code {
    if (code < 300) return nil;
    
    NSString *message;
    
    if (code < 400) {
        switch (code) {
            case 300:
                message = @"Multiple Choices";
                break;
            case 301:
                message = @"Moved Permanently";
                break;
            case 302:
                message = @"Found";
                break;
            case 303:
                message = @"See Other";
                break;
            case 304:
                message = @"Not Modified";
                break;
            case 305:
                message = @"Use Proxy";
                break;
            case 306:
                message = @"Switch Proxy";
                break;
            case 307:
                message = @"Temporary Redirect";
                break;
            case 308:
                message = @"Permanent Redirect";
                break;
            default:
                message = [NSString stringWithFormat:@"Redirected with status %ld", code];
                break;
        }
    }
    else if (code < 500) {
        switch (code) {
            case 400:
                message = @"Bad Request";
                break;
            case 401:
                message = @"Unauthorized";
                break;
            case 402:
                message = @"Payment Required";
                break;
            case 403:
                message = @"Forbidden";
                break;
            case 404:
                message = @"Not Found";
                break;
            case 405:
                message = @"Method Not Allowed";
                break;
            case 406:
                message = @"Not Acceptable";
                break;
            case 407:
                message = @"Proxy Authentication Required";
                break;
            case 408:
                message = @"Request Timeout";
                break;
            case 409:
                message = @"Conflict";
                break;
            case 410:
                message = @"Gone";
                break;
            case 411:
                message = @"Length Required";
                break;
            case 412:
                message = @"Precondition Failed";
                break;
            case 413:
                message = @"Payload Too Large";
                break;
            case 414:
                message = @"URI Too Long";
                break;
            case 415:
                message = @"Unsupported Media Type";
                break;
            case 416:
                message = @"Range Not Satisfiable";
                break;
            case 417:
                message = @"Expectation Failed";
                break;
            case 418:
                message = @"I'm a teapot";
                break;
            case 421:
                message = @"Misdirected Request";
                break;
            case 422:
                message = @"Unprocessable Content";
                break;
            case 423:
                message = @"Locked";
                break;
            case 424:
                message = @"Failed Dependency";
                break;
            case 425:
                message = @"Too Early";
                break;
            case 426:
                message = @"Upgrade Required";
                break;
            case 428:
                message = @"Precondition Required";
                break;
            case 429:
                message = @"Too Many Requests";
                break;
            case 431:
                message = @"Request Header Fields Too Large";
                break;
            case 451:
                message = @"Unavailable For Legal Reasons";
                break;
            default:
                message = [NSString stringWithFormat:@"Failed with error %ld", code];
                break;
        }
    }
    else {
        switch(code) {
            case 500:
                message = @"Internal Server Error";
                break;
            case 501:
                message = @"Not Implemented";
                break;
            case 503:
                message = @"Service Unavailable";
                break;
            case 504:
                message = @"Gateway Timeout";
                break;
            case 505:
                message = @"HTTP Version Not Supported";
                break;
            case 506:
                message = @"Variant Also Negotiates";
                break;
            case 507:
                message = @"Insufficient Storage";
                break;
            case 508:
                message = @"Loop Detected";
                break;
            case 510:
                message = @"Not Extended";
                break;
            case 511:
                message = @"Network Authentication Required";
                break;
            default:
                message = [NSString stringWithFormat:@"Failed with error %ld", code];
                break;
        }
    }
    
    if (message)
        return [NSError errorWithDomain:NSLocalizedDescriptionKey code:code userInfo:@{NSLocalizedDescriptionKey:message}];
    
    return nil;
}

@end

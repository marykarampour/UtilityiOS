//
//  ServerEndpoints.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-26.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "ServerEndpoints.h"

@implementation ServerEndpoints

+ (NSString *)AUTH {
    return @"/api/v1/auth";
}

+ (NSString *)LOGOUT {
    return @"/api/v1/logout";
}

@end

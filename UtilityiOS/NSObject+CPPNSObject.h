//
//  NSObject+CPPNSObject.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-30.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <string>

@interface NSObject (CPPNSObject)

- (std::string)NSStringToCPPString:(NSString *)string;
- (NSString *)CPPStringToNSString:(std::string)string;

@end

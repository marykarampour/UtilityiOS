//
//  NSString+CPP.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-09-15.
//  Copyright © 2025 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>

@interface NSString (CPP)

- (std::string)CPPString;
+ (NSString *)stringWithCPPString:(std::string)CPPString;

@end

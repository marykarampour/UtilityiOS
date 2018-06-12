//
//  MKBadgeItem.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKBadgeItem.h"

@implementation MKBadgeItem

- (NSString *)keyForBadge {
    return self.name;
}

- (NSString *)description {
    NSInteger count = self.count.integerValue;
    if (count > 0) {
        return [self.count stringValue];
    }
    else if (count < 0) {
        return @"!";
    }
    return @"";
}

@end

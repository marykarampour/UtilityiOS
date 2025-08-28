//
//  NSString+CellStyle.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-12-29.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "NSString+CellStyle.h"

@implementation NSString (TitleSubTitle)

- (NSString *)title {
    return self.length == 0 ? @"None" : self;
}

@end

@implementation NSString (MKUSearch)

+ (NSString *)searchPredicateKey {
    return nil;
}

- (BOOL)hasDetail {
    return NO;
}

- (NSUInteger)numberOfLines {
    return 1;
}

@end

@implementation NSString (CellStyle)

@end

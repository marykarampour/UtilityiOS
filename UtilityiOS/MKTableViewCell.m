//
//  MKTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKTableViewCell.h"

@implementation MKTableViewCell

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"k%@Identifier", NSStringFromClass([self class])];
}

+ (CGFloat)estimatedHeight {
    return DefaultRowHeight;
}

@end

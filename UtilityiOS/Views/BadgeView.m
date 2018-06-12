//
//  BadgeView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "BadgeView.h"

@implementation BadgeView

- (instancetype)init {
    return [self initWithText:@""];
}

- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        self.text = text;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [AppTheme badgeTextColor];
        self.font = [AppTheme smallLabelFont];
        self.backgroundColor = [AppTheme badgeBackgroundColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = [Constants BadgeHeight]/2;
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    float width = (text.length > 1 ? ([Constants BadgeHeight]*(1+(float)(text.length/3.0))) : [Constants BadgeHeight]);
    self.frame = CGRectMake(0.0, 0.0, width, [Constants BadgeHeight]);
}

@end

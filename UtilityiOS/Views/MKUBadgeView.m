//
//  MKUBadgeView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUBadgeView.h"
#import "UIView+Utility.h"

static CGFloat const BADGE_HEIGHT = 22.0;
static CGFloat const SPINNER_BADGE_SPACING = 4.0;

@implementation MKUBadgeView

- (instancetype)init {
    self = [super initWithViewCreationHandler:^UIView *{
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [AppTheme badgeTextColor];
        label.font = [AppTheme smallLabelFont];
        return label;
    }];
    
    if (self) {
        self.state = MKU_BADGE_VIEW_STATE_RED;
        self.clipsToBounds = YES;
        self.backgroundColor = [AppTheme badgeBackgroundColor];
        self.layer.cornerRadius = [Constants BadgeHeight]/2;
    };
    return self;
}

- (CGSize)setText:(NSString *)text {
    self.view.text = text;
    CGFloat width = 0.0;
    if (0 < text.length)
        width = (1 < text.length ? ([Constants BadgeHeight]*(1 + (CGFloat)(text.length / 4.0))) : [Constants BadgeHeight]);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, [Constants BadgeHeight]);
    return self.frame.size;
}

- (void)setState:(MKU_BADGE_VIEW_STATE)state {
    _state = state;
    self.backgroundColor = state == MKU_BADGE_VIEW_STATE_RED ? [UIColor redColor] : [UIColor systemGreenColor];
}

@end


@interface MKUBadgeSpinnerView ()

@property (nonatomic, strong, readwrite) MKUBadgeView *badgeView;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *spinnerView;

@end

@implementation MKUBadgeSpinnerView

- (instancetype)init {
    if (self = [super init]) {
        self.badgeView = [[MKUBadgeView alloc] init];
        self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        
        [self addSubview:self.badgeView];
        [self addSubview:self.spinnerView];
        
        [self removeConstraintsMask];
        [self constraintWidth:BADGE_HEIGHT forView:self.spinnerView];
        [self constraintHeight:BADGE_HEIGHT forView:self.spinnerView];
        [self constraintHorizontally:@[self.spinnerView, self.badgeView] interItemMargin:SPINNER_BADGE_SPACING horizontalMargin:0.0 verticalMargin:0.0 equalWidths:NO];
    }
    return self;
}

- (CGSize)setText:(NSString *)text {
    [self.badgeView setText:text];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.badgeView.frame.size.width + SPINNER_BADGE_SPACING + BADGE_HEIGHT, BADGE_HEIGHT);
    return self.frame.size;
}

@end

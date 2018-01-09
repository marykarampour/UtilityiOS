//
//  MKSpinner.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKSpinner.h"
#import "UIView+Utility.h"

@interface MKSpinner ()

@property (nonatomic, strong) UIActivityIndicatorView *hud;
@property (nonatomic, strong) UIView *back;
@property (nonatomic, assign) CGFloat hudWidth;
@property (nonatomic, assign) CGFloat hudHeight;

@end

@implementation MKSpinner

+ (MKSpinner *)spinner {
    static MKSpinner *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MKSpinner alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.frame = [[UIScreen mainScreen] bounds];
        [self setViews];
        [self setHidden:YES];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height {
    self.hudWidth = width;
    self.hudHeight = height;
}

+ (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MKSpinner spinner].frame = [[UIScreen mainScreen] bounds];
        [[MKSpinner spinner] setViews];
        [[MKSpinner spinner].hud startAnimating];
        [[MKSpinner spinner] setHidden:NO];
    });
}

+ (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MKSpinner spinner].hud stopAnimating];
        [[MKSpinner spinner] setHidden:YES];
    });
}

- (void)orientationChanged {
    if (![MKSpinner spinner].hidden) {
        [MKSpinner hide];
        [MKSpinner show];
    }
}

- (void)setViews {
    [self removeConstraints:self.constraints];
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    self.back = [[UIView alloc] init];
    self.back.layer.cornerRadius = 10.0;
    self.back.alpha = 0.75;
    self.back.backgroundColor = [UIColor blackColor];
    [self.back setHidden:NO];
    self.hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.hud setColor:[UIColor whiteColor]];
    [self.hud setCenter:self.center];
    [self.hud setHidden:NO];
    
    [self addSubview:self.back];
    [self.back addSubview:self.hud];
    [self bringSubviewToFront:self.back];
    
    [self removeConstraintsMask];
    [self.back removeConstraintsMask];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[back(%f)]", self.hudWidth] options:0 metrics:nil views:@{@"back":self.back}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[back(%f)]", self.hudHeight] options:0 metrics:nil views:@{@"back":self.back}]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.back attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.back attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.back addConstraint:[NSLayoutConstraint constraintWithItem:self.hud attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.back attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.back addConstraint:[NSLayoutConstraint constraintWithItem:self.hud attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.back attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

@end

//
//  MKUSpinner.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUSpinner.h"
#import "UIView+Utility.h"

@interface MKUSpinner ()

@property (nonatomic, strong) UIActivityIndicatorView *hud;
@property (nonatomic, strong) UIView *back;
@property (nonatomic, assign) CGFloat hudWidth;
@property (nonatomic, assign) CGFloat hudHeight;

@end

@implementation MKUSpinner

+ (MKUSpinner *)spinner {
    static MKUSpinner *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MKUSpinner alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
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
        [MKUSpinner spinner].frame = [[UIScreen mainScreen] bounds];
        [[MKUSpinner spinner] setViews];
        [[MKUSpinner spinner].hud startAnimating];
        [[MKUSpinner spinner] setHidden:NO];
        [[MKUSpinner spinner].superview bringSubviewToFront:[MKUSpinner spinner]];
    });
}

+ (void)hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MKUSpinner spinner].hud stopAnimating];
        [[MKUSpinner spinner] setHidden:YES];
    });
}

- (void)orientationChanged {
    if (![MKUSpinner spinner].hidden) {
        [MKUSpinner hide];
        [MKUSpinner show];
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
    
    self.hud = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    [self.hud setColor:[UIColor whiteColor]];
    [self.hud setCenter:self.center];
    [self.hud setHidden:NO];
    
    [self addSubview:self.back];
    [self.back addSubview:self.hud];
    [self bringSubviewToFront:self.back];
    
    [self removeConstraintsMask];
    [self.back removeConstraintsMask];
    
    [self constraintWidth:self.hudWidth forView:self.back];
    [self constraintHeight:self.hudHeight forView:self.back];
    [self constraint:NSLayoutAttributeCenterX view:self.back];
    [self constraint:NSLayoutAttributeCenterY view:self.back];
    [self.back constraint:NSLayoutAttributeCenterX view:self.hud];
    [self.back constraint:NSLayoutAttributeCenterY view:self.hud];
}

@end

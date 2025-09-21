//
//  LoginViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Utility.h"
#import "LoginManager.h"
#import "MKULabel.h"

typedef NS_ENUM(NSUInteger, TextFieldIndex) {
    TextFieldIndexUsername,
    TextFieldIndexPassword,
    TextFieldIndexCount
};

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) LoginManager *loginManager;
@property (nonatomic, strong, readwrite) MKUStackedViews<MKUTextField *> *loginView;
@property (nonatomic, strong) MKULabel *versionLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [AppTheme VCBackgroundColor];

    self.button = [[UIButton alloc] init];
    self.loginManager = [[LoginManager alloc] initWithViewController:self];
    
    self.loginView = [[MKUStackedViews alloc] initWithCount:TextFieldIndexCount viewCreationHandler:^UIView *(NSUInteger index) {
        MKUTextField *view = [[MKUTextField alloc] initWithPlaceholder:index == TextFieldIndexUsername ? [Constants Username_STR] : [Constants Password_STR]];
        [view setControllerDelegate:self.loginManager];
        return view;
    }];
        
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.button];

    self.versionLabel = [[MKULabel alloc] init];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.text = [Constants versionString];
    self.versionLabel.textColor = [AppTheme textLightColor];
    self.versionLabel.font = [AppTheme smallLabelFont];
    [self.view addSubview:self.versionLabel];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    gesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.loginView viewAtIndex:TextFieldIndexUsername].text = @"";
    [self.loginView viewAtIndex:TextFieldIndexPassword].text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.view removeConstraintsMask];
    
    [self.view constraintWidth:[Constants LoginViewWidth] forView:self.loginView];
    [self.view constraintHeight:2*[Constants TextFieldHeight] forView:self.loginView];
    [self.view constraint:NSLayoutAttributeCenterX view:self.loginView];
    [self.view constraint:NSLayoutAttributeCenterY view:self.loginView margin:-[Constants LoginViewInset]];
    [self.view constraint:NSLayoutAttributeCenterX view:self.versionLabel];
    [self.view constraint:NSLayoutAttributeBottom view:self.versionLabel margin:-[Constants VerticalSpacing]];
}

#pragma mark - actions

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

- (void)login {
    [self.loginManager performLoginWithUsername:[self.loginView viewAtIndex:TextFieldIndexUsername].text password:[self.loginView viewAtIndex:TextFieldIndexPassword].text];
}

@end

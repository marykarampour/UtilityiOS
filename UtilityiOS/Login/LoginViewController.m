//
//  LoginViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "LoginViewController.h"
#import "KeyboardAdjuster.h"
#import "UIView+Utility.h"
#import "LoginManager.h"
#import "MKBasicFormView.h"
#import "MKLabel.h"

typedef NS_ENUM(NSUInteger, TextFieldIndex) {
    TextFieldIndexUsername,
    TextFieldIndexPassword,
    TextFieldIndexCount
};

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) LoginManager *loginManager;
@property (nonatomic, strong, readwrite) MKBasicFormView *loginView;
@property (nonatomic, strong) MKLabel *versionLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [AppTheme VCBackgroundColor];

    self.loginManager = [[LoginManager alloc] initWithViewController:self];
    
    self.loginView = [[MKBasicFormView alloc] initWithTextFieldPlaceholders:@[[Constants Username_STR], [Constants Password_STR]] buttonTitle:[Constants Login_STR]];
    [self.loginView setTarget:self selector:@selector(login)];
    [self.loginView setDelegate:self.loginManager];

    [self.view addSubview:self.loginView];

    self.versionLabel = [[MKLabel alloc] init];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.text = [AppCommon versionString];
    self.versionLabel.textColor = [AppTheme textLightColor];
    self.versionLabel.font = [AppTheme smallLabelFont];
    [self.view addSubview:self.versionLabel];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    gesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.loginView setText:@"" atIndex:TextFieldIndexUsername];
    [self.loginView setText:@"" atIndex:TextFieldIndexPassword];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.loginManager.viewAdjuster registerObserver];

    [self.view removeConstraintsMask];
    
    [self.view constraintWidth:[Constants LoginViewWidth] forView:self.loginView];
    [self.view constraintHeight:[self.loginView height] forView:self.loginView];
    [self.view constraint:NSLayoutAttributeCenterX view:self.loginView];
    [self.view constraint:NSLayoutAttributeCenterY view:self.loginView margin:-[Constants LoginViewInset]];
    [self.view constraint:NSLayoutAttributeCenterX view:self.versionLabel];
    [self.view constraint:NSLayoutAttributeBottom view:self.versionLabel margin:-[Constants VerticalSpacing]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loginManager.viewAdjuster removeObserver];
}

#pragma mark - actions

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

- (void)login {
    [self.loginManager performLoginWithUsername:[self.loginView textAtIndex:TextFieldIndexUsername] password:[self.loginView textAtIndex:TextFieldIndexPassword]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

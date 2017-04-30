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

typedef NS_ENUM(NSUInteger, TextFieldIndex) {
    TextFieldIndexUsername,
    TextFieldIndexPassword,
    TextFieldIndexCount
};

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) LoginManager *loginManager;
@property (nonatomic, strong) MKBasicFormView *loginView;

@property (nonatomic, strong) KeyboardAdjuster *viewAdjuster;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationItem setHidesBackButton:YES];
    
    self.loginView = [[MKBasicFormView alloc] initWithTextFieldPlaceholders:@[@"Username", @"Password"] buttonTitle:@"Login"];
    [self.loginView setTarget:self selector:@selector(login)];
    
    [self.view addSubview:self.loginView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewAdjuster = [[KeyboardAdjuster alloc] initWithViewController:self];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    gesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.viewAdjuster registerObserver];
    
    [self.view removeConstraintsMask];
    NSDictionary *views = NSDictionaryOfVariableBindings(_loginView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_loginView(%f)]", [self.loginView height]] options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_loginView(%f)]", 400.0] options:0 metrics:nil views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-100.0]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewAdjuster removeObserver];
}

#pragma mark - actions

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

- (void)login {
    self.loginManager = [[LoginManager alloc] initWithViewController:self];
    [self.loginManager performLoginWithUsername:[self.loginView textAtIndex:TextFieldIndexUsername] password:[self.loginView textAtIndex:TextFieldIndexPassword]];
}

#pragma mark - textfields

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.viewAdjuster setReferenceView:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.loginView performAtTextFieldReturn:textField]) {
        [self login];
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

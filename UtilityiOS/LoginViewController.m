//
//  LoginViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginManager.h"
#import "LoginView.h"

@interface LoginViewController ()

@property (nonatomic, strong) LoginManager *loginManager;
@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginView = [[LoginView alloc] init];
    [self.loginView setTarget:self selector:@selector(login)];
}

- (void)login {
    self.loginManager = [[LoginManager alloc] initWithViewController:self];
    [self.loginManager performLoginWithUsername:[self.loginView usernameText] password:[self.loginView passwordText]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

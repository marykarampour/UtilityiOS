//
//  LoginView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "LoginView.h"
#import "MKTextField.h"
#import "UIButton+Theme.h"
#import "UIView+Utility.h"

static CGFloat const PADDING = 10.0;
static CGFloat const TEXTFIELD_HEIGHT = 54.0;
static CGFloat const SEPARATOR_LINE_SIZE = 1.0;


@interface LoginView ()

@property (nonatomic, strong) MKTextField *username;
@property (nonatomic, strong) MKTextField *password;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIView *userPassView;

@end

@implementation LoginView

- (instancetype)init {
    if (self = [super init]) {
        self.username = [[MKTextField alloc] initWithPlaceholder:NSLocalizedString(@"Username", nil) type:TextFieldTypePlain];
        self.password = [[MKTextField alloc] initWithPlaceholder:NSLocalizedString(@"Password", nil) type:TextFieldTypePlain];
        self.login = [UIButton buttonWithCustomType:CustomButtonTypeBold];
        self.userPassView = [[UIView alloc] init];
        self.userPassView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.67];
        self.userPassView.layer.cornerRadius = ButtonCornerRadious;
        self.userPassView.layer.masksToBounds = YES;
        
        [self addSubview:self.login];
        [self addSubview:self.userPassView];
        [self.userPassView addSubview:self.username];
        [self.userPassView addSubview:self.password];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_username, _password, _login);
        [self removeConstraintsMask];
        [self.userPassView removeConstraintsMask];
        
        [self.userPassView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[_username]-0-|"] options:0 metrics:nil views:views]];
        [self.userPassView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_username]-(%f)-[_password(==_username)]-0-|", SEPARATOR_LINE_SIZE] options:NSLayoutFormatAlignAllRight | NSLayoutFormatAlignAllLeft metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[_login]-(%f)-|", PADDING*2, PADDING*2] options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[loginTextFieldsViewContainer(%f)]-(%f)-[loginButton(%f)]]", PADDING *2, TEXTFIELD_HEIGHT*2+SEPARATOR_LINE_SIZE, PADDING*2, DefaultRowHeight] options:NSLayoutFormatAlignAllRight | NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    }
    return self;
}


@end

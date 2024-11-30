//
//  LoginManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-25.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "LoginManager.h"
#import "NSObject+Alert.h"
#import "SplitViewManager.h"
#import "ServerController.h"

@interface LoginManager ()

@property (nonatomic, weak) __kindof LoginViewController *viewController;
@property (nonatomic, strong, readwrite) KeyboardAdjuster *viewAdjuster;

@end

@implementation LoginManager

- (instancetype)initWithViewController:(__kindof LoginViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
        self.viewAdjuster = [[KeyboardAdjuster alloc] initWithViewController:self.viewController];
    }
    return self;
}

- (void)performLoginWithUsername:(NSString *)username password:(NSString *)passsword {
    [ServerController auth:username password:passsword completion:^(id result, NSError *error) {
        if (!error && result) {
            [[SplitViewManager instance].splitViewController animateLogin];
        }
        else {
            [self OKAlertWithTitle:[Constants Login_Failed_Title_STR] message:[Constants Login_Failed_Message_STR]];
        }
    }];
}

- (void)handleTextFieldBeginEditing:(__kindof UITextField *)textField {
     [self.viewAdjuster setReferenceView:textField];
}



@end

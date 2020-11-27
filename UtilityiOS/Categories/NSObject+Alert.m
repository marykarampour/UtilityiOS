//
//  NSObject+Alert.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-31.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "NSObject+Alert.h"
#import "UIViewController+Utility.h"
#import "ServerController.h"
#import "MKAppDelegate.h"
#import "MKSpinner.h"

@implementation NSObject (Alert)
+ (void)displayToastWithTitle:(NSString *)title {
    [self displayToastWithTitle:title message:nil];
}

+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([Constants Toast_Length_Seconds] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR] style:UIAlertActionStyleDefault handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAAnimationLinear completion:nil];
    });
}

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction {
    NSArray *actions = @[[ActionObject actionWithTitle:[Constants OK_STR] target:self action:alertAction]];
    [self actionAlertWithTitle:title message:message alertActions:actions];
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction {
    NSArray *actions = @[[ActionObject actionWithTitle:[Constants OK_STR] target:self action:alertAction],
                         [ActionObject actionWithTitle:[Constants Cancel_STR] target:self action:nil]];
    [self actionAlertWithTitle:title message:message alertActions:actions];
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray<ActionObject *> *)alertActions {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (ActionObject *act in alertActions) {
        [alert addAction:[UIAlertAction actionWithTitle:act.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([act.target respondsToSelector:act.action]) {
                [act.target performSelector:act.action withObject:act.object];
            }
        }]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAAnimationLinear completion:nil];
    });
}

- (void)textFieldAlertWithUserID:(__kindof NSObject *)userID passName:(NSString *)passName successAction:(ActionObject *)successAction {
    [self textFieldAlertWithTitle:nil userID:userID passName:passName successAction:successAction];
}

- (void)textFieldAlertWithTitle:(NSString *)title userID:(__kindof NSObject *)userID passName:(NSString *)passName successAction:(ActionObject *)successAction {
    
    NSString *message = [NSString stringWithFormat:[Constants Enter_BLANK_STR], passName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *passText;
    
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MKSpinner show];
        [ServerController authWithUserID:userID password:passText.text completion:^(id result, NSError *error) {
            [MKSpinner hide];
            if (!error && result) {
                if ([successAction.target respondsToSelector:successAction.action]) {
                    [successAction.target performSelector:successAction.action];
                }
            }
            else {
                NSString *errorTitle = [NSString stringWithFormat:[Constants Incorrect_BLANK_STR], passName];
                [self textFieldAlertWithTitle:errorTitle userID:userID passName:passName successAction:successAction];
            }
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = passName;
        textField.secureTextEntry = YES;
        passText = textField;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAAnimationLinear completion:nil];
    });
}

- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message target:(NSObject<UITextFieldDelegate> *)target alertAction:(SEL)alertAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *alertText;
    
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([target respondsToSelector:alertAction]) {
            [target performSelector:alertAction withObject:alertText.text];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = NO;
        textField.delegate = target;
        alertText = textField;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAAnimationLinear completion:nil];
    });
}

#pragma mark - helpers

- (UIViewController *)presentingVC  {
    if ([self isKindOfClass:[UIViewController class]]) return (UIViewController *)self;
    MKAppDelegate *app = (MKAppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = [app visibleViewController];
    return vc;
}

@end

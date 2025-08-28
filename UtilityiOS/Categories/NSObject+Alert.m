//
//  NSObject+Alert.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-12-31.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "NSObject+Alert.h"
#import "UIViewController+Utility.h"
#import "UIViewController+Navigation.h"
#import "ServerController.h"
#import "MKUAppDelegate.h"
#import "MKUSpinner.h"

@implementation NSObject (Alert)

+ (void)displayToastWithTitle:(NSString *)title {
    [self displayToastWithTitle:title message:nil];
}

+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message {
    [self displayToastWithTitle:title message:message duration:4];
}

+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)duration {
    if (title.length == 0 && message.length == 0) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAMediaTimingFunctionLinear completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self presentingVC] dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message {
    if (title.length == 0 && message.length == 0) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR]  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAMediaTimingFunctionLinear completion:nil];
    });
}

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction {
    NSArray *actions = @[[ActionObject actionWithTitle:[Constants OK_STR] target:self action:alertAction]];
    [self actionAlertWithTitle:title message:message alertActions:actions];
}

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message defaultTitle:(NSString *)defaultTitle {
    NSString *text = [NSString notnullString:title defaultText:defaultTitle];
    [self OKAlertWithTitle:text message:message];
}

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message alertActionHandler:(void (^)(void))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) handler();
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animated:YES completion:nil];
    });
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction {
    NSArray *actions = @[[ActionObject actionWithTitle:[Constants OK_STR] target:self action:alertAction],
                         [ActionObject actionWithTitle:[Constants Cancel_STR] target:self action:nil]];
    [self actionAlertWithTitle:title message:message alertActions:actions];
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction target:(id)target {
    NSArray *actions = alertAction ?
    @[[ActionObject actionWithTitle:[Constants OK_STR] target:target action:alertAction], [ActionObject actionWithTitle:[Constants Cancel_STR] target:self action:nil]] :
    @[[ActionObject actionWithTitle:[Constants OK_STR] target:target action:nil]];
    
    [self actionAlertWithTitle:title message:message alertActions:actions];
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray<ActionObject *> *)alertActions {
    [self actionAlertWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert alertActions:alertActions];
}

- (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray<ActionObject *> *)alertActions {
    [self actionAlertWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet alertActions:alertActions];
}

- (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message titles:(StringArr *)titles actionHandler:(void (^)(NSUInteger))handler {
    [self actionSheetWithTitle:title message:message titles:titles sourceView:nil actionHandler:handler];
}

- (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message titles:(StringArr *)titles sourceView:(UIView *)sourceView actionHandler:(void (^)(NSUInteger))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIViewController *vc = [self presentingVC];
    BOOL hasCancel = [titles containsObject:[Constants Cancel_STR]];
    
    alert.popoverPresentationController.sourceRect = sourceView ? [sourceView frame] : CGRectMake(vc.view.frame.size.width / 2.0, vc.view.frame.size.height, 1.0, 1.0);
    alert.popoverPresentationController.sourceView = sourceView ? sourceView : vc.view;
    alert.popoverPresentationController.permittedArrowDirections = 0;
    
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:[Constants Cancel_STR]]) {
            [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
        }
        else {
            [alert addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                handler(idx);
            }]];
        }
    }];
    
    if (!hasCancel) {
        [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alert animationType:kCATransitionFade timingFunction:kCAMediaTimingFunctionLinear completion:nil];
    });
}

//https://stackoverflow.com/a/70761707/2197292
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActions:(NSArray<ActionObject *> *)alertActions {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIViewController *vc = [self presentingVC];
    BOOL hasCancel = NO;
    
    if (preferredStyle == UIAlertControllerStyleActionSheet) {
        alert.popoverPresentationController.sourceRect = CGRectMake(vc.view.frame.size.width / 2.0, vc.view.frame.size.height, 1.0, 1.0);
        alert.popoverPresentationController.sourceView = vc.view;
        alert.popoverPresentationController.permittedArrowDirections = 0;
    }
    
    for (ActionObject *act in alertActions) {
        if (act.action) {
            [alert addAction:[UIAlertAction actionWithTitle:act.title style:act.style handler:^(UIAlertAction * _Nonnull action) {
                if ([act.target respondsToSelector:act.action]) {
                    [act.target performSelectorOnMainThread:act.action withObject:act.object waitUntilDone:YES];
                }
            }]];
        }
        else if (!hasCancel) {
            NSString *title = 0 < act.title.length ? act.title : [Constants Cancel_STR];
            hasCancel = YES;
            [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
        }
    }
    
    if (preferredStyle == UIAlertControllerStyleActionSheet && !hasCancel) {
        [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alert animationType:kCATransitionFade timingFunction:kCAMediaTimingFunctionLinear completion:nil];
    });
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActionHandler:(void (^)(void))handler {
    [self actionAlertWithTitle:title message:message type:MKU_ACTION_ALERT_TYPE_OK alertActionHandler:handler];
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message type:(MKU_ACTION_ALERT_TYPE)type alertActionHandler:(void (^)(void))handler {
    [self actionAlertWithTitle:title message:message type:type alertActionHandler:handler cancelActionHandler:nil];
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActionHandler:(void (^)(void))handler cancelActionHandler:(void (^)(void))cancelHandler {
    [self actionAlertWithTitle:title message:message type:MKU_ACTION_ALERT_TYPE_OK alertActionHandler:handler cancelActionHandler:cancelHandler];
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message type:(MKU_ACTION_ALERT_TYPE)type alertActionHandler:(void (^)(void))handler cancelActionHandler:(void (^)(void))cancelHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSString *positiveTitle = [self positiveTitleForType:type];
    NSString *negativeTitle = [self negativeTitleForType:type];
    
    [alert addAction:[UIAlertAction actionWithTitle:positiveTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) handler();
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:negativeTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) cancelHandler();
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animated:YES completion:nil];
    });
}

- (NSString *)positiveTitleForType:(MKU_ACTION_ALERT_TYPE)type {
    switch (type) {
        case MKU_ACTION_ALERT_TYPE_YESNO: return [Constants Yes_STR];
        case MKU_ACTION_ALERT_TYPE_RETRY: return [Constants Retry_STR];
        default:                          return [Constants OK_STR];
    }
}

- (NSString *)negativeTitleForType:(MKU_ACTION_ALERT_TYPE)type {
    switch (type) {
        case MKU_ACTION_ALERT_TYPE_YESNO: return [Constants No_STR];
        case MKU_ACTION_ALERT_TYPE_RETRY: return [Constants Cancel_STR];
        default:                          return [Constants Cancel_STR];
    }
}

- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActionHandlers:(TitleVoidActionHandlers)handlers {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIViewController *vc = [self presentingVC];
    __block BOOL hasCancel = NO;
    
    if (preferredStyle == UIAlertControllerStyleActionSheet) {
        alert.popoverPresentationController.sourceRect = CGRectMake(vc.view.frame.size.width / 2.0, vc.view.frame.size.height, 1.0, 1.0);
        alert.popoverPresentationController.sourceView = vc.view;
        alert.popoverPresentationController.permittedArrowDirections = 0;
    }
    
    [handlers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, VoidActionHandler  _Nonnull handler, BOOL * _Nonnull stop) {
        if (![key isEqualToString:[Constants Cancel_STR]] && handler != ^{}) {
            [alert addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                handler();
            }]];
        }
        else if (!hasCancel) {
            hasCancel = YES;
            [alert addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
        }
    }];
    
    if (preferredStyle == UIAlertControllerStyleActionSheet && !hasCancel) {
        [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alert animationType:kCATransitionFade timingFunction:kCAMediaTimingFunctionLinear completion:nil];
    });
}

- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message target:(NSObject<UITextFieldDelegate> *)target alertAction:(SEL)alertAction {
    [self textFieldAlertWithTitle:title message:message target:target alertActionHandler:^(NSString *text) {
        if ([target respondsToSelector:alertAction]) {
            [target performSelectorOnMainThread:alertAction withObject:text waitUntilDone:YES];
        }
    }];
}

- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message target:(NSObject<UITextFieldDelegate> *)target alertActionHandler:(void (^)(NSString *))handler {
    [self textFieldAlertWithTitle:title message:message defaultText:nil target:target alertActionHandler:handler];
}

- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString *)defaultText target:(NSObject<UITextFieldDelegate> *)target alertActionHandler:(void (^)(NSString *))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *alertText;
    
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) handler(alertText.text);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = NO;
        textField.delegate = target;
        textField.text = defaultText;
        alertText = textField;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAMediaTimingFunctionLinear completion:nil];
    });
}

- (void)passwordAlertWithUserID:(NSNumber *)userID target:(NSObject *)target successAction:(SEL)successAction {
    [self passwordAlertWithTitle:nil message:[Constants Enter_Password_STR] userID:userID target:target successActionHandler:^{
        if ([target respondsToSelector:successAction]) {
            [target performSelectorOnMainThread:successAction withObject:nil waitUntilDone:YES];
        }
    } cancelActionHandler:nil];
}

- (void)passwordAlertWithUserID:(NSNumber *)userID successActionHandler:(void (^)(void))handler {
    [self passwordAlertWithUserID:userID successActionHandler:handler cancelActionHandler:nil];
}

- (void)passwordAlertWithUserID:(NSNumber *)userID successActionHandler:(void (^)(void))handler cancelActionHandler:(void (^)(void))cancelHandler {
    [self passwordAlertWithTitle:nil message:[Constants Enter_Password_STR] userID:userID target:nil successActionHandler:handler cancelActionHandler:cancelHandler];
}

- (void)passwordAlertWithTitle:(NSString *)title message:(NSString *)message userID:(NSNumber *)userID target:(NSObject *)target successActionHandler:(void(^)(void))handler cancelActionHandler:(void (^)(void))cancelHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *passText;
    
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MKUSpinner show];
        [ServerController authWithUserID:userID password:passText.text completion:^(id result, NSError *error) {
            [MKUSpinner hide];
            if (!error && result) {
                if (handler) handler();
            }
            else {
                [self OKAlertWithTitle:[Constants Login_Failed_Title_STR] message:[Constants Login_Failed_Message_STR]];
            }
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:cancelHandler];
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [Constants Password_STR];
        textField.secureTextEntry = YES;
        passText = textField;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animated:YES completion:nil];
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
        [MKUSpinner show];
        [ServerController authWithUserID:userID password:passText.text completion:^(id result, NSError *error) {
            [MKUSpinner hide];
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

- (void)textFieldAlertWithTitle:(NSString *)title target:(NSObject *)target passName:(NSString *)passName successActionHandler:(void (^)(id))handler {
    
    NSString *message = [NSString stringWithFormat:[Constants Enter_BLANK_STR], passName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *userText;
    __block UITextField *passText;
    
    [alert addAction:[UIAlertAction actionWithTitle:[Constants OK_STR] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MKUSpinner show];
        [ServerController authWithUserID:userText.text password:passText.text completion:^(id result, NSError *error) {
            [MKUSpinner hide];
            if (!error && result) {
                if (handler) handler(result);
            }
            else {
                NSString *errorTitle = [NSString stringWithFormat:[Constants Incorrect_BLANK_STR], passName];
                [self textFieldAlertWithTitle:errorTitle target:target passName:passName successActionHandler:handler];
            }
        }];
    }]];
       
    [alert addAction:[UIAlertAction actionWithTitle:[Constants Cancel_STR] style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [Constants Username_STR];
        userText = textField;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = passName;
        textField.secureTextEntry = YES;
        passText = textField;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self presentingVC] presentViewController:alert animationType:kCATransitionFade timingFunction:kCAAnimationLinear completion:nil];
    });
}

- (UIViewController *)presentingVC  {
    if ([self isKindOfClass:[UIViewController class]]) return (UIViewController *)self;
    UIViewController *vc = [[MKUAppDelegate application] visibleViewController];
    return vc;
}

@end


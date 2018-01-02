//
//  NSObject+Alert.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-31.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionObject.h"

@interface NSObject (Alert)

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message;
/** @param alertAction the target of this is always self */
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction;
/** @param alertActions the target of these are specified in ActionObject objects */
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray <ActionObject *> *)alertActions;
/** @brief performs an auth service defined in the server controller
 @param userID the ID that needs to be passed to the server call method
 @param passName the name of the pass, e.g. Password, PIN, etc.
 @param successAction target and selector used when auth succeeded. The property title in ActionObject is not used
 */
- (void)textFieldAlertWithUserID:(__kindof NSObject *)userID passName:(NSString *)passName successAction:(ActionObject *)successAction;

- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message target:(NSObject <UITextFieldDelegate> *)target alertAction:(SEL)alertAction;

@end

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

+ (void)displayToastWithTitle:(NSString *)title;
+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message;
+ (void)displayToastWithTitle:(NSString *)title message:(NSString *)message duration:(NSTimeInterval)duration;

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message;
/** @param defaultTitle is used when title is empty, such as in service errors. */
- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message defaultTitle:(NSString *)defaultTitle;
- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message alertActionHandler:(void(^)(void))handler;

/** @param alertAction the target of this is always self */
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction;
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction target:(id)target;
/** @brief Uses default MKU_ACTION_ALERT_TYPE_OK */
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActionHandler:(void(^)(void))handler;
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message type:(MKU_ACTION_ALERT_TYPE)type alertActionHandler:(void(^)(void))handler;
/** @brief Uses default MKU_ACTION_ALERT_TYPE_OK */
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActionHandler:(void(^)(void))handler cancelActionHandler:(void(^)(void))cancelHandler;
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message type:(MKU_ACTION_ALERT_TYPE)type alertActionHandler:(void(^)(void))handler cancelActionHandler:(void(^)(void))cancelHandler;
/** @param handlers Use an empty handler ^{} or title Cancel for Cancel. */
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActionHandlers:(TitleVoidActionHandlers)handlers;
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActions:(NSArray <ActionObject *> *)alertActions;
/** @param alertActions the target of these are specified in ActionObject objects */
- (void)actionAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray <ActionObject *> *)alertActions;
/** @param alertActions the target of these are specified in ActionObject objects */
- (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray <ActionObject *> *)alertActions;
- (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message titles:(StringArr *)titles actionHandler:(void (^)(NSUInteger idx))handler;
- (void)actionSheetWithTitle:(NSString *)title message:(NSString *)message titles:(StringArr *)titles sourceView:(UIView *)sourceView actionHandler:(void (^)(NSUInteger idx))handler;
- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message target:(NSObject <UITextFieldDelegate> *)target alertAction:(SEL)alertAction;
- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message target:(NSObject <UITextFieldDelegate> *)target alertActionHandler:(void(^)(NSString * text))handler;
- (void)textFieldAlertWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString *)defaultText target:(NSObject <UITextFieldDelegate> *)target alertActionHandler:(void(^)(NSString * string))handler;

- (void)passwordAlertWithUserID:(NSNumber *)userID target:(NSObject *)target successAction:(SEL)successAction;
- (void)passwordAlertWithUserID:(NSNumber *)userID successActionHandler:(void(^)(void))handler;
- (void)passwordAlertWithUserID:(NSNumber *)userID successActionHandler:(void(^)(void))handler cancelActionHandler:(void(^)(void))cancelHandler;
- (void)passwordAlertWithTitle:(NSString *)title message:(NSString *)message userID:(NSNumber *)userID target:(NSObject *)target successActionHandler:(void(^)(void))handler cancelActionHandler:(void(^)(void))cancelHandler;

- (void)OKAlertWithTitle:(NSString *)title message:(NSString *)message alertAction:(SEL)alertAction;
/** @brief performs an auth service defined in the server controller
 @param userID the ID that needs to be passed to the server call method
 @param passName the name of the pass, e.g. Password, PIN, etc.
 @param successAction target and selector used when auth succeeded. The property title in ActionObject is not used
 */
- (void)textFieldAlertWithUserID:(__kindof NSObject *)userID passName:(NSString *)passName successAction:(ActionObject *)successAction;
- (void)textFieldAlertWithTitle:(NSString *)title userID:(__kindof NSObject *)userID passName:(NSString *)passName successAction:(ActionObject *)successAction;

@end

//
//  ActionObject.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-12-31.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUPair.h"

@interface ActionObject : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) NSObject *object;
/** @brief Default is UIAlertActionStyleDefault. */
@property (nonatomic, assign) UIAlertActionStyle style;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (NSArray <ActionObject *> *)actionsWithTitles:(StringArr *)titles target:(id)target action:(SEL)action;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action object:(NSObject *)object;
+ (instancetype)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action object:(NSObject *)object;
+ (NSArray <ActionObject *> *)actionsWithTitleObjects:(MKUPairArray <NSString *, NSObject *> *)titles target:(id)target action:(SEL)action;
+ (instancetype)actionWithAction:(SEL)action;
+ (instancetype)actionWithTarget:(id)target action:(SEL)action;
+ (instancetype)blankAction;

@end


@interface OptionObject : MKUModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) UIColor *iconColor;

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName iconColor:(UIColor *)iconColor;
+ (instancetype)optionWithTitle:(NSString *)title iconName:(NSString *)iconName iconColor:(UIColor *)iconColor;

@end

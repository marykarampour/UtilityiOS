//
//  ActionObject.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-31.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionObject : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (NSArray <ActionObject *> *)actionsWithTitles:(StringArr *)titles target:(id)target action:(SEL)action;

@end


@interface OptionObject : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconName;

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName;
+ (instancetype)optionWithTitle:(NSString *)title iconName:(NSString *)iconName;

@end

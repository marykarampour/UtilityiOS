//
//  MKUTextField.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControl+IndexPath.h"
#import "UITextField+NextControl.h"
#import "TextFieldController.h"

typedef NS_OPTIONS(NSUInteger, MKU_TEXT_FIELD_TYPE) {
    MKU_TEXT_FIELD_TYPE_DEFAULT = 1 << 0,
    MKU_TEXT_FIELD_TYPE_PLAIN   = 1 << 1,
    MKU_TEXT_FIELD_TYPE_SECURE  = 1 << 2,
    MKU_TEXT_FIELD_TYPE_BORDER  = 1 << 3,
    MKU_TEXT_FIELD_TYPE_CORNER  = 1 << 4
};

@interface MKUTextField : UITextField

@property (nonatomic, strong, readonly) TextFieldController *controller;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (instancetype)initWithPlaceholder:(NSString *)placeholder textType:(MKU_TEXT_TYPE)textType;
- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(MKU_TEXT_FIELD_TYPE)type textType:(MKU_TEXT_TYPE)textType;
- (instancetype)initWithTextType:(MKU_TEXT_TYPE)type;

- (void)setControllerDelegate:(id<TextFieldDelegate>)object;

@end

//
//  MKTextField.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKText.h"
//TODO: fix
typedef NS_ENUM(NSUInteger, TextFieldType) {
    TextFieldTypeDefault,
    TextFieldTypePlain  = 1 << 0,
    TextFieldTypeSecure = 1 << 1,
    TextFieldTypeBorder = 1 << 2
};

@interface MKTextField : UITextField

@property (nonatomic, strong, readonly) MKText *textObject;

- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(TextFieldType)type;

@end

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
    TextFieldTypePlain,
    TextFieldTypeSecure
};

@interface MKTextField : UITextField

@property (nonatomic, strong, readonly) MKText *textObject;

- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(TextFieldType)type;

@end

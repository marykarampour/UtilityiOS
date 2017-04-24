//
//  MKTextField.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TextFieldType) {
    TextFieldTypeDefault,
    TextFieldTypePlain,
    TextFieldTypeSecure
};

@interface MKTextField : UITextField

- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(TextFieldType)type;

@end

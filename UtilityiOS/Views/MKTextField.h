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
typedef NS_OPTIONS(NSUInteger, TextFieldType) {
    TextFieldTypeDefault = 1 << 0,
    TextFieldTypePlain   = 1 << 1,
    TextFieldTypeSecure  = 1 << 2,
    TextFieldTypeBorder  = 1 << 3
};

@interface MKTextField : UITextField

@property (nonatomic, strong, readonly) MKText *textObject;

- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(TextFieldType)type;

@end

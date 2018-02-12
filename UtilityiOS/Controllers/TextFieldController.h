//
//  TextFieldController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#warning -  make these clusters with text view
@class MKTextField;

@protocol TextFieldDelegate <NSObject>

@optional
- (void)handleTextFieldChanges:(__kindof UITextField *)textField;
- (void)handleTextFieldBeginEditing:(__kindof UITextField *)textField;

@end

@interface TextFieldController : NSObject

@property (nonatomic, weak) id<TextFieldDelegate> delegate;
@property (nonatomic, weak) MKTextField *textField;
@property (nonatomic, assign) NSUInteger maxLenght;
@property (nonatomic, assign) TextType type;

- (void)addTextField:(MKTextField *)view;

@end

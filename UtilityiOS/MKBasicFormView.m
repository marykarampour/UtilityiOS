//
//  LoginView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKBasicFormView.h"
#import "MKTextField.h"
#import "UIButton+Theme.h"
#import "UIView+Utility.h"
#import "UITextField+NextControl.h"

static CGFloat const PADDING = 10.0;
static CGFloat const TEXTFIELD_HEIGHT = 54.0;
static CGFloat const SEPARATOR_LINE_SIZE = 1.0;


@interface MKBasicFormView ()

@property (nonatomic, strong) NSMutableArray<MKTextField *> *textFields;
@property (nonatomic, strong) UIButton *login;
@property (nonatomic, strong) UIView *textFieldsView;

@end

@implementation MKBasicFormView

- (CGFloat)height {
    return PADDING*6 + TEXTFIELD_HEIGHT*self.textFields.count+SEPARATOR_LINE_SIZE*(self.textFields.count-1) + DefaultRowHeight;
}

- (instancetype)init {
    return [self initWithTextFieldPlaceholders:@[@""] buttonTitle:@""];
}

- (instancetype)initWithTextFieldPlaceholders:(StringArr *)texts buttonTitle:(NSString *)buttonTitle {
    if (self = [super init]) {
        if (texts.count) {
            self.textFields = [[NSMutableArray alloc] init];
            
            self.login = [UIButton buttonWithCustomType:CustomButtonTypeBold];
            [self.login setTitle:buttonTitle forState:UIControlStateNormal];
            self.login.backgroundColor = [UIColor blueColor];
            
            self.textFieldsView = [[UIView alloc] init];
            self.textFieldsView.layer.cornerRadius = [Constants ButtonCornerRadious];
            self.textFieldsView.layer.masksToBounds = YES;
            
            self.layer.cornerRadius = [Constants ButtonCornerRadious];
            self.layer.masksToBounds = YES;
            self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.67];
            
            [self addSubview:self.login];
            [self addSubview:self.textFieldsView];
            
            NSMutableDictionary *views = [[NSMutableDictionary alloc] initWithDictionary:NSDictionaryOfVariableBindings(_login, _textFieldsView)];
            
            __block NSString *verticalTXConstraint = @"";
            
            [texts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                MKTextField *textField = [[MKTextField alloc] initWithPlaceholder:NSLocalizedString(obj, nil) type:TextFieldTypePlain];
                [self.textFields addObject:textField];
                [self.textFieldsView addSubview:textField];
                [views setObject:textField forKey:[NSString stringWithFormat:@"textField%d", idx]];
                
                if (idx == 0) {
                    if (texts.count > 1) {
                        verticalTXConstraint = @"V:|-0-[textField0]";
                        textField.returnKeyType = UIReturnKeyNext;
                    }
                    else {
                        verticalTXConstraint = @"V:|-0-[textField0]-0-|";
                        textField.returnKeyType = UIReturnKeyDone;
                    }
                }
                else if (texts.count - 1 == idx) {
                    verticalTXConstraint = [NSString stringWithFormat:@"%@-(%f)-[textField%d(==textField0)]-0-|", verticalTXConstraint, SEPARATOR_LINE_SIZE, idx];
                    textField.returnKeyType = UIReturnKeyDone;
                }
                else {
                    verticalTXConstraint = [NSString stringWithFormat:@"%@-(%f)-[textField%d(==textField0)]", verticalTXConstraint, SEPARATOR_LINE_SIZE, idx];
                    textField.returnKeyType = UIReturnKeyNext;
                }
                if (texts.count > 1 && idx > 0 && texts.count > idx) {
                    [self.textFields[idx-1] setNextControl:textField];
                }
            }];
            
            [self removeConstraintsMask];
            [self.textFieldsView removeConstraintsMask];
            
            [self.textFieldsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[textField0]-0-|"] options:0 metrics:nil views:views]];
            [self.textFieldsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalTXConstraint options:NSLayoutFormatAlignAllRight | NSLayoutFormatAlignAllLeft metrics:nil views:views]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[_textFieldsView]-(%f)-|", PADDING*2, PADDING*2] options:0 metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[_textFieldsView(%f)]-(%f)-[_login(%f)]", PADDING*2, TEXTFIELD_HEIGHT*self.textFields.count+SEPARATOR_LINE_SIZE*(self.textFields.count-1), PADDING*2, [Constants DefaultRowHeight]] options:NSLayoutFormatAlignAllRight | NSLayoutFormatAlignAllLeft metrics:nil views:views]];
        }
    }
    return self;
}

- (void)setTarget:(id)object selector:(SEL)action {
    for (MKTextField *tx in self.textFields) {
        tx.delegate = object;
    }
    [self.login addTarget:object action:action forControlEvents:UIControlEventTouchUpInside];
}

- (NSString *)textAtIndex:(NSUInteger)index {
    return (self.textFields.count > index ? self.textFields[index].text : @"");
}

- (BOOL)performAtTextFieldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.textFields.count > 1 && self.textFields.lastObject != textField) {
        [textField.nextControl becomeFirstResponder];
        return NO;
    }
    return YES;
}


@end


//
//  LoginView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUBasicFormView.h"
#import "UIButton+MKUTheme.h"
#import "UIView+Utility.h"

static CGFloat const PADDING = 10.0;
static CGFloat const TEXTFIELD_HEIGHT = 54.0;
static CGFloat const SEPARATOR_LINE_SIZE = 1.0;


@interface MKUBasicFormView ()

@property (nonatomic, strong) NSMutableArray<MKUTextField *> *textFields;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *textFieldsView;
@property (nonatomic, assign) CGFloat height;

@end

@implementation MKUBasicFormView

- (CGFloat)height {
    return _height;
}

- (instancetype)init {
    return [self initWithTextFieldPlaceholders:@[@""] buttonTitle:@""];
}

- (instancetype)initWithTextFieldPlaceholders:(StringArr *)texts buttonTitle:(NSString *)buttonTitle {
    if (self = [super init]) {
        if (texts.count) {
            self.textFields = [[NSMutableArray alloc] init];
            
            self.button = [UIButton buttonWithType:UIButtonTypeSystem];
            [self.button setTitle:buttonTitle forState:UIControlStateNormal];
            self.button.backgroundColor = [AppTheme buttonBackgroundColor];//[AppTheme lightBlue];
            
            self.textFieldsView = [[UIView alloc] init];
            self.textFieldsView.layer.cornerRadius = [Constants ButtonCornerRadious];
            self.textFieldsView.layer.masksToBounds = YES;
            
            self.layer.cornerRadius = [Constants ButtonCornerRadious];
            self.layer.masksToBounds = YES;
            self.backgroundColor = [AppTheme translusentBackground];//[AppTheme nightBlue];
            
            [self addSubview:self.button];
            [self addSubview:self.textFieldsView];
            
            NSMutableDictionary *views = [[NSMutableDictionary alloc] initWithDictionary:NSDictionaryOfVariableBindings(_button, _textFieldsView)];
            
            __block NSString *verticalTXConstraint = @"";
            
            [texts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                MKUTextField *textField = [[MKUTextField alloc] initWithPlaceholder:obj type:MKU_TEXT_FIELD_TYPE_PLAIN textType:MKU_TEXT_TYPE_STRING];
                [self.textFields addObject:textField];
                [self.textFieldsView addSubview:textField];
                [views setObject:textField forKey:[NSString stringWithFormat:@"textField%lu", (unsigned long)idx]];
                
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
                    verticalTXConstraint = [NSString stringWithFormat:@"%@-(%f)-[textField%lu(==textField0)]-0-|", verticalTXConstraint, SEPARATOR_LINE_SIZE, (unsigned long)idx];
                    textField.returnKeyType = UIReturnKeyDone;
                }
                else {
                    verticalTXConstraint = [NSString stringWithFormat:@"%@-(%f)-[textField%lu(==textField0)]", verticalTXConstraint, SEPARATOR_LINE_SIZE, (unsigned long)idx];
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
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[_textFieldsView(%f)]-(%f)-[_button(%f)]", PADDING*2, TEXTFIELD_HEIGHT*self.textFields.count+SEPARATOR_LINE_SIZE*(self.textFields.count-1), PADDING*2, [Constants DefaultRowHeight]] options:NSLayoutFormatAlignAllRight | NSLayoutFormatAlignAllLeft metrics:nil views:views]];
            
            _height = PADDING*6 + TEXTFIELD_HEIGHT*self.textFields.count+SEPARATOR_LINE_SIZE*(self.textFields.count-1) + [Constants DefaultRowHeight];
        }
    }
    return self;
}

- (void)setTarget:(id)object selector:(SEL)action {
    [self.button addTarget:object action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDelegate:(id)object {
    for (MKUTextField *tx in self.textFields) {
        tx.delegate = object;
    }
}

- (NSString *)textAtIndex:(NSUInteger)index {
    return (self.textFields.count > index ? self.textFields[index].text : @"");
}

- (void)setText:(NSString *)text atIndex:(NSUInteger)index {
    if (index < self.textFields.count) {
        self.textFields[index].text = text;
    }
}

- (void)setTextFieldAtIndex:(NSUInteger)index secure:(BOOL)isSecure {
    if (index < self.textFields.count) {
        self.textFields[index].secureTextEntry = isSecure;
    }
}

- (BOOL)performAtTextFieldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.textFields.count > 1 && self.textFields.lastObject != textField) {
        [textField.nextControl becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)setPlaceholderText:(NSString *)text forTextFieldAtIndex:(NSUInteger)index {
    if (index < self.textFields.count) {
        [self.textFields[index] setPlaceholder:NSLocalizedString(text, nil)];
    }
}

- (NSInteger)indexOfTextField:(MKUTextField *)textField {
    if ([self.textFields containsObject:textField]) {
        return [self.textFields indexOfObject:textField];
    }
    return -1;
}

- (void)addBottomSubview:(UIView *)view {
    [self addSubview:view];
    [self removeConstraintsMask];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:_height]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:[Constants DefaultRowHeight]]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.button  attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.button  attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    
    _height += [Constants DefaultRowHeight] + 2*PADDING;
}


@end


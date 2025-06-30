//
//  MKUStepperFieldView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUStepperFieldView.h"
#import "NSNumber+Utility.h"
#import "NSString+Number.h"
#import "UIView+Utility.h"
#import "MKUTextField.h"

static CGFloat const PADDING = 8.0;
static CGFloat const HORIZONTAL_PADDING = 20.0;
static CGFloat const FIELD_WIDTH = 82.0;
static CGFloat const STEPPER_WIDTH = 90.0;

@implementation MKUStepperValueObject

- (instancetype)initWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end {
    if (self = [super init]) {
        self.title = title;
        self.value = value;
        self.start = start;
        self.end = end;
    }
    return self;
}

+ (instancetype)objectWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end {
    return [[self alloc] initWithTitle:title value:value start:start end:end];
}

@end

@interface MKUStepperFieldView () <TextFieldDelegate>

@property (nonatomic, strong, readwrite) MKULabel *titleLabel;
@property (nonatomic, strong, readwrite) UIStepper *stepper;
@property (nonatomic, strong) MKUTextField *valueField;

@end

@implementation MKUStepperFieldView

- (instancetype)init {
    return [self initWithTitle:@""];
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title value:0 start:0 end:1];
}

- (instancetype)initWithValues:(MKUStepperValueObject *)values {
    return [self initWithTitle:values.title value:values.value start:values.start end:values.end];
}

- (instancetype)initWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end {
    return [self initWithTitle:title value:value start:start end:end horizontalMargin:HORIZONTAL_PADDING];
}

- (instancetype)initWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end horizontalMargin:(CGFloat)horizontalMargin {
    if (self = [super init]) {
        
        self.titleLabel = [[MKULabel alloc] initWithText:title];
        self.valueField = [[MKUTextField alloc] init];
        self.valueField.text = [NSString stringWithFormat:@"%ld", (long)value];
        self.valueField.textAlignment = NSTextAlignmentCenter;
        [self.valueField setControllerDelegate:self];
        
        self.stepper = [[UIStepper alloc] init];
        [self.stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.stepper.minimumValue = start;
        self.stepper.value = value;
        self.stepper.maximumValue = end;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.valueField];
        [self addSubview:self.stepper];
        
        [self removeConstraintsMask];
        [self constraintWidth:STEPPER_WIDTH forView:self.stepper];
        [self constraintWidth:FIELD_WIDTH forView:self.valueField];
        [self constraintHeight:[Constants TextFieldHeight] forView:self.valueField];
        [self constraintHorizontally:@[self.titleLabel, self.valueField, self.stepper] interItemMargin:PADDING horizontalMargin:horizontalMargin verticalMargin:CONSTRAINT_NO_PADDING equalWidths:NO parentConstraints:NSLayoutAttributeLeft | NSLayoutAttributeRight verticalConstraints:NSLayoutAttributeNotAnAttribute];
        [self constraint:NSLayoutAttributeCenterY view:self.titleLabel];
        [self constraint:NSLayoutAttributeCenterY view:self.valueField];
        [self constraint:NSLayoutAttributeCenterY view:self.stepper];
    }
    return self;
}

- (void)setValues:(MKUStepperValueObject *)values {
    [self setTitle:values.title value:values.value start:values.start end:values.end];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end {
    self.titleLabel.text = title;
    self.stepper.minimumValue = start;
    self.stepper.maximumValue = end;
    self.stepper.value = value;
    
    [self didChangeValue:value];
}

- (void)setValue:(NSInteger)value start:(NSInteger)start end:(NSInteger)end {
    self.stepper.minimumValue = start;
    self.stepper.maximumValue = end;
    self.stepper.value = value;
    
    [self didChangeValue:value];
}

- (void)setValue:(NSInteger)value {
    self.stepper.value = value;
    
    [self didChangeValue:value];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.valueField.indexPath = indexPath;
    self.stepper.indexPath = indexPath;
}

- (void)addStepperTarget:(id)target action:(SEL)action {
    [self.stepper addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

- (void)stepperValueChanged:(UIStepper *)stepper {
    [self didChangeValue:stepper.value];
}

- (void)didChangeValue:(NSInteger)value {
    self.valueField.text = [NSString stringWithFormat:@"%ld", (long)value];
    if ([self.delegate respondsToSelector:@selector(stepper:didChangeValue:)]) {
        [self.delegate stepper:self.stepper didChangeValue:value];
    }
}

- (void)handleTextFieldEndEditing:(__kindof UITextField *)textField {
    
    NSNumber *num = [textField.text stringToNumber];
    num = [NSNumber numberWith:num min:@(self.stepper.minimumValue) max:@(self.stepper.maximumValue)];
    [self setValue:num.integerValue];
}

@end

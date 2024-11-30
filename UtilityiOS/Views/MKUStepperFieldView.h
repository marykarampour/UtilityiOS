//
//  MKUStepperFieldView.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKULabel.h"
#import "MKUModel.h"

@protocol MKUStepperFieldViewDelegate <NSObject>

@optional
- (void)stepper:(UIStepper *)stepper didChangeValue:(NSInteger)value;

@end

@interface MKUStepperValueObject : MKUModel

@property (nonatomic, assign) NSUInteger value;
@property (nonatomic, assign) NSUInteger start;
@property (nonatomic, assign) NSUInteger end;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end;
+ (instancetype)objectWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end;

@end

@interface MKUStepperFieldView : UIView

@property (nonatomic, strong, readonly) MKULabel *titleLabel;
@property (nonatomic, strong, readonly) UIStepper *stepper;
@property (nonatomic, weak) id<MKUStepperFieldViewDelegate> delegate;

- (instancetype)initWithValues:(MKUStepperValueObject *)values;
- (instancetype)initWithTitle:(NSString *)title;
/** @brief Default horizontalMargin is 20.0 */
- (instancetype)initWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end;
- (instancetype)initWithTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end horizontalMargin:(CGFloat)horizontalMargin;
- (void)setTitle:(NSString *)title;
- (void)setValues:(MKUStepperValueObject *)values;
- (void)setValue:(NSInteger)value;
- (void)setValue:(NSInteger)value start:(NSInteger)start end:(NSInteger)end;
- (void)setTitle:(NSString *)title value:(NSInteger)value start:(NSInteger)start end:(NSInteger)end;
- (void)addStepperTarget:(id)target action:(SEL)action;
- (void)setIndexPath:(NSIndexPath *)indexPath;

@end


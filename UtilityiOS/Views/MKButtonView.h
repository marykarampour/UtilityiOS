//
//  MKButtonView.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-17.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MultiLabelView.h"

@class MKButtonView;

@interface MKBackButton : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) MKButtonView *container;

@end

@protocol MKButtonProtocol <NSObject>

@optional
- (void)buttonView:(MKButtonView *)view setSelected:(BOOL)selected;

@end

@interface MKButtonView : MultiLabelView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, weak) id<MKButtonProtocol> delegate;

/** @brief By default user interaction is disabled on this button and no action is added, this button covers the entire view */
@property (nonatomic, strong, readonly) UIButton *backView;

- (void)setTarget:(id)target action:(SEL)action;
/** @brief Adds the action to container */
- (void)setActionOnContainer:(SEL)action;
- (void)setIndexPath:(NSIndexPath *)indexPath;

/** @brief Override to do work in setSelected
 @note Do not override setSelected, call super on this to notify the delegate on selected */
- (void)customizeSetSelected:(BOOL)selected;

/** @brief Override to switchOnOff
 @note Default is: self.selected = !self.selected */
- (void)switchOnOff:(UIButton *)sender;

@end

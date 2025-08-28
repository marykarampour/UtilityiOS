//
//  MKUPolymorphicViewProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUViewProtocol.h"

@protocol MKUSearchCriteriaViewDelegate;

@protocol MKUPolymorphicViewProtocol <NSObject>

@optional
+ (CGFloat)defaultHeight;
- (CGFloat)estimatedHeight;

/** @brief Call super first. */
- (void)reset;

/** @brief Initialize views that exist in addition to those inherited from superclass.
 It is expected that this also adds subviews.
 Call super first. */
- (void)initBase;

/** @brief This view's init will not constraint subviews automatically, it only initializes and adds them.
 Implement this method in subclasses to apply constraints.
 Call super first. */
- (void)constraintViews;

@end


@protocol MKUSearchCriteriaViewProtocol <MKUPolymorphicViewProtocol, MKUControlProtocol>

@required
/** @brief By default if type = MKU_UI_TYPE_IPHONE it addes a back button to hide and show this view. */
- (instancetype)initWithUIType:(MKU_UI_TYPE)type;
- (void)setTextFieldDelegate:(id<UITextFieldDelegate>)delegate;

+ (BOOL)hasBackButton;
+ (CGFloat)backButtonHeight;
/** @brief Default has height and sides except bottom. */
- (void)constraintBackButton;
/** @brief Default is 0.0. If you want content be under backButton, return backButtonHeight. */
+ (NSString *)backButtonShowTitle;
+ (NSString *)backButtonHideTitle;
+ (CGFloat)contentViewTopMargin;

- (void)setViewsHidden:(BOOL)hidden animated:(BOOL)animated withCompletion:(void (^)(BOOL finished))completion;

/** @brief Default adds this action to back button if hasBackButton = YES, otherwise, it does nothing. */
//- (void)addTarget:(id)target action:(SEL)action;

/** @brief Adds a back button to hide and show this view. */
- (void)addBackButton;

@property (nonatomic, weak) id<MKUSearchCriteriaViewDelegate> viewDelegate;

@end


@protocol MKUSearchCriteriaSingleViewProtocol <MKUSearchCriteriaViewProtocol>

@required
- (void)setupWithSingleView:(UIView *)singleView setterHandler:(void (^)(void))setterHandler;

@end


@protocol MKUSearchCriteriaViewDelegate <NSObject>

@optional
- (void)findView:(UIView <MKUSearchCriteriaViewProtocol> *)findView didSetViewsHidden:(BOOL)hidden;

@end


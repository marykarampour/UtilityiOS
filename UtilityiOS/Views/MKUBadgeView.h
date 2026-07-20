//
//  MKUBadgeView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUContainerView.h"

@interface MKUBadgeView : MKUContainerView <UILabel *>

@property (nonatomic, assign) MKU_BADGE_VIEW_STATE state;

/** @brief Returns the size of text. This size is used to set the frame size. */
- (CGSize)setText:(NSString *)text;
/** @param showZero if NO the view will be hidden. */
- (void)setCount:(NSUInteger)count showZero:(BOOL)showZero;

@end


@interface MKUBadgeSpinnerView : UIView

@property (nonatomic, strong, readonly) MKUBadgeView *badgeView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;

/** @brief Returns the size of text. This size is used to set the frame size. */
- (CGSize)setText:(NSString *)text;

@end

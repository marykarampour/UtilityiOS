//
//  MKUBadgeView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUContainerView.h"

typedef NS_ENUM(NSUInteger, MKU_BADGE_VIEW_STATE) {
    MKU_BADGE_VIEW_STATE_RED,
    MKU_BADGE_VIEW_STATE_GREEN
};

@interface MKUBadgeView : MKUContainerView <UILabel *>

@property (nonatomic, assign) MKU_BADGE_VIEW_STATE state;

/** @brief Returns the size of text. This size is used to set the frame size. */
- (CGSize)setText:(NSString *)text;

@end


@interface MKUBadgeSpinnerView : UIView

@property (nonatomic, strong, readonly) MKUBadgeView *badgeView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;

/** @brief Returns the size of text. This size is used to set the frame size. */
- (CGSize)setText:(NSString *)text;

@end

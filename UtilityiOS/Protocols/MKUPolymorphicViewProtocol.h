//
//  MKUPolymorphicViewProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUViewProtocol.h"

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

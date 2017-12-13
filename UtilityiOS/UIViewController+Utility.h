//
//  UIViewController+Utility.h
//  KaChing!
//
//  Created by Maryam Karampour on 2017-12-09.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utility)

/** @brief Use to add a view controller as a child view controller
 @param view will get the value of childVC.view. If view = nil self.view is used instead */
- (void)setChildView:(UIViewController * _Nonnull)childVC forSubView:(UIView * __strong *)view;

@end

//
//  UIViewController+Navigation.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Navigation)

- (void)popToViewControllerAtIndex:(NSUInteger)index;
/** @brief Pops to the first view controller in the hierarchy of the given class. */
- (void)popToViewControllerOfClass:(Class)cls;

- (UIViewController *)previousViewController;

/** @brief Default is full screen. */
- (void)presentViewController:(__kindof UIViewController *)VC animationType:(CATransitionSubtype)type timingFunction:(CAMediaTimingFunctionName)timingFunction completion:(void (^)(void))completion;
- (void)presentViewController:(__kindof UIViewController *)VC animationType:(CATransitionSubtype)type timingFunction:(CAMediaTimingFunctionName)timingFunction completion:(void (^)(void))completion fullScreen:(BOOL)fullScreen;
- (void)dismissViewControllerAnimationType:(CATransitionSubtype)type timingFunction:(CAMediaTimingFunctionName)timingFunction completion:(void (^)(void))completion;

/** @brief If source is not of type UIView, self.view will be used as source. */
- (void)presentPopover:(UIViewController *)VC fromSource:(NSObject *)source size:(CGSize)size;
/** @brief If source is not of type UIView, self.view will be used as source. */
- (void)presentPopover:(UIViewController *)VC fromSource:(NSObject *)source size:(CGSize)size rect:(CGRect)rect;

- (void)updateNavBarMode:(MKU_THEME_STYLE)mode;

@end

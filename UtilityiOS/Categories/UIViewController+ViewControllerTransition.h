//
//  UIViewController+ViewControllerTransition.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKUViewControllerTransitionProtocol.h"

@interface UIViewController (ViewControllerTransition) <MKUViewControllerTransitionProtocol>

- (void)dispathTransitionDelegateToReturnWithObject:(NSObject *)object;
- (void)dispathTransitionDelegateToReturnWithResult:(VC_TRANSITION_RESULT_TYPE)result object:(NSObject *)object;
/** @brief Pops navigationController after caling dispathTransitionDelegateToReturnWithObject: */
- (void)dismissAndDispathTransitionDelegateToReturnWithObject:(NSObject *)object;

@end

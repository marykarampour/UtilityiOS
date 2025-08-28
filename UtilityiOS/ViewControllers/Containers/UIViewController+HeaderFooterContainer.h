//
//  UIViewController+HeaderFooterContainer.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-07-22.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKUHeaderFooterContainerViewController.h"

@interface UIViewController (HeaderFooterContainer) <HeaderVCChildViewDelegate>

@property (nonatomic, weak) __kindof MKUHeaderFooterContainerViewController *headerDelegate;

- (void)setContainerHeaderNextTitle:(NSString *)title;
- (void)setContainerHeaderNextEnabled:(BOOL)enabled;

@end

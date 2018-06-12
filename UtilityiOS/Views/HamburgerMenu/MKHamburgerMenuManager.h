//
//  MKHamburgerMenuManager.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-20.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKHamburgerContainerViewController.h"

@interface MKHamburgerMenuManager : NSObject

@property (nonatomic, strong, readonly) MKHamburgerContainerViewController *menuVC;
@property (nonatomic, strong, readonly) __kindof UIViewController *presentingVC;

+ (MKHamburgerMenuManager *)instance;

- (void)setPresentingViewController:(__kindof UIViewController *)presentingVC;
- (void)dismissMenu;

@end

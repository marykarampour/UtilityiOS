//
//  MKUHamburgerContainerViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-21.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUHamburgerViewController.h"

@interface MKUHamburgerContainerViewController : UIViewController

/** @brief constant width of the menu when completely on screen */
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, strong, readonly) MKUHamburgerViewController *menuVC;

- (instancetype)initWithMenuVC:(__kindof MKUHamburgerViewController *)menuVC;
- (void)updateMenuIsHidden:(BOOL)isHidden comletion:(void (^)(void))completion;

@end

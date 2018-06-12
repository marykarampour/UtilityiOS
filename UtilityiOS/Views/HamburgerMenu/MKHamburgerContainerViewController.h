//
//  MKHamburgerContainerViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-21.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKHamburgerContainerViewController : UIViewController

/** @brief constant width of the menu when completely on screen */
@property (nonatomic, assign) CGFloat menuWidth;

- (void)updateMenuIsHidden:(BOOL)isHidden comletion:(void (^)(void))completion;

@end

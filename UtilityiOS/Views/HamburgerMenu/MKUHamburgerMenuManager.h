//
//  MKUHamburgerMenuManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-04-20.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUHamburgerContainerViewController.h"

@interface MKUHamburgerMenuManager : NSObject

@property (nonatomic, strong, readonly) __kindof MKUHamburgerContainerViewController *menuVC;
@property (nonatomic, strong, readonly) __kindof UIViewController *presentingVC;

+ (MKUHamburgerMenuManager *)instance;

- (void)initializeContainerWithMenu:(__kindof MKUHamburgerViewController *)menuVC;
- (void)setPresentingViewController:(__kindof UIViewController *)presentingVC;
- (void)dismissMenuWithCompletion:(void (^)(void))completion;

@end

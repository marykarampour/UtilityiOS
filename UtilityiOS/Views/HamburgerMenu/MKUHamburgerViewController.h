//
//  MKUHamburgerViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-04-20.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollapsingMenuViewController.h"

@interface MKUHamburgerViewController : MKUCollapsingMenuViewController

@property (nonatomic, weak) __kindof UIViewController *presentingVC;

- (void)hideMenuWithCompletion:(void (^)(void))completion;

@end

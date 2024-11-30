//
//  MKUHamburgerViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-20.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUMenuViewController.h"

@interface MKUHamburgerViewController : MKUMenuViewController

@property (nonatomic, weak) __kindof UIViewController *presentingVC;

- (void)hideMenuWithCompletion:(void (^)(void))completion;

@end

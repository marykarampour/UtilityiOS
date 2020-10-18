//
//  MKHamburgerViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-20.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKHamburgerViewController.h"
#import "UIViewController+Utility.h"
#import "MKHamburgerMenuManager.h"

@interface MKHamburgerViewController ()

@end

@implementation MKHamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)createMenuObjects {}

- (void)hideMenuWithCompletion:(void (^)(void))completion {
    [[MKHamburgerMenuManager instance] dismissMenuWithCompletion:completion];
}

#pragma mark - Table view data source

- (NSUInteger)numberOfRowsInNonMenuSectionWhenExpanded:(NSUInteger)section {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

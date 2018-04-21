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

- (void)createMenuObjects {
    MKMenuObject *funds = [[MKMenuObject alloc] init];
    funds.title = @"Manage Funds";
    funds.action = @selector(hideMenu);
    funds.hasSpinner = NO;
    funds.hasBadge = NO;
    
    MKMenuSection *bankingSection = [[MKMenuSection alloc] init];
    bankingSection.menuItems = @[funds];
    bankingSection.isCollapsable = NO;
    
//    MKTableViewSection *merchantsSection = [[MKTableViewSection alloc] init];
//    merchantsSection.isCollapsable = NO;
    
    [self.sections addObject:bankingSection];
//    [self.sections addObject:merchantsSection];
}

- (void)hideMenu {
    [[MKHamburgerMenuManager instance] dismissMenu];
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

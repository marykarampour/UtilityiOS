//
//  NSObject+SplitView.m
//  PQR
//
//  Created by Maryam Karampour on 2017-01-03.
//  Copyright © 2017 Team Solutions. All rights reserved.
//

#import "NSObject+SplitView.h"

@implementation MasterViewController

@end

@implementation DetailViewController

@end

@implementation MasterDetailNavControllerPair

@end

@implementation MasterDetailViewControllerPair

@end


@implementation NSObject (SplitView)

+ (MasterDetailNavControllerPair *)masterDetailNavPairFor:(Class)masterClass detailClass:(Class)detailClass title:(NSString *)title icon:(NSString *)icon {
    MasterViewController *masterListVC = [[masterClass alloc] init];
    UINavigationController *masterListNav = [[UINavigationController alloc] initWithRootViewController:masterListVC];
    masterListVC.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(title, nil) image:[UIImage imageNamed:icon] selectedImage:nil];
    DetailViewController *detailVC = [[detailClass alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    masterListVC.detailDelegate = detailVC;
    detailVC.masterDelegate = masterListVC;
    
    MasterDetailNavControllerPair *pair = [[MasterDetailNavControllerPair alloc] init];
    pair.master = masterListNav;
    pair.detail = detailNav;
    return pair;
}

+ (MasterDetailViewControllerPair *)masterDetailViewPairFor:(Class)masterClass detailClass:(Class)detailClass tabItem:(TabBarIndex)index {
    MasterViewController *masterListVC = [[masterClass alloc] init];
    DetailViewController *detailVC = [[detailClass alloc] init];
    
    masterListVC.detailDelegate = detailVC;
    detailVC.masterDelegate = masterListVC;
    
    MasterDetailViewControllerPair *pair = [[MasterDetailViewControllerPair alloc] init];
    pair.master = masterListVC;
    pair.detail = detailVC;
    return pair;
}


@end

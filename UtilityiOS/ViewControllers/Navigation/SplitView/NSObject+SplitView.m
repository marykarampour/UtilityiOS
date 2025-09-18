//
//  NSObject+SplitView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSObject+SplitView.h"
#import "SplitViewManager.h"

@implementation MKUMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[SplitViewManager instance] logoutButton];
}

@end

@implementation MKUDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

@end

@implementation MasterDetailNavControllerPair

@end

@implementation MasterDetailViewControllerPair

- (instancetype)initWithNavPair:(MasterDetailNavControllerPair *)pair {
    if (self = [super init]) {
        self.master = pair.master.viewControllers[0];
        self.detail = pair.detail.viewControllers[0];
    }
    return self;
}

@end

@interface MKUBaseMasterViewController ()

@end

@implementation MKUBaseMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation NSObject (SplitView)

+ (MasterDetailNavControllerPair *)masterDetailNavPairFor:(Class)masterClass detailClass:(Class)detailClass title:(NSString *)title icon:(NSString *)icon {
    MKUMasterViewController *masterListVC = [[masterClass alloc] init];
    UINavigationController *masterListNav = [[UINavigationController alloc] initWithRootViewController:masterListVC];
    masterListVC.navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:icon] selectedImage:nil];
    masterListNav.tabBarItem.imageInsets = [Constants TabBarItemImageInsets];
    
    MKUDetailViewController *detailVC = [[detailClass alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    masterListVC.detailDelegate = detailVC;
    detailVC.masterDelegate = masterListVC;
    
    MasterDetailNavControllerPair *pair = [[MasterDetailNavControllerPair alloc] init];
    pair.master = masterListNav;
    pair.detail = detailNav;
    return pair;
}

+ (MasterDetailViewControllerPair *)masterDetailViewPairFor:(Class)masterClass detailClass:(Class)detailClass tabItem:(TabBarIndex)index {
    MKUMasterViewController *masterListVC = [[masterClass alloc] init];
    MKUDetailViewController *detailVC = [[detailClass alloc] init];
    
    masterListVC.detailDelegate = detailVC;
    detailVC.masterDelegate = masterListVC;
    
    MasterDetailViewControllerPair *pair = [[MasterDetailViewControllerPair alloc] init];
    pair.master = masterListVC;
    pair.detail = detailVC;
    return pair;
}


@end

//
//  SplitViewManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "SplitViewManager.h"

@implementation SplitViewManager

+ (instancetype)instance {
    static SplitViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SplitViewManager alloc] init];
    });
    return manager;
}

//- (instancetype)init {
//    if (self = [super init]) {
//        [self setAppearance];
//        
//        NSArray<__kindof MasterDetailNavControllerPair *> * navPairs =
//        @[
//          [NSObject masterDetailNavPairFor:[PQRSessionsListViewController class] detailClass:[PQRLoginViewController class] title:kSessions icon:@"car-tabbar"],
//          [NSObject masterDetailNavPairFor:[PQRReportsListViewController class] detailClass:[WebViewController class] title:kReports icon:@"report-tabbar"],
//          [NSObject masterDetailNavPairFor:[PQRWizardListTableViewController class] detailClass:[PQRWizardViewController class] title:kWizard icon:@"chart-tabbar"]
//          ];
//        
//        self.splitViewController = [[PQRSplitViewController alloc] initWithMasterDetailPairs:navPairs secondaryDetailViewController:[[PQRBaseDetailViewController alloc] init]];
//    }
//    return self;
//}
//
//
//
//- (void)setAppearance {
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont14, NSFontAttributeName, [UIColor PQRSubtitle1TextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor PQRControlHighlightColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//    
//    [[UITabBar appearance] setBarTintColor:[UIColor PQRTableBackgroundColor]];
//    [[UITabBar appearance] setTranslucent:NO];
//}


- (UIViewController *)windowRootViewController {
    return self.splitViewController.splitViewController;
}

@end

//
//  TabBarSplitViewController.h
//  PQR
//
//  Created by Maryam Karampour on 2017-01-01.
//  Copyright © 2017 Team Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+SplitView.h"

@interface TabBarSplitViewController : NSObject

@property (nonatomic, strong, readonly, nonnull) NSArray<__kindof MasterDetailNavControllerPair *> *pairs;
@property (nonatomic, strong, readonly, nonnull) UISplitViewController *splitViewController;
@property (nonatomic, strong, readonly, nonnull) UIViewController *detailViewController;


- (_Nonnull instancetype)initWithMasterDetailPairs:(NSArray<__kindof MasterDetailNavControllerPair *> * _Nonnull)pairs secondaryDetailViewController:(UIViewController * _Nonnull)detailViewController;

- (UINavigationController *_Nullable)splitViewDetailMainNavController;
- (void)updatePrimaryViewWithState:(PrimaryViewState)state;
- (UIViewController *_Nullable)selectedTabViewController;
- (void)setSelectedTab:(TabBarIndex)index;
- (void)pushWithFade:(BOOL)fade pair:(MasterDetailViewControllerPair * _Nonnull)pair forTabItem:(TabBarIndex)index;

- (void)popToRootWithFade:(BOOL)fade forTabItem:(TabBarIndex)index;

//Abstract
- (void)didAfterSelectingTabItem:(TabBarIndex)index;

@end

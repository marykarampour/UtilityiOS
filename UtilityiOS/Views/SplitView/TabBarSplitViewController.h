//
//  TabBarSplitViewController.h
//  PQR
//
//  Created by Maryam Karampour on 2017-01-01.
//  Copyright © 2017 Team Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+SplitView.h"

typedef NS_ENUM(NSUInteger, PopToRootType) {
    PopToRootType_Default,
    PopToRootType_Fade,
    PopToRootType_Bottom
};

@interface TabBarSplitViewController : NSObject

@property (nonatomic, strong, readonly, nonnull) NSArray<__kindof MasterDetailNavControllerPair *> *pairs;
@property (nonatomic, strong, readonly, nonnull) UISplitViewController *splitViewController;
@property (nonatomic, strong, readonly, nonnull) UIViewController *detailViewController;
@property (nonatomic, strong, readonly) UITabBarController *primaryTabBarController;


- (_Nonnull instancetype)initWithBaseMasterDetailPair:(MasterDetailNavControllerPair * _Nullable)pair;
- (void)pushToBase:(MasterDetailNavControllerPair * _Nonnull)pair addMasterDetailPairs:(NSArray<__kindof MasterDetailNavControllerPair *> *)pairs;

- (UINavigationController *_Nullable)splitViewDetailMainNavController;
- (void)updatePrimaryViewWithState:(PrimaryViewState)state;
- (UIViewController *_Nullable)selectedTabViewController;
- (void)setSelectedTab:(TabBarIndex)index;
- (NSUInteger)tabCount;

- (void)pushWithType:(PopToRootType)type pair:(MasterDetailViewControllerPair * _Nonnull)pair forTabItem:(TabBarIndex)index;
- (void)popToRootWithType:(PopToRootType)type forTabItem:(TabBarIndex)index;

- (void)clearNavPairs;

//Abstract
- (void)didAfterSelectingTabItem:(TabBarIndex)index;

@end

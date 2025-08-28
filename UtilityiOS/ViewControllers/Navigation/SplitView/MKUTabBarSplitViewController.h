//
//  TabBarSplitViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUSplitViewController.h"
#import "NSObject+SplitView.h"

typedef NS_ENUM(NSUInteger, MKU_TABBAR_SPLIT_POPTOROOT_TYPE) {
    MKU_TABBAR_SPLIT_POPTOROOT_TYPE_DEFAULT,
    MKU_TABBAR_SPLIT_POPTOROOT_TYPE_FADE,
    MKU_TABBAR_SPLIT_POPTOROOT_TYPE_BOTTOM
};

@interface MKUTabBarSplitViewController : NSObject

@property (nonatomic, strong, readonly, nonnull) NSArray<__kindof MasterDetailNavControllerPair *> *pairs;
@property (nonatomic, strong, readonly, nonnull) MKUSplitViewController *splitViewController;
@property (nonatomic, strong, readonly, nonnull) UIViewController *detailViewController;
@property (nonatomic, strong, readonly) UITabBarController *primaryTabBarController;


- (_Nonnull instancetype)initWithBaseMasterDetailPair:(MasterDetailNavControllerPair * _Nullable)pair;
- (void)pushToBase:(MasterDetailNavControllerPair * _Nonnull)pair addMasterDetailPairs:(NSArray<__kindof MasterDetailNavControllerPair *> *)pairs;

- (UINavigationController *_Nullable)splitViewDetailMainNavController;
- (void)updatePrimaryViewWithState:(PrimaryViewState)state;
- (UIViewController *_Nullable)selectedTabViewController;
- (void)setSelectedTab:(TabBarIndex)index;
- (NSUInteger)tabCount;

- (void)pushWithType:(MKU_TABBAR_SPLIT_POPTOROOT_TYPE)type pair:(MasterDetailViewControllerPair * _Nonnull)pair forTabItem:(TabBarIndex)index;
- (void)popToRootWithType:(MKU_TABBAR_SPLIT_POPTOROOT_TYPE)type forTabItem:(TabBarIndex)index;

- (void)clearNavPairs;

//Abstract
- (void)didAfterSelectingTabItem:(TabBarIndex)index;

#pragma mark - transitions

- (void)animateLogin;
- (void)animateLogout;

//- (void)setSelectedTab:(TabBarIndex)index isShrunkednMenu:(BOOL)shrunken;

//Abstracts

/** @brief called in init, as early as possible, i.e. the first call to the split view
 @code
 - (void)init {
 self.splitViewController = [[MKSplitViewController alloc] initWithBaseMasterDetailPair:[self basePair]];
 }
 
 - (MasterDetailNavControllerPair *)basePair {
 return [NSObject masterDetailNavPairFor:[BaseMasterViewController class]
 detailClass:[LoginViewController class]
 title:nil
 icon:[self tabbarImages][0]];
 }
 @endcode
 */
- (MasterDetailNavControllerPair *)basePair;

/** */
- (void)pushViewControllerPairs;

/** @brief perform any clean-up on logout including resetting the logged in user, database clean-up etc.*/
- (void)didLogout;

/** @brief images used in tabbar items
 @code
 - (StringArr *)tabbarImages {
 MKUPairArray *tabImages = [[MKUPairArray alloc] init];
 tabImages.array = @[[MKUPair first:@(0) second:@""]];
 return [tabImages allValues];
 }
 @endcode
 */
- (StringArr *)tabbarImages;

@end

//
//  MKSplitViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "TabBarSplitViewController.h"

@interface MKSplitViewController : TabBarSplitViewController

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

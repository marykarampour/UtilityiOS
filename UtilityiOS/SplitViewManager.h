//
//  SplitViewManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKSplitViewController.h"

@interface SplitViewManager : NSObject

@property (nonatomic, strong) MKSplitViewController *splitViewController;

+ (instancetype)instance;
- (UIViewController *)windowRootViewController;

@end

//
//  NSObject+SplitView.h
//  PQR
//
//  Created by Maryam Karampour on 2017-01-03.
//  Copyright © 2017 Team Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailProtocol.h"
#import "MKUTableViewController.h"
//Abstract
typedef NSUInteger TabBarIndex;

typedef NS_ENUM(NSUInteger, PrimaryViewState) {
    PrimaryViewStateVisible,
    PrimaryViewStateHidden,
    PrimaryViewStateShrunken
};

@interface MasterViewController : MKUTableViewController <MasterProtocol>

@property (nonatomic, weak) id<DetailProtocol> detailDelegate;

@end

@interface DetailViewController : UIViewController <DetailProtocol>

@property (nonatomic, weak) id<MasterProtocol> masterDelegate;

@end

@interface MasterDetailNavControllerPair : NSObject

@property (nonatomic, strong, nonnull) UINavigationController *master;
@property (nonatomic, strong, nonnull) UINavigationController *detail;

@end

@interface MasterDetailViewControllerPair : NSObject

@property (nonatomic, strong, nonnull) UIViewController *master;
@property (nonatomic, strong, nonnull) UIViewController *detail;

- (instancetype)initWithNavPair:(MasterDetailNavControllerPair * _Nonnull)pair;

@end

@interface BaseMasterViewController : MasterViewController

@end

@interface NSObject (SplitView)

+ (MasterDetailNavControllerPair * _Nonnull)masterDetailNavPairFor:(Class _Nonnull)masterClass detailClass:(Class _Nonnull)detailClass title:(NSString * _Nullable)title icon:(NSString * _Nullable)icon;
+ (MasterDetailViewControllerPair * _Nonnull)masterDetailViewPairFor:(Class _Nonnull)masterClass detailClass:(Class _Nonnull)detailClass tabItem:(TabBarIndex)index;

@end

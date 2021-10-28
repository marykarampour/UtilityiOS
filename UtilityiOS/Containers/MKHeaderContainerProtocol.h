//
//  MKHeaderContainerProtocol.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKHeaderFooterContainerViewController;

@class MKTableViewController;


@protocol HeaderVCParentViewDelegate <NSObject>

@optional
- (void)headerNextSetEnabled:(BOOL)enabled;
- (void)headerNextSetHidden:(BOOL)hidden;
- (void)headerNextSetTitle:(NSString *)title;
- (void)setHeaderViewTitle:(NSString *)title;

@end

@protocol HeaderVCChildViewDelegate <NSObject>

@required
@property (nonatomic, weak) __kindof MKHeaderFooterContainerViewController <HeaderVCParentViewDelegate> *headerDelegate;
@property (nonatomic, strong) id object;

@optional
- (void)nextPressed:(UIBarButtonItem * _Nonnull)sender;

@end

@protocol MKHeaderFooterContainerProtocol <NSObject>

@required
- (void)setContentView;
- (void)createHeaderView;
- (void)createFooterView;
- (CGFloat)headerHeight;
- (CGFloat)headerWidth;
- (CGFloat)maxHeaderHeight;
- (CGFloat)headerVerticalMargin;
- (CGFloat)footerHeight;
- (CGFloat)footerWidth;
- (CGFloat)maxFooterHeight;
- (CGFloat)footerVerticalMargin;
- (void)createChildVC;

@optional
- (void)createChildVCWithChildObject:(__kindof NSObject *)object;

@optional
- (void)setChildViewController:(MKTableViewController *)childViewController;
- (void)setHeaderViewTitle:(NSString *)title;
- (void)nextPressed:(UIBarButtonItem * _Nonnull)sender;

@end

//
//  MKOutlineViewProtocol.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKTableViewController;

@protocol MKOutlineViewProtocol <NSObject>

@end


@protocol MKOutlineContainerViewProtocol <NSObject>

@required
- (void)setContentView;
- (void)setOutlineView;
- (void)createHeaderView;
- (void)createFooterView;
- (void)createOutlineFooterView;
- (void)createChildContentVC;
- (void)createChildOutlineVC;
- (CGFloat)minOutlineWidth;
- (CGFloat)maxOutlineWidth;
- (CGFloat)headerHeight;
- (CGFloat)headerWidth;
- (CGFloat)headerVerticalMargin;
- (CGFloat)footerHeight;
- (CGFloat)footerWidth;
- (CGFloat)footerVerticalMargin;

@optional
- (void)setChildViewController:(MKTableViewController *)childViewController;
- (void)setHeaderViewTitle:(NSString *)title;
- (void)nextPressed:(UIBarButtonItem * _Nonnull)sender;

@end

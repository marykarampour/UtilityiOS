//
//  MKUOutlineViewProtocol.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKUTableViewController;

@protocol MKUOutlineViewProtocol <NSObject>

@end


@protocol MKUOutlineContainerViewProtocol <NSObject>

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
- (void)setChildViewController:(MKUTableViewController *)childViewController;
- (void)setHeaderViewTitle:(NSString *)title;
- (void)nextPressed:(UIBarButtonItem * _Nonnull)sender;

@end

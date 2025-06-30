//
//  MKUSearchHeaderView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUPolymorphicViewProtocol.h"

@interface MKUSearchHeaderView <__covariant ViewType> : UIView <MKUPolymorphicViewProtocol>

@property (nonatomic, strong) UISearchBar *searchBar;
/** @brief An optional view placed at the bottom of the search bar. */
@property (nonatomic, strong) ViewType bottomView;
/** @brief Insets used for constrainting bottomView. */
@property (nonatomic, assign) UIEdgeInsets insets;

/** @brief Use this initializer to add a custom bottomView.
 @param insets Insets used for constrainting bottomView.
 @param handler Return a view to be set as bottomView. */
- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler;

@end

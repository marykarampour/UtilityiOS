//
//  MKUContainerView.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKUContainerView <__covariant ViewType : __kindof UIView *> : UIView

@property (nonatomic, strong) ViewType view;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithViewCreationHandler:(VIEW_CREATION_HANDLER)handler;

@end



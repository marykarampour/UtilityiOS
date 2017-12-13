//
//  UIView+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

- (void)removeConstraintsMask;
- (void)addConstraintsWithFormat:(NSString * _Nullable)format options:(NSLayoutFormatOptions)opts metrics:(nullable NSDictionary<NSString *,id> *)metrics views:(NSDictionary<NSString *, id> *_Nullable)views;
- (void)addConstraintWithItem:(id _Nullable)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;

@end

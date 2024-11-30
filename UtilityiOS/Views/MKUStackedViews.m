//
//  MKUStackedViews.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-28.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUStackedViews.h"
#import "UIView+Utility.h"

@interface MKUStackedViews ()

@property (nonatomic, strong) NSMutableArray <__kindof UIView *> *views;

@end

@implementation MKUStackedViews

- (instancetype)initWithCount:(NSUInteger)count viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler {
    return [self initWithCount:count padding:0.0 viewCreationHandler:handler];
}

- (instancetype)initWithCount:(NSUInteger)count padding:(CGFloat)padding viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler {
    return [self initWithCount:count padding:padding interItemMargin:padding viewCreationHandler:handler];
}

- (instancetype)initWithCount:(NSUInteger)count interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler {
    return [self initWithCount:count interItemSpacing:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin sizes:nil viewCreationHandler:handler];
}

- (instancetype)initWithCount:(NSUInteger)count interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin sizes:(NSDictionary<NSNumber *,NSNumber *> *)sizes viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler {
    if (self = [super init]) {
        [self initViewsWithCount:count viewCreationHandler:handler];
        [self removeConstraintsMask];
        [self constreintViewsWithSizes:sizes interItemSpacing:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin];
    }
    return self;
}

- (instancetype)initWithCount:(NSUInteger)count padding:(CGFloat)padding interItemMargin:(CGFloat)interItemMargin viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler {
    if (self = [super init]) {
        [self initViewsWithCount:count viewCreationHandler:handler];
        [self removeConstraintsMask];
        [self constreintViewsWithPadding:padding interItemMargin:interItemMargin];
    }
    return self;
}

- (void)initViewsWithCount:(NSUInteger)count viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler {
    self.views = [[NSMutableArray alloc] init];
    
    if (!handler) return;
    
    for (NSUInteger i=0; i<count; i++) {
        UIView *view = handler(i);
        if (!view) continue;
        
        [self addSubview:view];
        [self.views addObject:view];
    }
}

- (instancetype)initWithViewCreationHandlers:(NSArray<SINGLE_INDEX_VIEW_CREATION_HANDLER> *)handlers {
    if (self = [super init]) {
        
        self.views = [[NSMutableArray alloc] init];
        
        for (NSUInteger i=0; i<handlers.count; i++) {
            
            UIView *view = handlers[i](0);
            if (!view) continue;
            
            [self addSubview:view];
            [self.views addObject:view];
        }
        
        [self removeConstraintsMask];
        [self constreintViews];
    }
    return self;
}

+ (CGFloat)defaultPadding {
    return 4.0;
}

- (id)viewAtIndex:(NSUInteger)index {
    if (self.views.count <= index) return nil;
    return self.views[index];
}

- (NSArray<__kindof UIView *> *)contentViews {
    return self.views;
}

- (NSUInteger)count {
    return self.views.count;
}

- (void)constreintViewsWithSizes:(NSDictionary<NSNumber *,NSNumber *> *)sizes interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
}

- (void)constreintViewsWithInterItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
    [self constreintViewsWithSizes:nil interItemSpacing:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin];
}

- (void)constreintViewsWithPadding:(CGFloat)padding interItemMargin:(CGFloat)interItemMargin {
}

- (void)constreintViewsWithPadding:(CGFloat)padding {
    [self constreintViewsWithPadding:padding interItemMargin:padding];
}

- (void)constreintViews {
    [self constreintViewsWithPadding:0.0];
}

@end


@implementation MKUHorizontalViews

- (void)constreintViewsWithSizes:(NSDictionary<NSNumber *,NSNumber *> *)sizes interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
    
    [self constraintHorizontally:[self contentViews] interItemMargin:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalWidths:sizes.count == 0];
    
    [sizes enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger index = key.integerValue;
        if (index < [self views].count && 0.0 < obj.floatValue) {
            [self constraintWidth:obj.floatValue forView:[self views][index]];
        }
    }];
}

- (void)constreintViewsWithPadding:(CGFloat)padding interItemMargin:(CGFloat)interItemMargin {
    [self constreintViewsWithInterItemSpacing:interItemMargin horizontalMargin:padding verticalMargin:0.0];
}

- (id)viewAtIndex:(NSUInteger)index {
    return [super viewAtIndex:index];
}

@end


@implementation MKUVerticalViews

- (void)constreintViewsWithSizes:(NSDictionary<NSNumber *,NSNumber *> *)sizes interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
    
    [self constraintVertically:[self contentViews] interItemMargin:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalHeights:sizes.count == 0];
    
    [sizes enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger index = key.integerValue;
        if (index < [self views].count && 0.0 < obj.floatValue) {
            [self constraintHeight:obj.floatValue forView:[self views][index]];
        }
    }];
}

- (void)constreintViewsWithPadding:(CGFloat)padding interItemMargin:(CGFloat)interItemMargin {
    [self constreintViewsWithInterItemSpacing:interItemMargin horizontalMargin:padding verticalMargin:padding];
}

- (id)viewAtIndex:(NSUInteger)index {
    return [super viewAtIndex:index];
}

@end

//
//  MKUStackedViews.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-28.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUStackedViews.h"
#import "NSObject+Utility.h"
#import "UIView+Utility.h"

static CGFloat const PADDING = 4.0;

@interface MKUStackedViews ()

@property (nonatomic, strong) NSMutableArray <__kindof UIView *> *views;

@end

@implementation MKUStackedViews

- (instancetype)initWithCount:(NSUInteger)count viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler {
    return [self initWithCount:count padding:[Constants DefaultPadding] viewCreationHandler:handler];
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

- (id)viewAtIndex:(NSUInteger)index {
    if (self.views.count <= index) return nil;
    return self.views[index];
}

- (NSUInteger)count {
    return self.views.count;
}

- (NSUInteger)indexOfView:(UIView *)view {
    return [self.views indexOfObject:view];;
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
    [self constreintViewsWithPadding:[Constants DefaultPadding]];
}

@end


@implementation MKUHorizontalViews

- (void)constreintViewsWithSizes:(NSDictionary<NSNumber *,NSNumber *> *)sizes interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
    [self constraintHorizontally:[self views] interItemMargin:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalWidths:sizes.count == 0];
    
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
    [self constraintVertically:[self views] interItemMargin:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalHeights:sizes.count == 0];
    
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


@interface MKUVerticallyStackedHorizontalViews ()

@end

@implementation MKUVerticallyStackedHorizontalViews

- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding verticalSizes:(NSDictionary<NSNumber *, NSNumber *> *)verticalSizes horizontalSizes:(NSDictionary<NSNumber *, NSNumber *> *)horizontalSizes viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler {
    NSUInteger verticalCount = (horizontalCount == 0) ? count : ceil((float)count / horizontalCount);
    return [self initWithVerticalCount:verticalCount horizontalCount:horizontalCount padding:padding verticalSizes:verticalSizes horizontalSizes:horizontalSizes viewCreationHandler:^UIView *(NSUInteger row, NSUInteger column) {
        NSUInteger index = [NSObject indexOfRow:row column:column totalColumn:horizontalCount];
        return index < count ? handler(index, row, column) : nil;
    }];
}

- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler {
    return [self initWithCount:count horizontalCount:horizontalCount interItemSpacing:padding horizontalMargin:0.0 verticalMargin:padding viewCreationHandler:handler];
}

- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler {
    return [self initWithCount:count horizontalCount:horizontalCount padding:PADDING viewCreationHandler:handler];
}

- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler {
    NSUInteger verticalCount = (horizontalCount == 0) ? count : ceil((float)count / horizontalCount);
    return [self initWithVerticalCount:verticalCount horizontalCount:horizontalCount interItemSpacing:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin viewCreationHandler:^UIView *(NSUInteger row, NSUInteger column) {
        NSUInteger index = [NSObject indexOfRow:row column:column totalColumn:horizontalCount];
        return index < count ? handler(index, row, column) : nil;
    }];
}

- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler {
    return [self initWithVerticalCount:verticalCount horizontalCount:horizontalCount padding:PADDING viewCreationHandler:handler];
}

- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding verticalSizes:(NSDictionary<NSNumber *,NSNumber *> *)verticalSizes horizontalSizes:(NSDictionary<NSNumber *,NSNumber *> *)horizontalSizes viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler {
    return [super initWithCount:verticalCount interItemSpacing:padding horizontalMargin:0.0 verticalMargin:padding sizes:verticalSizes viewCreationHandler:^UIView *(NSUInteger row) {
        return [[MKUHorizontalViews alloc] initWithCount:horizontalCount interItemSpacing:padding horizontalMargin:padding verticalMargin:0.0 sizes:horizontalSizes viewCreationHandler:^UIView *(NSUInteger column) {
            return handler(row, column);
        }];
    }];
}

- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler  {
    return [super initWithCount:verticalCount interItemSpacing:padding horizontalMargin:0.0 verticalMargin:padding viewCreationHandler:^UIView *(NSUInteger row) {
        return [[MKUHorizontalViews alloc] initWithCount:horizontalCount interItemSpacing:padding horizontalMargin:padding verticalMargin:0.0 viewCreationHandler:^UIView *(NSUInteger column) {
            return handler(row, column);
        }];
    }];
}

- (instancetype)initWithViewCreationHandlers:(NSArray<NSArray<SINGLE_INDEX_VIEW_CREATION_HANDLER> *> *)handlers {
    return [super initWithCount:handlers.count interItemSpacing:PADDING horizontalMargin:0.0 verticalMargin:PADDING viewCreationHandler:^UIView *(NSUInteger row) {
        return [[MKUHorizontalViews alloc] initWithCount:handlers.firstObject.count interItemSpacing:PADDING horizontalMargin:PADDING verticalMargin:0.0 viewCreationHandler:^UIView *(NSUInteger column) {
            return [[handlers objectAtIndex:row] objectAtIndex:column](column);
        }];
    }];
}

- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler {
    return [super initWithCount:verticalCount interItemSpacing:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin viewCreationHandler:^UIView *(NSUInteger row) {
        return [[MKUHorizontalViews alloc] initWithCount:horizontalCount interItemSpacing:interItemSpacing horizontalMargin:horizontalMargin verticalMargin:verticalMargin viewCreationHandler:^UIView *(NSUInteger column) {
            return handler(row, column);
        }];
    }];
}

- (id)viewForRow:(NSUInteger)row column:(NSUInteger)column {
    if ([self count] <= row) return nil;
    
    MKUHorizontalViews *content = [self views][row];
    if ([content count] <= column) return nil;
    return [content viewAtIndex:column];
}

- (id)viewForIndex:(NSUInteger)index {
    if ([self count] == 0) return nil;
    
    NSUInteger row = ceil(index / [[self views].firstObject count]);
    NSUInteger column = index % [[self views].firstObject count];
    return [self viewForRow:row column:column];
}

- (NSUInteger)rowCount {
    return [self count];
}

- (NSArray *)cellViews {
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (MKUHorizontalViews *hor in [self views]) {
        [views addObjectsFromArray:[hor views]];
    }
    return views;
}

- (NSUInteger)indexOfCellView:(id)view {
    NSUInteger row = [[self views] indexOfObjectPassingTest:^BOOL(MKUHorizontalViews *obj, NSUInteger idx, BOOL *stop) {
        return [obj.subviews containsObject:view];
    }];
    
    if (row == NSNotFound) return NSNotFound;
    
    MKUHorizontalViews *obj = [[self views] objectAtIndex:row];
    
    NSUInteger column = [[obj views] indexOfObjectPassingTest:^BOOL(UIView *obj, NSUInteger idx, BOOL *stop) {
        return [obj isEqual:view];
    }];
    
    return [NSObject indexOfRow:row column:column totalColumn:[obj count]];
}

@end

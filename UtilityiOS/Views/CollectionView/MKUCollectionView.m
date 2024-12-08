//
//  MKUCollectionView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-31.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollectionView.h"
#import "NSObject+Utility.h"
#import "NSArray+Utility.h"
#import "UIView+Utility.h"

#pragma mark - cell

@interface MKUCollectionViewLayoutAttributes ()

@end

@implementation MKUCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
    return [self MKUCopyWithZone:zone baseClass:[UICollectionViewLayout class] option:MKU_COPY_OPTION_PROPERTIES | MKU_COPY_OPTION_IVARS];
}

@end

@interface MKUCollectionViewCell ()

@end

@implementation MKUCollectionViewCell

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass(self)];
}

+ (CGSize)estimatedSize {
    return CGSizeMake(100.0, 100.0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.activeColor = [UIColor whiteColor];
        self.inactiveColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setActive:(BOOL)active {
    self.contentView.backgroundColor = active ? self.activeColor : self.inactiveColor;
}

@end

@interface MKUCollectionViewHeaderAttributes ()

@end

@implementation MKUCollectionViewHeaderAttributes

@end

@interface MKUCollectionHeaderView ()

@property (nonatomic, strong, readwrite) UILabel *textLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleRightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleBottomConstraint;

@end

@implementation MKUCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
        
        [self removeConstraintsMask];
        [self constraintViews];
    }
    return self;
}

- (void)setInsets:(UIEdgeInsets)insets {
    self.titleTopConstraint.constant = insets.top;
    self.titleLeftConstraint.constant = insets.left;
    self.titleRightConstraint.constant = -insets.right;
    self.titleBottomConstraint.constant = -insets.bottom;
    [self layoutIfNeeded];
}

- (void)constraintViews {
    self.titleTopConstraint = [self constraint:NSLayoutAttributeTop view:self.textLabel];
    self.titleLeftConstraint = [self constraint:NSLayoutAttributeLeft view:self.textLabel];
    self.titleRightConstraint = [self constraint:NSLayoutAttributeRight view:self.textLabel];
    self.titleBottomConstraint = [self constraint:NSLayoutAttributeBottom view:self.textLabel];
}

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass(self)];
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
}

@end

@interface MKUVerticalCollectionHeaderView ()

@end

@implementation MKUVerticalCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel.numberOfLines = 1;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)constraintViews {
    [self constraint:NSLayoutAttributeCenterX view:self.textLabel];
    [self constraint:NSLayoutAttributeCenterY view:self.textLabel];
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat PADDING = 8.0;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, rect.origin.x+PADDING, height/2);
    CGPathAddLineToPoint(pathRef, NULL, width/4, height/2);
    
    CGPathMoveToPoint(pathRef, NULL, width/4 * 3, height/2);
    CGPathAddLineToPoint(pathRef, NULL, width - PADDING, height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGPathRelease(pathRef);
    [path setLineWidth:2.0];
    
    UIBezierPath *encapsulatingPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(width/4, height/2 - height/4, width/2, height/2) cornerRadius:30.0];
    [encapsulatingPath setLineWidth:2.0];
    
    [self.borderColor setStroke];
    [path stroke];
    [encapsulatingPath stroke];
}

@end

#pragma mark - view controller

@interface MKUCollectionView ()

@end

@implementation MKUCollectionView

- (instancetype)initWithCollectionViewAttributes:(MKUCollectionViewLayoutAttributes *)attributes {
    if (self = [super initWithFrame:attributes.frame collectionViewLayout:attributes]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = YES;
        self.bounces = YES;
        self.alwaysBounceVertical = (attributes.scrollDirection == UICollectionViewScrollDirectionVertical);
        self.alwaysBounceHorizontal = (attributes.scrollDirection == UICollectionViewScrollDirectionHorizontal);
        self.allowsMultipleSelection = NO;
    }
    return self;
}

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

- (void)reload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

- (void)reloadWithCompletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        [self performBatchUpdates:^{
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    });
}

- (NSIndexPath *)indexPathForFirstItem {
    return [self indexPathForItemAtPoint:self.bounds.origin];
}

- (NSIndexPath *)indexPathForLastItem {
    CGPoint point = CGPointMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.size.height);
    return [self indexPathForItemAtPoint:point];
}

- (NSRange)indexRangeForVisibleItems {
    
    IndexPathArr *sortedVisiblePaths = [[self indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    
    NSUInteger first = sortedVisiblePaths.firstObject.item;
    NSUInteger last = sortedVisiblePaths.lastObject.item;
    return NSMakeRange(first, last - first);
}

@end

@interface MKUCollectionViewController ()

@property (nonatomic, strong, readwrite) NSMutableArray <__kindof MKUCollectionView *> *views;

@end

@implementation MKUCollectionViewController

- (instancetype)init {
    if (self = [super init]) {
        self.views = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addView:(__kindof MKUCollectionView *)view {
    view.delegate = self;
    view.dataSource = self;
    [self.views addObject:view];
}

- (void)insertView:(__kindof MKUCollectionView *)view atIndex:(NSUInteger)index {
    if (index <= self.views.count) {
        view.delegate = self;
        view.dataSource = self;
        [self.views insertObject:view atIndex:index];
    }
}

- (void)replaceViewAtIndex:(NSUInteger)index withView:(__kindof MKUCollectionView *)view {
    if (index <= self.views.count) {
        view.delegate = self;
        view.dataSource = self;
        [self.views replaceObjectAtIndex:index withObject:view];
    }
}

- (void)removeView:(__kindof MKUCollectionView *)view {
    if ([self.views containsObject:view]) {
        [self.views removeObject:view];
    }
}

- (void)removeViewAtIndex:(NSUInteger)index {
    if (index < self.views.count) {
        [self.views removeObjectAtIndex:index];
    }
}

- (void)loadData {
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForItemAtIndexPath:indexPath];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKUCollectionViewCell alloc] init];
}

@end

@interface MKUSingleCollectionViewController ()

@end

@implementation MKUSingleCollectionViewController

- (instancetype)initWithAttributes:(MKUCollectionViewLayoutAttributes *)attributes {
    if (self = [super init]) {
        self.attributes = [attributes copy];
        self.maxItemCount = INT_MAX;
        self.selectedIndex = NSNotFound;
    }
    return self;
}

- (void)setItems:(NSMutableArray *)items {
    _items = [items mutableCopy];
    [self reload];
}

- (void)setItemsWithArray:(NSArray<__kindof NSObject<NSCopying> *> *)items {
    [self setItems:[[NSMutableArray alloc] initWithArray:items]];
}

- (void)addItem:(NSObject<NSCopying> *)item {
    if (!item) return;
    
    [self.items addSynchronizedObject:item];
    [self reload];
}

- (void)deleteItem:(NSObject<NSCopying> *)item {
    if (!item) return;
    
    [self.items removeSynchronizedObject:item];
    [self reload];
}

- (void)setAttributes:(MKUCollectionViewLayoutAttributes *)attributes {
    _attributes = attributes;
    
    MKUCollectionView *view = [[MKUCollectionView alloc] initWithCollectionViewAttributes:self.attributes];
    if (self.attributes.cellClass)
        [view registerClass:self.attributes.cellClass forCellWithReuseIdentifier:[self.attributes.cellClass identifier]];
    [self addView:view];
}

- (void)addView:(__kindof MKUCollectionView *)view {
    [self insertView:view atIndex:0];
    
    view.delegate = self;
    view.dataSource = self;
    [view registerClass:[MKUCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MKUCollectionHeaderView identifier]];
}

- (void)insertView:(__kindof MKUCollectionView *)view atIndex:(NSUInteger)index {
    if (self.views.count == 0)
        [self.views addObject:view];
    else
        [self.views replaceObjectAtIndex:0 withObject:view];
}

- (void)removeView:(__kindof MKUCollectionView *)view {
}

- (void)removeViewAtIndex:(NSUInteger)index {
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectItemAtIndexPath:indexPath];
    if ([self.delegate conformsToProtocol:@protocol(MKUSingleCollectionViewDelegate)]) {
        if ([self.delegate respondsToSelector:@selector(singleCollectionViewController:didSelectItemAtIndexPath:)]) {
            [self.delegate singleCollectionViewController:self didSelectItemAtIndexPath:indexPath];
        }
    }
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MKUCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MKUCollectionHeaderView identifier] forIndexPath:indexPath];
        view.textLabel.font = self.headerAttributes.font;
        view.textLabel.textColor = self.headerAttributes.textColor;
        view.backgroundColor = self.headerAttributes.backgroundColor;
        view.borderColor = self.headerAttributes.borderColor;
        [view setText:[self titleForHeader:view inSection:indexPath.section]];
        [view setInsets:self.headerAttributes.insets];
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [self sizeForHeaderInSection:section];
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (NSString *)titleForHeader:(MKUCollectionHeaderView *)header inSection:(NSUInteger)section{
    return @"";
}

- (MKUCollectionView *)view {
    return self.views.firstObject;
}

- (void)reload {
    [[self view] reload];
}

@end

@interface MKUVerticalCollectionViewController ()

@end

@implementation MKUVerticalCollectionViewController

- (instancetype)initWithAttributes:(MKUCollectionViewLayoutAttributes *)attributes {
    
    MKUCollectionViewLayoutAttributes *attrs = [attributes copy];
    attrs.scrollDirection = UICollectionViewScrollDirectionVertical;
    return [super initWithAttributes:attributes];
}

- (void)addView:(__kindof MKUCollectionView *)view {
    [super addView:view];
    [view registerClass:[MKUVerticalCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MKUVerticalCollectionHeaderView identifier]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self verticalCellForItemAtIndexPath:indexPath];
}

- (MKUCollectionViewCell *)verticalCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKUCollectionViewCell alloc] init];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MKUVerticalCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MKUVerticalCollectionHeaderView identifier] forIndexPath:indexPath];
        view.textLabel.font = self.headerAttributes.font;
        view.textLabel.textColor = self.headerAttributes.textColor;
        view.borderColor = self.headerAttributes.borderColor;
        [view setText:[self titleForHeader:view inSection:indexPath.section]];
        return view;
    }
    return nil;
}

- (CGSize)sizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake([self view].frame.size.width-self.headerAttributes.insets.left-self.headerAttributes.insets.right, 44.0);
}

- (NSString *)titleForHeader:(MKUCollectionHeaderView *)header inSection:(NSUInteger)section{
    return @"";
}

@end

@interface MKUHorizontalCollectionViewController ()

@end

@implementation MKUHorizontalCollectionViewController

- (instancetype)initWithAttributes:(MKUCollectionViewLayoutAttributes *)attributes {
    
    MKUCollectionViewLayoutAttributes *attrs = [attributes copy];
    attrs.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [super initWithAttributes:attrs];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self horizontalCellForItemAtIndexPath:indexPath];
}

- (MKUCollectionViewCell *)horizontalCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKUCollectionViewCell alloc] init];
}

@end




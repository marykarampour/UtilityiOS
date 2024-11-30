//
//  MKUCollectionView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-31.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollectionView.h"
#import "NSObject+Utility.h"
#import "UIView+Utility.h"
#import "MKUGenericCell.h"

@interface MKUCollectionViewCell ()

@end

@implementation MKUCollectionViewCell

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass(self)];
}

+ (CGSize)estimatedSize {
    return CGSizeMake(100.0, 120.0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cellController = [[MKUCellContentController alloc] initWithCellType:MKUCellTypeCollectionView];
        [self.cellController setCollectionViewCell:self];
    }
    return self;
}

@end

@implementation MKUVerticalCollectionViewCell

@end


@implementation MKUCollectionViewAttributes

- (id)copyWithZone:(NSZone *)zone {
    return [self MKUCopyWithZone:zone baseClass:[UICollectionViewLayout class]];
}

@end


@implementation MKUCollectionView

- (instancetype)initWithCollectionViewAttributes:(MKUCollectionViewAttributes *)attributes {
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

- (MKURange *)indexRangeForVisibleItems {
    IndexPathArr *sortedVisiblePaths = [[self indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    return [MKURange rangeWithStart:@(sortedVisiblePaths.firstObject.item) end:@(sortedVisiblePaths.lastObject.item)];
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

- (MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKUCollectionViewCell alloc] init];
}



@end


@implementation MKUSingleCollectionViewController

- (instancetype)init {
    if (self = [super init]) {
        //TODO: only set if at list one item
        self.currentFirstItem = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    return self;
}

- (void)addView:(__kindof MKUCollectionView *)view {
    if (self.views.count == 0) {
        view.delegate = self;
        view.dataSource = self;
        [self.views addObject:view];
    }
}

- (void)insertView:(__kindof MKUCollectionView *)view atIndex:(NSUInteger)index {
    if (index == 0) {
        [self addView:view];
    }
}

- (void)removeView:(__kindof MKUCollectionView *)view {
}

- (void)removeViewAtIndex:(NSUInteger)index {
}

- (MKUCollectionView *)view {
    return self.views.firstObject;
}

@end

@implementation MKUVerticalCollectionHeaderAttributes


@end

@interface MKUVerticalCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIColor *borderColor;

@end

@implementation MKUVerticalCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 1;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
        
        [self removeConstraintsMask];
        [self constraint:NSLayoutAttributeCenterX view:self.textLabel];
        [self constraint:NSLayoutAttributeCenterY view:self.textLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
//TODO: fix sizes
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
    //TODO: these could be set in attrs
    [self.borderColor setStroke];
    [path stroke];
    [encapsulatingPath stroke];
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
}

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass(self)];
}

@end


@implementation MKUVerticalCollectionViewController

- (void)addView:(__kindof MKUCollectionView *)view {
    [super addView:view];
    [view registerClass:[MKUVerticalCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MKUVerticalCollectionHeaderView identifier]];
}

- (void)setSectionCount:(NSUInteger)sectionCount {
    _sectionCount = sectionCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionCount;
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
        [view setText:[self titleForHeaderInSection:indexPath.section]];
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width-16.0, 44.0);
}

- (NSString *)titleForHeaderInSection:(NSUInteger)section {
    return @"";
}

@end


@interface MKUHorizontalCollectionViewController ()


@end

@implementation MKUHorizontalCollectionViewController

- (instancetype)initWithAttributes:(MKUCollectionViewAttributes *)attributes {
    if (self = [super init]) {
        self.attributes = [attributes copy];
        self.attributes.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        MKUCollectionView *view = [[MKUCollectionView alloc] initWithCollectionViewAttributes:self.attributes];
        [view registerClass:self.attributes.cellClass forCellWithReuseIdentifier:[self.attributes.cellClass identifier]];
        [self addView:view];
    }
    return self;
}

- (void)addIdentifier:(NSString *)identifier {
    [[self view] registerClass:self.attributes.cellClass forCellWithReuseIdentifier:identifier];
}

- (void)setItemCount:(NSUInteger)itemCount {
    _itemCount = itemCount;
    [self.views.firstObject reload];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self horizontalCellForItemAtIndexPath:indexPath];
}

- (MKUCollectionViewCell *)horizontalCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKUCollectionViewCell alloc] init];
}

@end


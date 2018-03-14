//
//  MKCollectionView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-31.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCollectionView.h"
#import "UIView+Utility.h"
#import "MKGenericCell.h"

@interface MKCollectionViewCell ()

@end

@implementation MKCollectionViewCell

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass(self)];
}

+ (CGSize)estimatedSize {
    return CGSizeMake(100.0, 120.0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cellController = [[MKCellContentController alloc] initWithCellType:MKCellTypeCollectionView];
        [self.cellController setCollectionViewCell:self];
    }
    return self;
}

@end

@implementation MKVerticalCollectionViewCell

@end


@implementation MKCollectionViewAttributes

@end


@implementation MKCollectionView

- (instancetype)initWithCollectionViewAttributes:(MKCollectionViewAttributes *)attributes orientation:(CollectionViewOrientation)orientation {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = attributes.cellSize;
    layout.minimumLineSpacing = attributes.verticalPadding;
    layout.minimumInteritemSpacing = attributes.itemSpacing;
    layout.scrollDirection = (orientation & CollectionViewOrientation_Vertical) ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0);
    if (self = [super initWithFrame:attributes.frame collectionViewLayout:layout]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = YES;
        self.bounces = YES;
        self.alwaysBounceVertical = (orientation & CollectionViewOrientation_Vertical);
        self.alwaysBounceHorizontal = (orientation & CollectionViewOrientation_Horizontal);
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

@end


@interface MKCollectionViewController ()

@property (nonatomic, strong, readwrite) NSMutableArray <__kindof MKCollectionView *> *views;

@end

@implementation MKCollectionViewController

- (instancetype)init {
    if (self = [super init]) {
        self.views = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addView:(__kindof MKCollectionView *)view {
    view.delegate = self;
    view.dataSource = self;
    [self.views addObject:view];
}

- (void)insertView:(__kindof MKCollectionView *)view atIndex:(NSUInteger)index {
    if (index <= self.views.count) {
        view.delegate = self;
        view.dataSource = self;
        [self.views insertObject:view atIndex:index];
    }
}

- (void)replaceViewAtIndex:(NSUInteger)index withView:(__kindof MKCollectionView *)view {
    if (index <= self.views.count) {
        view.delegate = self;
        view.dataSource = self;
        [self.views replaceObjectAtIndex:index withObject:view];
    }
}

- (void)removeView:(__kindof MKCollectionView *)view {
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

- (MKCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKCollectionViewCell alloc] init];
}



@end


@implementation MKSingleCollectionViewController

- (instancetype)init {
    if (self = [super init]) {
        //TODO: only set if at list one item
        self.currentFirstItem = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    return self;
}

- (void)addView:(__kindof MKCollectionView *)view {
    if (self.views.count == 0) {
        view.delegate = self;
        view.dataSource = self;
        [self.views addObject:view];
    }
}

- (void)insertView:(__kindof MKCollectionView *)view atIndex:(NSUInteger)index {
    if (index == 0) {
        [self addView:view];
    }
}

- (void)removeView:(__kindof MKCollectionView *)view {
}

- (void)removeViewAtIndex:(NSUInteger)index {
}


@end

@implementation MKVerticalCollectionHeaderAttributes


@end

@interface MKVerticalCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIColor *borderColor;

@end

@implementation MKVerticalCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 1;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
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


@implementation MKVerticalCollectionViewController

- (void)addView:(__kindof MKCollectionView *)view {
    [super addView:view];
    [view registerClass:[MKVerticalCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MKVerticalCollectionHeaderView identifier]];
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

- (MKCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self verticalCellForItemAtIndexPath:indexPath];
}

- (MKCollectionViewCell *)verticalCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKCollectionViewCell alloc] init];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MKVerticalCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[MKVerticalCollectionHeaderView identifier] forIndexPath:indexPath];
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


@interface MKHorizontalCollectionViewController ()


@end

@implementation MKHorizontalCollectionViewController

- (instancetype)initWithAttributes:(MKCollectionViewAttributes *)attributes {
    if (self = [super init]) {
        MKCollectionView *view = [[MKCollectionView alloc] initWithCollectionViewAttributes:attributes orientation:CollectionViewOrientation_Horizontal];
        [view registerClass:attributes.cellClass forCellWithReuseIdentifier:[attributes.cellClass identifier]];
        self.attributes = attributes;
        [self addView:view];
    }
    return self;
}

- (void)setItemCount:(NSUInteger)itemCount {
    _itemCount = itemCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (MKCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self horizontalCellForItemAtIndexPath:indexPath];
}

- (MKCollectionViewCell *)horizontalCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKCollectionViewCell alloc] init];
}

@end


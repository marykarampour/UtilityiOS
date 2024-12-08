//
//  MKUCollectionMenuViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-09-01.
//

#import "MKUCollectionMenuViewController.h"
#import "AUImageTitleCollectionViewCell.h"
#import "UIViewController+Menu.h"
#import "UIView+Utility.h"

@interface MKUCollectionMenuViewController ()

@property (nonatomic, assign) MKU_IMAGE_TITLE_BORDER_STYLE borderStyle;

@end

@interface MKUCollectionMenuContainerViewController ()

@property (nonatomic, strong) MKUCollectionMenuViewController *collectionViewController;

- (void)constraintViews;

@end

@implementation MKUCollectionMenuViewController

@dynamic object;

- (__kindof MKUCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MKUMenuItemObject *obj = self.object.menuItemObjects[indexPath.item];
    AUImageTitleCollectionViewCell *cell = [[self view] dequeueReusableCellWithReuseIdentifier:[AUImageTitleCollectionViewCell identifier] forIndexPath:indexPath];
    
    cell.textLabel.text = obj.title;
    cell.imageView.image = obj.deselectedIcon;
    [cell setBadgeTitle:obj.badge.description];
    [cell setBorderStyle:self.borderStyle];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.object.menuItemObjects.count;
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.menuDelegate respondsToSelector:@selector(transitionToViewAtIndexPath:)]) {
        [self.menuDelegate transitionToViewAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat padding = self.borderStyle == MKU_IMAGE_TITLE_BORDER_STYLE_ALL ? 0.0 : 44.0;
    CGSize size = [AUImageTitleCollectionViewCell estimatedSize];
    return CGSizeMake(size.width, size.height+padding);
}

- (void)setObject:(MKUMenuSectionObject *)object {
    
    CGFloat padding = 2*kHorizontalMargin - 1;
    
    MKUCollectionViewLayoutAttributes *attributes = [[MKUCollectionViewLayoutAttributes alloc] init];
    attributes.minimumLineSpacing = padding;
    attributes.controllerClass = [self class];
    attributes.frame = CGRectMake(0.0, 0.0, [Constants screenWidth], [Constants screenHeight]);
    attributes.scrollDirection = UICollectionViewScrollDirectionVertical;
    attributes.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    attributes.minimumLineSpacing = 4*kHorizontalMargin;
    attributes.cellClass = [AUImageTitleCollectionViewCell class];
    
    MKUCollectionViewHeaderAttributes *headerAttributes = [[MKUCollectionViewHeaderAttributes alloc] init];
    headerAttributes.backgroundColor = [AppTheme buttonBorderColor];
    headerAttributes.insets = UIEdgeInsetsZero;
    
    self.attributes = attributes;
    self.headerAttributes = headerAttributes;
    
    [self view].backgroundColor = [AppTheme VCBackgroundColor];
    [super setObject:object];
    [self reload];
}

@end

@implementation MKUCollectionMenuContainerViewController

- (instancetype)init {
    return [self initWithStyle:MKU_IMAGE_TITLE_BORDER_STYLE_NONE];
}

- (instancetype)initWithStyle:(MKU_IMAGE_TITLE_BORDER_STYLE)style {
    if (self = [super init]) {
        self.collectionViewController = [[MKUCollectionMenuViewController alloc] init];
        self.collectionViewController.borderStyle = style;
        self.collectionViewController.menuDelegate = self;
        [self createMenuObjects];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self.collectionViewController view]];
    [self constraintViews];
}

- (void)constraintViews {
    [self.view removeConstraintsMask];
    
    if ([Constants UIType] == MKU_UI_TYPE_IPAD) {
        [self.view constraintSidesExcluding:NSLayoutAttributeTop view:[self.collectionViewController view]];
    }
    else {
        [self.view constraintSidesForView:[self.collectionViewController view]];
    }
}

- (void)didSetMenuObjects:(NSArray<MKUMenuSectionObject *> *)menuObjects {
    self.collectionViewController.object = menuObjects.firstObject;
}

- (void)createMenuObjects {
}

- (void)reload {
    [self.collectionViewController reload];
}

- (void)updateBadge:(MKUBadgeItem *)badge {
    [self updateMenuBadge:badge];
}

@end

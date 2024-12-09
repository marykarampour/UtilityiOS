//
//  MKUCellContentController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-02-10.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCellContentController.h"
#import "UIView+Utility.h"

@interface MKUCellContentController ()

@property (nonatomic, assign, readwrite) MKUCellType cellType;
@property (nonatomic, weak, readwrite) __kindof UIView *cell;

@end

@interface MKUTableViewCellContentController : MKUCellContentController

@property (nonatomic, strong) __kindof UITableViewCell *cell;

@end

@implementation MKUTableViewCellContentController

@dynamic cell;

- (void)setTableViewCell:(UITableViewCell *)cell {
    self.cell = cell;
    self.content = self.cell.contentView;
}

@end


@interface MKUCollectionViewCellContentController : MKUCellContentController

@property (nonatomic, strong) __kindof UICollectionViewCell *cell;

@end

@implementation MKUCollectionViewCellContentController

@dynamic cell;

- (void)setCollectionViewCell:(UICollectionViewCell *)cell {
    self.cell = cell;
    self.content = self.cell.contentView;
}

@end


@implementation MKUCellContentController

- (instancetype)initWithCellType:(MKUCellType)type {
    switch (type) {
        case MKUCellTypeTableView: {
            self = [[MKUTableViewCellContentController alloc] init];
        }
            break;
        case MKUCellTypeCollectionView: {
            self = [[MKUCollectionViewCellContentController alloc] init];
        }
            break;
        default:
            break;
    }
    self.cellType = type;
    MKUCellContentController *ll;
    return self;
}

- (void)setTableViewCell:(UITableViewCell *)cell {
}

- (void)setCollectionViewCell:(UICollectionViewCell *)cell {
}

- (void)setView:(__kindof UIView *)view {
    if ([self.content.subviews containsObject:self.view]) {
        [self.view removeFromSuperview];
    }
    _view = view;
    [self.content addSubview:view];
    [self.content removeConstraintsMask];
    [self.content constraint:NSLayoutAttributeTop view:view margin:self.insets.top];
    [self.content constraint:NSLayoutAttributeBottom view:view margin:self.insets.bottom];
    [self.content constraint:NSLayoutAttributeLeft view:view margin:self.insets.left];
    [self.content constraint:NSLayoutAttributeRight view:view margin:self.insets.right];
}

@end

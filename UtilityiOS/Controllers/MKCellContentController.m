//
//  MKCellContentController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-10.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCellContentController.h"
#import "UIView+Utility.h"

@interface MKCellContentController ()

@property (nonatomic, assign, readwrite) MKCellType cellType;
@property (nonatomic, weak, readwrite) __kindof UIView *cell;

@end

@interface MKTableViewCellContentController : MKCellContentController

@property (nonatomic, strong) __kindof UITableViewCell *cell;

@end

@implementation MKTableViewCellContentController

@dynamic cell;

- (void)setTableViewCell:(UITableViewCell *)cell {
    self.cell = cell;
    self.content = self.cell.contentView;
}

@end


@interface MKCollectionViewCellContentController : MKCellContentController

@property (nonatomic, strong) __kindof UICollectionViewCell *cell;

@end

@implementation MKCollectionViewCellContentController

@dynamic cell;

- (void)setCollectionViewCell:(UICollectionViewCell *)cell {
    self.cell = cell;
    self.content = self.cell.contentView;
}

@end


@implementation MKCellContentController

- (instancetype)initWithCellType:(MKCellType)type {
    switch (type) {
        case MKCellTypeTableView: {
            self = [[MKTableViewCellContentController alloc] init];
        }
            break;
        case MKCellTypeCollectionView: {
            self = [[MKCollectionViewCellContentController alloc] init];
        }
            break;
        default:
            break;
    }
    self.cellType = type;
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
    [self.content constraint:NSLayoutAttributeRight view:view margin:-self.insets.right];
}

@end

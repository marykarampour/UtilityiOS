//
//  MultiLabelTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MultiLabelTableViewCell.h"

@interface MultiLabelTableViewCell ()

@property (nonatomic, strong, readwrite) MultiLabelView *viewObject;

@end


@implementation MultiLabelTableViewCell

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MultiLabelTableViewCell identifier]]) {
        self.viewObject = [[MultiLabelView alloc] initWithContentView:self.contentView];
    }
    return self;
}


@end

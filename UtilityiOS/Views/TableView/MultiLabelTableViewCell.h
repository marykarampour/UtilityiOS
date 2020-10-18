//
//  MultiLabelTableViewCell.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKBaseTableViewCell.h"
#import "MultiLabelView.h"



@interface MultiLabelTableViewCell : MKBaseTableViewCell

@property (nonatomic, strong, readonly) __kindof MultiLabelView *viewObject;

@end

//
//  MultiLabelTableViewCell.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKTableViewCell.h"
#import "MultiLabelView.h"



@interface MultiLabelTableViewCell : MKTableViewCell

@property (nonatomic, strong, readonly) __kindof MultiLabelView *viewObject;

@end

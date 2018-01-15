//
//  MKTableViewCell.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKTableViewCell.h"

@implementation MKTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

+ (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"k%@Identifier", NSStringFromClass(self)];
}

+ (CGFloat)estimatedHeight {
    return [Constants DefaultRowHeight];
}

@end

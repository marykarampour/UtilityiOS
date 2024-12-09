//
//  MKUButtonHeaderView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-07.
//

#import "MKUSingleViewTableViewHeaderFooterView.h"
#import "MKUButtonView.h"

@interface MKUButtonHeaderView : MKUSingleViewTableViewHeaderFooterView <MKUButtonImageView *>

- (instancetype)initWithAccessoryImageSize:(CGFloat)size;

@end

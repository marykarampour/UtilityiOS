//
//  MKUDateTableViewCell.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUBaseTableViewCell.h"

@interface MKUDateTableViewCell : MKUBaseTableViewCell

- (void)setDateText:(NSString *)dateString;
- (void)setDoneHidden:(BOOL)isHidden;

@end


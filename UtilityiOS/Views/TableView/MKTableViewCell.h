//
//  MKTableViewCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCellContentController.h"

@interface MKTableViewCell : UITableViewCell

@property (nonatomic, strong) MKCellContentController *cellController;

+ (NSString *)identifier;
+ (CGFloat)estimatedHeight;
+ (UIImageView *)imageAccessoryView;

@end

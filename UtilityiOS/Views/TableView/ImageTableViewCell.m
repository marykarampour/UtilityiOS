//
//  ImageTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "UIView+Utility.h"

static CGFloat const PADDING = 4.0;

@interface ImageTableViewCell ()

@end

@implementation ImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView removeConstraintsMask];
        
        NSDictionary *views = @{@"imageView":self.imageView};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[imageView]-%f-|", PADDING, PADDING] options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[imageView]-%f-|", PADDING, PADDING] options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)setImage:(NSString *)image {
    self.imageView.image = [UIImage imageNamed:image];
}

@end

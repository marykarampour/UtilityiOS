//
//  MKUImageTitleCollectionViewCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-08.
//

#import "MKUCollectionView.h"
#import "MKUBadgeView.h"

/** @brief Icons and title label at the bottom.
 @note Override initBase and setBorderStyle to adjust style, activeColor and inactiveColor. */
@interface MKUImageTitleCollectionViewCell : MKUCollectionViewCell

@property (nonatomic, strong, readonly) MKUBadgeView *badgeView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, assign) MKU_IMAGE_TITLE_BORDER_STYLE borderStyle;

- (void)setBadgeTitle:(NSString *)title;
- (void)initBase;

@end


//
//  ButtonView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-09-01.
//

#import <UIKit/UIKit.h>
#import "MKUViewProtocol.h"
#import "UIControl+IndexPath.h"
#import "MKUBadgeView.h"

@interface MKUButtonView <__covariant ObjectType : UIView *> : UIView <MKUControlProtocol>

@property (nonatomic, strong, readonly) UILabel *titleView;
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong) ObjectType badgeView;

- (instancetype)initWithStyle:(MKU_VIEW_STYLE)style;

/** @param size Pass 0 to ignore badgeView. If 0 only titleView is constrained,  */
- (instancetype)initWithBadgeSize:(CGFloat)size;

/** @param size Pass 0 to ignore badgeView. If 0 only titleView is constrained,  */
- (instancetype)initWithBadgeSize:(CGFloat)size viewCreationHandler:(VIEW_CREATION_HANDLER)handler;

- (void)setLabelTitle:(NSString *)title;
- (void)setIndexPath:(NSIndexPath *)indexPath;
/** @brief Sets the color of a 1 pixel separator line at the bottom. Pass nil to hide.
 @note Only available with style MKU_VIEW_STYLE_PLAIN and when initWithImageSize is used to initialize. */
- (void)setSeparatorColor:(UIColor *)color;

/** @brief subtitle If empty, the title is set to text of titleView, otherwise, attributedText is set.  subtitle is displayed below title. */
- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle;

/** @brief value If empty, the title is set to text of titleView, otherwise, attributedText is set. value is displayed right of title. */
- (void)setTitle:(NSString *)title value:(NSString *)value;

+ (MKUButtonView *)BlueButtonWithTitle:(NSString *)title;
+ (MKUButtonView *)BlueButtonWithTitle:(NSString *)title hidden:(BOOL)hidden;
+ (MKUButtonView *)detailButtonWithStyle:(MKU_VIEW_STYLE)style;
+ (MKUButtonView *)cornerDetailButtonWithStyle:(MKU_VIEW_STYLE)style;

@end

@interface MKUButtonImageView : MKUButtonView <UIImageView *>

- (void)setImageName:(NSString *)image;
- (void)setImage:(UIImage *)image;
+ (MKUButtonImageView *)detailButton;
+ (MKUButtonImageView *)cornerDetailButton;
+ (MKUButtonImageView *)detailButtonWithTitle:(NSString *)title;

@end

@interface MKUButtonBadgeView : MKUButtonView <MKUBadgeView *>

@end


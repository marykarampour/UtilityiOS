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

+ (instancetype)BlueButtonWithTitle:(NSString *)title;
+ (instancetype)BlueButtonWithTitle:(NSString *)title hidden:(BOOL)hidden;
+ (instancetype)detailButtonWithStyle:(MKU_VIEW_STYLE)style;
+ (instancetype)cornerDetailButtonWithStyle:(MKU_VIEW_STYLE)style;
+ (instancetype)cornerDetailButton;
+ (instancetype)detailButton;

@end

@interface MKUButtonImageView : MKUButtonView <UIImageView *>

- (void)setImageName:(NSString *)image;
- (void)setImage:(UIImage *)image;
+ (instancetype)detailButtonWithTitle:(NSString *)title;

@end

@interface MKUButtonBadgeView : MKUButtonView <MKUBadgeView *>

@end


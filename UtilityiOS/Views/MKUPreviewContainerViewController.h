//
//  MKUPreviewContainerViewController.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUPreviewView.h"
#import "ActionObject.h"

@class MKUPreviewContainerViewController;

@protocol MKUPreviewProtocol <NSObject>

@required
/** @breif actions associated with different states of the right button, e.g. save, replace, etc.
 @note call in or after viewDidLoad
 */
@property (nonatomic, strong) NSArray <ActionObject *> *rightButtonActions;

/** @brief no need to set this, this is automatically set to container when maiinVC is set */
@property (nonatomic, weak) __kindof MKUPreviewContainerViewController *containerVC;


@optional
/** @brief implement to set fonts and colors */
- (void)customizePreview:(MKUPreviewView *)preview;

@end


@interface MKUPreviewContainerViewController : UIViewController

/** @brief main view controller, preview appears over this VC's view */
@property (nonatomic, strong) __kindof UIViewController<MKUPreviewProtocol> *mainVC;

@property (nonatomic, strong, readonly) MKUPreviewView *preview;

/** @brief sets the title of the right button to title of action object at the given index */
- (void)setRightButtonTitleAtIndex:(NSUInteger)index;

- (void)loadPreviewWithData:(NSData *)data URL:(NSURL *)URL;
- (NSData *)previewThumbnailData;

@end

//
//  MKUCollectionMenuViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-09-01.
//

#import "MKUCollectionView.h"
#import "MKUMenuObjects.h"
#import "MKUMenuProtocols.h"

@interface MKUCollectionMenuViewController : MKUSingleCollectionViewController

@property (nonatomic, strong) MKUMenuSectionObject *object;
@property (nonatomic, weak) id<MKUMenuViewControllerProtocol> menuDelegate;

@end

@interface MKUCollectionMenuContainerViewController : UIViewController <MKUMenuViewControllerProtocol>

- (instancetype)initWithStyle:(MKU_IMAGE_TITLE_BORDER_STYLE)style;
- (MKUCollectionMenuViewController *)collectionViewController;

@end

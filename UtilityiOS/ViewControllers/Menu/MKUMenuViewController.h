//
//  MKUMenuViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-07.
//

#import "MKUCollapsableSectionsViewController.h"
#import "MKUViewControllerTransitionProtocol.h"
#import "MKUMenuProtocols.h"

@interface MKUMenuViewController : MKUCollapsableSectionsViewController <MKUMenuViewControllerProtocol, MKUViewControllerTransitionDelegate>

@property (nonatomic, assign) BOOL canLoadMenuObjects;

/** @brief When a row not containing a spinner is selected, by default it calls [super didSelectNonDateRowAtIndexPath:] and transitionToView:. */
- (void)didSelectNoneSpinnerRowAtIndexPath:(NSIndexPath *)indexPath;

/** @brief When a row containing a spinner is selected, by default it does nothing. Override for custom functioanlity. */
- (void)handleDidSelectSpinnerRowAtIndexPath:(NSIndexPath *)indexPath;

/** @brief Called in didSelectNoneSpinnerRowAtIndexPath: By default calls transitionToViewAtIndexPath: implemented in UIViewController (Menu). */
- (void)handleTransitionToViewAtIndexPath:(NSIndexPath *)indexPath;

@end

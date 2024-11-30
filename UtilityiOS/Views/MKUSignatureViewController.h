//
//  MKUSignatureViewController.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKURotatedTextView.h"
#import "MKUDrawingView.h"

@protocol MKUSignatureViewProtocol <NSObject>

@optional
- (void)doneWithSignatureData:(NSData *)data;

@end

/** @brief a generic signature view with a title and a clear button
 @note subviews are created in viewDidLoad, override subclass's viewDidLoad to customize */
@interface MKUSignatureViewController : UIViewController

@property (nonatomic, strong, readonly) MKUDrawingView *signatureView;
@property (nonatomic, strong, readonly) MKURotatedTextLabel *titleLabel;
@property (nonatomic, strong, readonly) MKURotatedTextButton *clearButton;

@property (nonatomic, strong) NSString *doneButtonTitle;

/** @brief a value percent from 0 to 1 indicating minimum proportion of image to be a valid signature to enable the done button */
@property (nonatomic, assign) CGFloat minimumSignatureProportion;

@property (nonatomic, weak) id<MKUSignatureViewProtocol> signatureDelegate;

@end

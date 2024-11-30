//
//  MKUSignatureViewController.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUSignatureViewController.h"
#import "UIViewController+Utility.h"
#import "UIView+Utility.h"
#import "UIImage+Editing.h"

@interface MKUSignatureViewController () <MKUDrawingViewProtocol>

@property (nonatomic, strong, readwrite) MKUDrawingView *signatureView;
@property (nonatomic, strong, readwrite) MKURotatedTextLabel *titleLabel;
@property (nonatomic, strong, readwrite) MKURotatedTextButton *clearButton;

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation MKUSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:self.doneButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    //TODO: for orientation
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[MKURotatedTextLabel alloc] init];
    self.titleLabel.angle = M_PI_2;

    self.clearButton = [[MKURotatedTextButton alloc] init];
    self.clearButton.angle = M_PI_2;
    [self.clearButton addTarget:self action:@selector(clearPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.signatureView = [[MKUDrawingView alloc] init];
    self.signatureView.delegate = self;
    self.signatureView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.signatureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [self.view bringSubviewToFront:self.signatureView];
    
    CGFloat tabHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat padding = 8.0;
    CGFloat topBarHeight = [self topBarHeight];
    CGFloat buttonHeight = 80.0;
    CGFloat signHeight = self.view.frame.size.height - (topBarHeight + tabHeight + 2*padding);
    CGFloat titleHeight = signHeight - (padding + buttonHeight);
    
    [self.view removeConstraintsMask];
    
    [self.view constraint:NSLayoutAttributeTop view:self.titleLabel margin:padding];
    [self.view constraint:NSLayoutAttributeRight view:self.titleLabel margin:-padding];
    [self.view constraintHeight:titleHeight forView:self.titleLabel];
    [self.view constraintWidth:titleHeight forView:self.titleLabel];
    
    [self.view constraint:NSLayoutAttributeBottom view:self.clearButton margin:-tabHeight-padding];
    [self.view constraint:NSLayoutAttributeRight view:self.clearButton margin:-padding];
    [self.view constraintHeight:buttonHeight forView:self.clearButton];
    [self.view constraintWidth:buttonHeight forView:self.clearButton];
    
    [self.view constraint:NSLayoutAttributeTop view:self.signatureView margin:padding];
    [self.view constraint:NSLayoutAttributeLeft view:self.signatureView margin:padding];
    [self.view constraintHeight:signHeight forView:self.signatureView];
    [self.view constraintWidth:256.0 forView:self.signatureView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)donePressed:(UIBarButtonItem *)sender {
    UIImage *image = [[self.signatureView image] rotate:-self.titleLabel.angle];
    NSData *data = UIImagePNGRepresentation(image);
    
    if ([self.signatureDelegate respondsToSelector:@selector(doneWithSignatureData:)]) {
        [self.signatureDelegate doneWithSignatureData:data];
    }
}

- (void)clearPressed:(UIButton *)sender {
    [self.signatureView clearView];
    [self checkSaveEnabledWithImage:[self.signatureView image]];
}

- (void)touchesEndedWithImage:(UIImage *)image {
    [self checkSaveEnabledWithImage:image];
}

- (void)checkSaveEnabledWithImage:(UIImage *)image {
    [self.doneButton setEnabled:[image hasNonWhitePixelsForMinimumPercent:self.minimumSignatureProportion]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

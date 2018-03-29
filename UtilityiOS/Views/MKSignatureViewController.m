//
//  MKSignatureViewController.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKSignatureViewController.h"
#import "MKRotatedTextView.h"
#import "UIView+Utility.h"
#import "MKDrawingView.h"

@interface MKSignatureViewController ()

@property (nonatomic, strong) MKDrawingView *signatureView;
@property (nonatomic, strong) MKRotatedTextLabel *titleLabel;
@property (nonatomic, strong) MKRotatedTextButton *clearButton;

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation MKSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:[Constants Done_STR] style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[MKRotatedTextLabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.angle = M_PI_2;
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"Failed to register for remote notifications with error: REMOTE_NOTIFICATION_SIMULATOR_NOT_SUPPORTED_NSERROR_DESCRIPTION"];
    self.titleLabel.attributedText = attr;
    
    self.clearButton = [[MKRotatedTextButton alloc] init];
    self.clearButton.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"clear"];
    self.clearButton.titleLabel.textAlignment = NSTextAlignmentRight;
    self.clearButton.angle = M_PI_2;
    
    self.signatureView = [[MKDrawingView alloc] init];
    self.signatureView.backgroundColor = [UIColor whiteColor];
    self.signatureView.layer.borderColor = [UIColor blueColor].CGColor;
    self.signatureView.layer.borderWidth = 2.0;
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.signatureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.signatureView];
    
    CGFloat navHeight =  self.navigationController.navigationBar.frame.size.height;
    CGFloat tabHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat statusHeight = [Constants safeAreaInsets];
    CGFloat padding = 8.0;
    CGFloat buttonHeight = 80.0;
    CGFloat signHeight = self.view.frame.size.height - (navHeight+statusHeight+tabHeight + 2*padding);
    CGFloat titleHeight = signHeight - (padding + buttonHeight);
    CGFloat topMargin = navHeight+statusHeight+padding;
    
    [self.view removeConstraintsMask];
    
    [self.view constraint:NSLayoutAttributeTop view:self.titleLabel margin:topMargin];
    [self.view constraint:NSLayoutAttributeRight view:self.titleLabel margin:-padding];
    [self.view constraintHeight:titleHeight forView:self.titleLabel];
    [self.view constraintWidth:titleHeight forView:self.titleLabel];
    
    [self.view constraint:NSLayoutAttributeBottom view:self.clearButton margin:-tabHeight-padding];
    [self.view constraint:NSLayoutAttributeRight view:self.clearButton margin:-padding];
    [self.view constraintHeight:buttonHeight forView:self.clearButton];
    [self.view constraintWidth:buttonHeight forView:self.clearButton];
    
    [self.view constraint:NSLayoutAttributeTop view:self.signatureView margin:topMargin];
    [self.view constraint:NSLayoutAttributeLeft view:self.signatureView margin:padding];
    [self.view constraintHeight:signHeight forView:self.signatureView];
    [self.view constraintWidth:256.0 forView:self.signatureView];
}

- (void)donePressed:(UIBarButtonItem *)sender {
    UIImage *image = [self.signatureView image];
    NSData *data = UIImagePNGRepresentation(image);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MKPreviewContainerViewController.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKPreviewContainerViewController.h"
#import "UIViewController+Utility.h"
#import "UIImage+Editing.h"
#import "NSData+Utility.h"
#import "UIView+Utility.h"
#import "MKSpinner.h"

@interface MKPreviewContainerViewController () <UIWebViewDelegate> {
    UIView *mainView;
}

@property (nonatomic, strong, readwrite) MKPreviewView *preview;

@end

@implementation MKPreviewContainerViewController

- (instancetype)init {
    if (self = [super init]) {
        mainView = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view removeConstraintsMask];
    [self.view constraintSidesForView:self.mainVC.view];
    [self.view constraintSidesForView:self.preview];
}

- (void)setMainVC:(__kindof UIViewController<MKPreviewProtocol> *)mainVC {
    _mainVC = mainVC;
    _mainVC.containerVC = self;
}

- (void)constructViews {
    [self setChildView:self.mainVC forSubView:&mainView];
    
    self.preview = [[MKPreviewView alloc] init];
    [self.preview.leftButton setTitle:@"X" forState:UIControlStateNormal];
    [self.preview.leftButton addTarget:self action:@selector(leftPreviewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.rightButton addTarget:self action:@selector(rightPreviewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.preview.view.delegate = self;
    self.preview.hidden = YES;
    
    [self.view addSubview:mainView];
    [self.view addSubview:self.preview];
}

- (void)leftPreviewButtonPressed:(UIButton *)sender {
    self.preview.hidden = YES;
}

- (void)rightPreviewButtonPressed:(UIButton *)sender {
    self.preview.hidden = YES;
    for (ActionObject *act in self.mainVC.rightButtonActions) {
        if ([sender.titleLabel.text isEqualToString:act.title]) {
            [act.target performSelector:act.action withObject:sender];
            break;
        }
    }
}

- (void)setRightButtonTitleAtIndex:(NSUInteger)index {
    if (index < self.mainVC.rightButtonActions.count) {
        [self.preview.rightButton setTitle:self.mainVC.rightButtonActions[index].title forState:UIControlStateNormal];
    }
}

#pragma mark - web view

- (void)loadPreviewWithData:(NSData *)data URL:(NSURL *)URL {
    self.preview.hidden = NO;
    [self.preview.view loadData:data MIMEType:[data contentType] textEncodingName:@"utf-8" baseURL:URL];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MKSpinner show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MKSpinner hide];
    
    UIGraphicsBeginImageContextWithOptions(self.preview.view.frame.size, self.preview.view.opaque, 1.0);
    [self.preview.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = [img shrink];
    
    if ([self.mainVC respondsToSelector:@selector(preViewDidFinishLoadWithThumbnailData:)]) {
        [self.mainVC preViewDidFinishLoadWithThumbnailData:data];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MKSpinner hide];
    DEBUGLOG(@"%@", error.localizedDescription);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

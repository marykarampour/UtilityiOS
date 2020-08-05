//
//  MKPreviewView.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebKit/WebKit.h"

@interface MKPreviewView : UIView

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) WKWebView *view;

@end

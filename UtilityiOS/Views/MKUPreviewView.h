//
//  MKUPreviewView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebKit/WebKit.h"

@interface MKUPreviewView : UIView

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) WKWebView *view;

@end

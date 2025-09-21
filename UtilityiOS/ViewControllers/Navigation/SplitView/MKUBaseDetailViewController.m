//
//  MKUBaseDetailViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUBaseDetailViewController.h"
#import "UIView+Utility.h"

@interface MKUBaseDetailViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation MKUBaseDetailViewController

- (instancetype)init {
    return [self initWithImage:@""];
}

- (instancetype)initWithImage:(NSString *)image {
    if (self = [super init]) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [AppTheme VCBackgroundColor];
    [self.view addSubview:self.backgroundImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view constraintSidesForView:self.backgroundImageView];
}

- (void)setBackgroundHidden:(BOOL)hidden {
    self.backgroundImageView.hidden = hidden;
}

@end

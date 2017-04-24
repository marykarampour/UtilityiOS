//
//  BaseDetailViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "BaseDetailViewController.h"

@interface BaseDetailViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BaseDetailViewController

- (instancetype)init {
    return [self initWithImage:@""];
}

- (instancetype)initWithImage:(NSString *)image {
    if (self = [super init]) {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor VCBackground];
    self.backgroundImageView.hidden = YES;
    [self.view addSubview:self.backgroundImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_backgroundImageView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backgroundImageView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backgroundImageView]-0-|" options:0 metrics:nil views:views]];
}

- (void)setBackgroundHidden:(BOOL)hidden {
    self.backgroundImageView.hidden = hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

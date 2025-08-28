//
//  MKUSplitContainerViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUSplitContainerViewController.h"
#import "UIViewController+Utility.h"
#import "UIView+Utility.h"

@interface MKUSplitContainerViewController () {
    UIView *mainView;
    UIView *detailView;
}

@property (nonatomic, strong) UIView *detailBackView;

@end

@implementation MKUSplitContainerViewController

- (instancetype)init {
    if (self = [super init]) {
        self.padding = 16.0;
        self.detailBackView = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [AppTheme defaultSectionHeaderColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self constraintLayout];
}

- (void)setMainVC:(__kindof UIViewController *)mainVC {
    _mainVC = mainVC;
    [self constraintLayout];
}

- (void)constraintLayout {
    if (!self.mainVC || [self.view.subviews containsObject:mainView]) return;
    
    [self setChildView:self.mainVC forSubView:&mainView];
    [self.view addSubview:self.detailBackView];
    [self.view addSubview:mainView];
    
    [self.view removeConstraintsMask];
    
    if (self.alignment == MKU_VIEW_ALIGNMENT_TYPE_HORIZONTAL) {
        
        [self.view constraintHorizontally:[NSArray arrayWithObjects:mainView, self.detailBackView, nil] interItemMargin:self.padding horizontalMargin:self.padding verticalMargin:self.padding equalWidths:self.mainVCSize <= 0.0];
        
        if (0 < self.mainVCSize) {
            [self.view constraintWidth:self.mainVCSize forView:mainView];
        }
        else if (0 < self.detailVCSize) {
            [self.view constraintWidth:self.detailVCSize forView:self.detailBackView];
        }
    }
    else {
        [self.view constraintVertically:[NSArray arrayWithObjects:mainView, self.detailBackView, nil] interItemMargin:self.padding horizontalMargin:self.padding verticalMargin:self.padding equalHeights:self.mainVCSize <= 0.0];
        
        if (0 < self.mainVCSize) {
            [self.view constraintHeight:self.mainVCSize forView:mainView];
        }
        else if (0 < self.detailVCSize) {
            [self.view constraintHeight:self.detailVCSize forView:self.detailBackView];
        }
    }
}

- (void)setViewWithDetailVC:(UIViewController *)VC {
    [self.detailBackView removeAllSubviews];
    if (!VC) return;

    detailView = [[UIView alloc] init];
    [self setChildView:VC forSubView:&detailView];
    [self.detailBackView addSubview:detailView];
    [self.detailBackView removeConstraintsMask];
    [self.detailBackView constraintSidesForView:detailView];
}

@end

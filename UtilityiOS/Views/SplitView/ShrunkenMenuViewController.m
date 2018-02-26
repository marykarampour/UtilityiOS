//
//  ShrunkenMenuViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "ShrunkenMenuViewController.h"
#import "MultiLabelTableViewCell.h"
#import "SplitViewManager.h"

@interface ShrunkenMenuViewController ()

@property (nonatomic, strong) StringArr *images;

@end

@implementation ShrunkenMenuViewController

- (instancetype)init {
    return [self initWithImages:@[]];
}

- (instancetype)initWithImages:(StringArr *)images {
    if (self = [super init]) {
        self.images = images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, -8.0, 0.0, 0.0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadDataAnimated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return [self tabCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Constants PrimaryColumnShrunkenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiLabelTableViewCell *cell = (MultiLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MultiLabelTableViewCell identifier]];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.width)];
    [img setImage:[UIImage imageNamed:(indexPath.row < [self tabCount] ? self.images[indexPath.row] : @"")]];

    if (!cell) {
        
        cell = [[MultiLabelTableViewCell alloc] initWithType:MultiLabelViewType_NONE leftView:img rightView:nil labelsCount:0 insets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self tabCount]) {
        [[SplitViewManager instance].splitViewController setSelectedTab:indexPath.row];
    }
}

- (NSUInteger)tabCount {
    return [[SplitViewManager instance].splitViewController tabCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

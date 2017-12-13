//
//  ShrunkenMenuViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "ShrunkenMenuViewController.h"
#import "ImageTableViewCell.h"
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadDataAnimated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TabBarIndexCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Constants PrimaryColumnShrunkenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ImageTableViewCell identifier]];
    if (!cell) {
        cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ImageTableViewCell identifier]];
    }
    [cell setImage:(indexPath.row < TabBarIndexCount ? self.images[indexPath.row] : @"")];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < TabBarIndexCount) {
        [[SplitViewManager instance].splitViewController setSelectedTab:indexPath.row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

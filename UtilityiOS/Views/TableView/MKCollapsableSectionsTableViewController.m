//
//  MKCollapsableSectionsTableViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCollapsableSectionsTableViewController.h"
#import "UIControl+IndexPath.h"
#import "MKButtonImageView.h"

@implementation MKTableViewSection

+ (MKTableViewSection *)sectionCollapsable:(BOOL)isCollapsable expanded:(BOOL)isExpanded {
    MKTableViewSection *section = [[MKTableViewSection alloc] init];
    section.isCollapsable = isCollapsable;
    section.isExpanded = isExpanded;
    return section;
}

@end

@interface MKCollapsableSectionsTableViewController ()

@end

@implementation MKCollapsableSectionsTableViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style])  {
        self.sections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (MKTableViewSection *)sectionObjectForIndex:(NSUInteger)section {
    if (section < self.sections.count) {
        return self.sections[section];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MKTableViewSection *sect = [self sectionObjectForIndex:section];
    return (!sect.isCollapsable || (sect.isCollapsable && sect.isExpanded) ? [self numberOfRowsInSectionWhenExpanded:section] : 0);
}

- (NSUInteger)numberOfRowsInSectionWhenExpanded:(NSUInteger)section {
    RaiseExceptionMissingMethodInClass
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableViewSection *sect = [self sectionObjectForIndex:section];
    if (sect.isCollapsable) {
        MKButtonImageView *header = [[MKButtonImageView alloc] init];
        [header setLabelTitle:[self tableView:self.tableView titleForHeaderInSection:section]];
        [header setTarget:self action:@selector(headerPressed:)];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:section];
        [header setIndexPath:indexPath];
        [header setImageName:(sect.isExpanded ? @"chevron-down" : @"chevron-right")];
        return header;
    }
    return [self viewForHeaderInSection:section];
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)headerPressed:(UIButton *)sender {
    NSIndexPath *indexPath = sender.indexPath;
    MKTableViewSection *sect = [self sectionObjectForIndex:indexPath.section];
    if (sect.isCollapsable) {
        if ([self.tableView numberOfRowsInSection:indexPath.section] > 0) {
            sect.isExpanded = !sect.isExpanded;
            [self reloadSection:indexPath.section withHeader:YES];
        }
        else {
            //perform did select section
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

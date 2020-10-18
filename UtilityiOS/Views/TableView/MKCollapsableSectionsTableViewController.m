//
//  MKCollapsableSectionsTableViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCollapsableSectionsTableViewController.h"
#import "UIControl+IndexPath.h"

@interface MKCollapsableSectionsTableViewController ()

@property (nonatomic, strong) MKPairArray <__kindof MKTableViewSection *, __kindof MKButtonView *> *headers;

@end

@implementation MKCollapsableSectionsTableViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style])  {
        self.sections = [[NSMutableArray alloc] init];
        self.headers = [[MKPairArray alloc] init];
        self.multiExpandedSectionEnabled = YES;
        self.reloadSectionsAnimated = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createSections {
    
}

- (void)setSections:(NSMutableArray<__kindof MKTableViewSection *> *)sections {
    _sections = sections;
    for (MKTableViewSection *sect in sections) {
        [self.headers addPair:[MKPair first:sect second:nil]];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableViewSection *sect = [self sectionObjectForIndex:section];
    MKButtonView *header = [self headerViewForSection:section];
    [self customizeViewForHeader:header inSection:sect section:section];
    return header.contentView;
}

- (MKButtonView *)headerViewForSection:(NSUInteger)section {
    
    MKTableViewSection *sect = [self sectionObjectForIndex:section];
    MKButtonView *header = [self.headers objectForKey:sect];
    
    if (!header) {
        if (sect.isCollapsable) {
            header = [self viewObjectForHeaderInCollapsableSection:section];
        }
        else {
            header = [self viewObjectForHeaderInSection:section];
        }
        MKPair *pair = [MKPair first:sect second:header];
        [self.headers setPair:pair atIndex:section];
    }
    return header;
}

- (MKButtonView *)headerViewForSectionObject:(__kindof MKTableViewSection *)sect {
    NSInteger index = [self.sections indexOfObject:sect];
    if (index != NSNotFound) {
        return [self headerViewForSection:index];
    }
    return nil;
}

- (void)customizeViewForHeader:(__kindof MKButtonView *)header inSection:(MKTableViewSection *)sect section:(NSInteger)section {
    if (![header isKindOfClass:[MKButtonView class]]) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:section];
    [header setIndexPath:indexPath];
    header.delegate = self;
}

- (MKButtonView *)viewObjectForHeaderInSection:(NSInteger)section {
    return [[MKButtonView alloc] initWithContentView:[self viewForHeaderInSection:section]];
}

- (MKButtonView *)viewObjectForHeaderInCollapsableSection:(NSInteger)section {
    return [[MKButtonView alloc] initWithContentView:[self viewForHeaderInCollapsableSection:section]];
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)viewForHeaderInCollapsableSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)performUpdateHeaderForSection:(MKTableViewSection *)sect section:(NSUInteger)section {
    if (!self.multiExpandedSectionEnabled) {
        
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:section];
        
        [self.sections enumerateObjectsUsingBlock:^(__kindof MKTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj != sect && obj.isExpanded) {
                obj.isExpanded = NO;
                [set addIndex:idx];
            }
            [self updateHeaderForSection:idx];
        }];
        if (self.reloadSectionsAnimated) {
            [self reloadSectionsSet:set completion:nil];
        }
    }
    else {
        if (self.reloadSectionsAnimated) {
            [self reloadSection:section withHeader:YES];
        }
    }
    if (!self.reloadSectionsAnimated) {
        [self reloadDataAnimated:NO];
    }
}

- (void)updateHeaderForSection:(NSUInteger)section {
}

- (void)buttonView:(MKButtonView *)view setSelected:(BOOL)selected {
    
    NSIndexPath *path = view.backView.indexPath;
    MKTableViewSection *sect = [self sectionObjectForIndex:path.section];
    
    if (!sect.isEnabled || !sect.isCollapsable) return;
    
    if (self.exclusiveExpandForSelected) {
        if (selected && !sect.isExpanded) {
            sect.isExpanded = YES;
        }
        else if (!selected && sect.isExpanded) {
            sect.isExpanded = NO;
        }
    }
    else {
        sect.isExpanded = !sect.isExpanded;
    }
    
    [self performUpdateHeaderForSection:sect section:path.section];
}

@end

//
//  MKUCollapsableSectionsTableViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollapsableSectionsTableViewController.h"
#import "UIControl+IndexPath.h"

@interface MKUCollapsableSectionsTableViewController ()

@property (nonatomic, strong) MKUPairArray <__kindof MKUTableViewSection *, __kindof MKUButtonView *> *headers;

@end

@implementation MKUCollapsableSectionsTableViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style])  {
        self.sections = [[NSMutableArray alloc] init];
        self.headers = [[MKUPairArray alloc] init];
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

- (void)setSections:(NSMutableArray<__kindof MKUTableViewSection *> *)sections {
    _sections = sections;
    for (MKUTableViewSection *sect in sections) {
        [self.headers addPair:[MKUPair pairWithFirst:sect second:nil]];
    }
}

- (MKUTableViewSection *)sectionObjectForIndex:(NSUInteger)section {
    if (section < self.sections.count) {
        return self.sections[section];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MKUTableViewSection *sect = [self sectionObjectForIndex:section];
    return (!sect.isCollapsable || (sect.isCollapsable && sect.isExpanded) ? [self numberOfRowsInSectionWhenExpanded:section] : 0);
}

- (NSUInteger)numberOfRowsInSectionWhenExpanded:(NSUInteger)section {
    MKURaiseExceptionMissingMethodInClass
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKUTableViewSection *sect = [self sectionObjectForIndex:section];
    MKUButtonView *header = [self headerViewForSection:section];
    [self customizeViewForHeader:header inSection:sect section:section];
    return header.contentView;
}

- (MKUButtonView *)headerViewForSection:(NSUInteger)section {
    
    MKUTableViewSection *sect = [self sectionObjectForIndex:section];
    MKUButtonView *header = [self.headers objectForKey:sect];
    
    if (!header) {
        if (sect.isCollapsable) {
            header = [self viewObjectForHeaderInCollapsableSection:section];
        }
        else {
            header = [self viewObjectForHeaderInSection:section];
        }
        MKUPair *pair = [MKUPair pairWithFirst:sect second:header];
        [self.headers setPair:pair atIndex:section];
    }
    return header;
}

- (MKUButtonView *)headerViewForSectionObject:(__kindof MKUTableViewSection *)sect {
    NSInteger index = [self.sections indexOfObject:sect];
    if (index != NSNotFound) {
        return [self headerViewForSection:index];
    }
    return nil;
}

- (void)customizeViewForHeader:(__kindof MKUButtonView *)header inSection:(MKUTableViewSection *)sect section:(NSInteger)section {
    if (![header isKindOfClass:[MKUButtonView class]]) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:section];
    [header setIndexPath:indexPath];
    header.delegate = self;
}

- (MKUButtonView *)viewObjectForHeaderInSection:(NSInteger)section {
    return [[MKUButtonView alloc] initWithContentView:[self viewForHeaderInSection:section]];
}

- (MKUButtonView *)viewObjectForHeaderInCollapsableSection:(NSInteger)section {
    return [[MKUButtonView alloc] initWithContentView:[self viewForHeaderInCollapsableSection:section]];
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)viewForHeaderInCollapsableSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)performUpdateHeaderForSection:(MKUTableViewSection *)sect section:(NSUInteger)section {
    if (!self.multiExpandedSectionEnabled) {
        
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:section];
        
        [self.sections enumerateObjectsUsingBlock:^(__kindof MKUTableViewSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)buttonView:(MKUButtonView *)view setSelected:(BOOL)selected {
    
    NSIndexPath *path = view.backView.indexPath;
    MKUTableViewSection *sect = [self sectionObjectForIndex:path.section];
    
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

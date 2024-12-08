//
//  MKUCollapsingSectionsTableViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollapsingSectionsTableViewController.h"
#import "UIControl+IndexPath.h"

@interface MKUCollapsingSectionsTableViewController ()

@property (nonatomic, strong) MKUPairArray <__kindof MKUTableViewSection *, __kindof MKUButtonLabelView *> *headers;

@end

@implementation MKUCollapsingSectionsTableViewController

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
    MKUButtonLabelView *header = [self headerViewForSection:section];
    [self customizeViewForHeader:header inSection:sect section:section];
    return header.contentView;
}

- (MKUButtonLabelView *)headerViewForSection:(NSUInteger)section {
    
    MKUTableViewSection *sect = [self sectionObjectForIndex:section];
    MKUButtonLabelView *header = [self.headers objectForKey:sect];
    
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

- (MKUButtonLabelView *)headerViewForSectionObject:(__kindof MKUTableViewSection *)sect {
    NSInteger index = [self.sections indexOfObject:sect];
    if (index != NSNotFound) {
        return [self headerViewForSection:index];
    }
    return nil;
}

- (void)customizeViewForHeader:(__kindof MKUButtonLabelView *)header inSection:(MKUTableViewSection *)sect section:(NSInteger)section {
    if (![header isKindOfClass:[MKUButtonLabelView class]]) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:section];
    [header setIndexPath:indexPath];
    header.delegate = self;
}

- (MKUButtonLabelView *)viewObjectForHeaderInSection:(NSInteger)section {
    return [[MKUButtonLabelView alloc] initWithContentView:[self viewForHeaderInSection:section]];
}

- (MKUButtonLabelView *)viewObjectForHeaderInCollapsableSection:(NSInteger)section {
    return [[MKUButtonLabelView alloc] initWithContentView:[self viewForHeaderInCollapsableSection:section]];
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

- (void)buttonView:(MKUButtonLabelView *)view setSelected:(BOOL)selected {
    
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

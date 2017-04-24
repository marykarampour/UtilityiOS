//
//  MKTableViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKTableViewController.h"

@interface MKTableViewController ()

@end

@implementation MKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}




#pragma mark - helpers

- (void)reloadDataAnimated:(BOOL)animated {
    if (animated) {
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView])];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.tableView numberOfSections] == sections.count) {
                [self.tableView beginUpdates];
                [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }
            else {
                [self.tableView reloadData];
            }
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

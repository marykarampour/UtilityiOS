//
//  MKUItemsListViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUItemsListViewController.h"

@interface MKUItemsListViewController ()

@end

@implementation MKUItemsListViewController

- (void)initBase {
    [super initBase];
    [self setEditButtonHidden:YES];
}

- (BOOL)canSelectItemsInListOfType:(NSUInteger)type {
    return YES;
}

- (void)initSelectedActionHandler {
    self.selectedActionHandler = ^MKU_LIST_ITEM_SELECTED_ACTION(NSUInteger section) {
        return MKU_LIST_ITEM_SELECTED_ACTION_SELECT;
    };
}

@end

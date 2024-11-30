//
//  MKUSearchResultsTransitionViewController.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSearchResultsTransitionViewController.h"

@interface MKUSearchResultsTransitionViewController ()

@end

@implementation MKUSearchResultsTransitionViewController

- (BOOL)hasButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return NO;
}

- (void)searchDidSelectObject:(NSObject<MKUSearchProtocol> *)object atIndex:(NSInteger)index {
    [self dispathTransitionDelegateToReturnWithObject:object];
}

@end

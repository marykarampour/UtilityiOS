//
//  MKGenericCell.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-11.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKGenericCell.h"

@implementation MKGenericCell

@end
//Only if we had multiple inheritance in Objective-C ...


@interface MKHorizontalTableViewCell ()

@property (nonatomic, strong, readwrite) __kindof MKHorizontalCollectionViewController *controller;

@end

@implementation MKHorizontalTableViewCell

@synthesize controller;

- (void)setAttributes:(MKCollectionViewAttributes *)attributes {
    self.controller = [[attributes.controllerClass alloc] initWithAttributes:attributes];
}

@end


@interface MKHorizontalCollectionViewCell ()

@property (nonatomic, strong, readwrite) __kindof MKHorizontalCollectionViewController *controller;

@end

@implementation MKHorizontalCollectionViewCell

@synthesize controller;

- (void)setAttributes:(MKCollectionViewAttributes *)attributes {
    self.controller = [[attributes.controllerClass alloc] initWithAttributes:attributes];
}

@end

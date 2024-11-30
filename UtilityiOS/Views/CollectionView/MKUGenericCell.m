//
//  MKUGenericCell.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-11.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUGenericCell.h"

@implementation MKUGenericCell

@end
//Only if we had multiple inheritance in Objective-C ...


@interface MKUHorizontalTableViewCell ()

@property (nonatomic, strong, readwrite) __kindof MKUHorizontalCollectionViewController *controller;

@end

@implementation MKUHorizontalTableViewCell

@synthesize controller;

- (void)setAttributes:(MKUCollectionViewAttributes *)attributes {
    self.controller = [[attributes.controllerClass alloc] initWithAttributes:attributes];
}

@end


@interface MKUHorizontalCollectionViewCell ()

@property (nonatomic, strong, readwrite) __kindof MKUHorizontalCollectionViewController *controller;

@end

@implementation MKUHorizontalCollectionViewCell

@synthesize controller;

- (void)setAttributes:(MKUCollectionViewAttributes *)attributes {
    self.controller = [[attributes.controllerClass alloc] initWithAttributes:attributes];
}

@end


@interface MKUHorizontalContentView ()

@property (nonatomic, strong, readwrite) __kindof MKUHorizontalCollectionViewController *controller;

@end

@implementation MKUHorizontalContentView

@synthesize controller;

+ (CGFloat)estimatedHeight {
    return 80.0;
}

- (void)setAttributes:(MKUCollectionViewAttributes *)attributes {
    self.controller = [[attributes.controllerClass alloc] initWithAttributes:attributes];
}

@end

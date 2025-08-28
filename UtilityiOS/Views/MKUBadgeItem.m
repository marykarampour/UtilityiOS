//
//  MKUBadgeItem.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUBadgeItem.h"

static NSArray<MKUOption *> *typeOptions;

@interface MKUBadgeItem ()

@property (nonatomic, assign, readwrite) NSUInteger type;

@end

@implementation MKUBadgeItem

+ (void)setGlobalBadgeOptions:(NSArray<MKUOption *> *)options {
    typeOptions = options;
}

+ (instancetype)badgeWithName:(NSString *)name {
    MKUBadgeItem *obj = [[MKUBadgeItem alloc] init];
    obj.name = name;
    return obj;
}

- (NSString *)description {
    if ([self.count integerValue] > 0)
        return [self.count stringValue];
    else if ([self.count integerValue] < 0)
        return @"!";
    return nil;
}

+ (NSSet<NSString *> *)excludedKeys {
    return [NSSet setWithObject:NSStringFromSelector(@selector(type))];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.type = [MKUOption optionForNameOrTitle:name options:typeOptions].value;
}

- (BOOL)hasValue {
    return 0 < self.description.length;
}

+ (NSArray<MKUOption *> *)typeOptions {
    return typeOptions;
}

+ (instancetype)badgeWithName:(NSString *)name inBadges:(NSArray<MKUBadgeItem *> *)badges {
    for (MKUBadgeItem *obj in badges) {
        if ([obj.name isEqualToString:name])
            return obj;
    }
    return nil;
}

@end

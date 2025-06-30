//
//  MKUButtonLabelView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-17.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUButtonLabelView.h"
#import "UIView+Utility.h"
#import "UIControl+IndexPath.h"

@implementation MKUBackButton

- (instancetype)init {
    if (self = [super init]) {
        self.button = [[UIButton alloc] init];
    }
    return self;
}

@end

@interface MKUButtonLabelView ()

@property (nonatomic, strong) MKUBackButton *backButton;
@property (nonatomic, strong, readwrite) UIButton *backView;

@end

@implementation MKUButtonLabelView

@dynamic backView;

- (instancetype)init {
    if (self = [super init]) {
        self.backButton = [[MKUBackButton alloc] init];
        self.backButton.container = self;
        [self addBackView:self.backButton.button];
        [self setActionOnContainer:@selector(switchOnOff:)];
    }
    return self;
}

- (void)setTarget:(id)target action:(SEL)action {
    [self.backButton.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setActionOnContainer:(SEL)action {
    [self setTarget:self.backButton.container action:action];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.backButton.button.indexPath = indexPath;
}

- (void)switchOnOff:(UIButton *)sender {
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self customizeSetSelected:selected];
}

- (void)customizeSetSelected:(BOOL)selected {
    if ([self.delegate respondsToSelector:@selector(buttonView:setSelected:)]) {
        [self.delegate buttonView:self setSelected:selected];
    }
}

@end

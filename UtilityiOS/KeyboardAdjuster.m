//
//  KeyboardAdjuster.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-29.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "KeyboardAdjuster.h"

@interface KeyboardAdjuster ()

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) CGRect referenceFrame;
@property (nonatomic, assign) CGFloat inset;

@end

@implementation KeyboardAdjuster

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewController = viewController;
    }
    return self;
}

- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setReferenceFrame:(CGRect)frame {
    _referenceFrame = frame;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGFloat kbOriginY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat inset = self.referenceFrame.origin.y + 2*self.referenceFrame.size.height - kbOriginY;
    
    if (inset > 0.0) {
        self.inset += inset;
        [self updateTableViewInset:inset];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.inset > 0.0) {
        [self updateTableViewInset:-self.inset];
        self.inset = 0.0;
    }
}

- (void)updateTableViewInset:(CGFloat)inset {
    
    CGRect frame = self.viewController.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [self.viewController.view setFrame:CGRectMake(frame.origin.x, frame.origin.y-inset, frame.size.width, frame.size.height)];
    [UIView commitAnimations];
}

@end

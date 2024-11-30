//
//  UITextField+NextControl.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-29.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (NextControl)

@property (nonatomic, strong) UITextField *nextControl;

- (BOOL)transferFirstResponderToNextControl;

@end

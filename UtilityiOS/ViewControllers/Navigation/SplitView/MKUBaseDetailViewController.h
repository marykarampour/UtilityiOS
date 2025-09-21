//
//  BaseDetailViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSObject+SplitView.h"

@interface MKUBaseDetailViewController : MKUDetailViewController

- (instancetype)initWithImage:(NSString *)image;
- (void)setBackgroundHidden:(BOOL)hidden;

@end

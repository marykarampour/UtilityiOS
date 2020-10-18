//
//  MKHeaderChildViewController.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKTableViewController.h"
#import "MKHeaderFooterContainerViewController.h"

@interface MKHeaderChildTableViewController : MKTableViewController<HeaderVCChildViewDelegate>

@property (nonatomic, weak) MKHeaderFooterContainerViewController<HeaderVCParentViewDelegate> *headerDelegate;
@property (nonatomic, strong) id object;

@end


@interface MKHeaderChildViewController : UIViewController<HeaderVCChildViewDelegate>

@property (nonatomic, weak) MKHeaderFooterContainerViewController<HeaderVCParentViewDelegate> *headerDelegate;
@property (nonatomic, strong) id object;

@end

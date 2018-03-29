//
//  MKDrawingView.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKBezierPath : NSObject

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat lineWidth;

@end

@interface MKDrawingView : UIView

- (UIImage *)image;

@end

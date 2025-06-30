//
//  MKUDrawingView.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKUDrawingViewProtocol <NSObject>

@optional
- (void)touchesEndedWithImage:(UIImage *)image;

@end

@interface MKUBezierPath : NSObject

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat lineWidth;

@end

@interface MKUDrawingView : UIView

@property (nonatomic, weak) id<MKUDrawingViewProtocol> delegate;

- (UIImage *)image;
- (void)clearView;

@end

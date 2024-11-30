//
//  MKUMath.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-12.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface MKUMath : NSObject

/** @brief this polygon's starting point is at pi/2
 @param size the diameter of the enclosing circle 
 */
+ (ValueArr *)verticesForPolygon:(NSUInteger)vertexCount ofSize:(CGFloat)size;
+ (CGPoint)midPointOfPoint:(CGPoint)first andPoint:(CGPoint)second;

@end

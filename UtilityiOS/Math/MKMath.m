//
//  MKMath.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-12.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKMath.h"

@implementation MKMath

+ (ValueArr *)verticesForPolygon:(NSUInteger)vertexCount ofSize:(CGFloat)size {
    MValueArr *vertices = [[NSMutableArray alloc] init];
    //beta is inital abgle, theta is incrementing angle
    CGFloat beta = M_PI/2;
    CGFloat theta = 2*M_PI/vertexCount;
    CGFloat radius = size/2.0;
    
    for (unsigned int i=0; i<vertexCount; i++) {
        CGFloat alpha = beta+theta*i;
        CGFloat xx = cos(alpha)*radius;
        CGFloat yy = sin(alpha)*radius;
        [vertices addObject:[NSValue valueWithCGPoint:CGPointMake(xx+radius, radius-yy)]];
    }
    return vertices;
}

@end

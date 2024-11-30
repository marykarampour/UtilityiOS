//
//  NSAttributedString+Utility.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIColor+Utility.h"

@interface NSAttributedString (Utility)

- (NSArray <MKUColorComponents *> *)colorComponentsInRange:(NSRange)range;

- (NSArray<NSNumber *> *)widthsOfGlyphs;
- (CGFloat)lineHeight;

@end

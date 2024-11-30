//
//  NSAttributedString+Utility.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "NSAttributedString+Utility.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (Utility)

- (NSArray<MKUColorComponents *> *)colorComponentsInRange:(NSRange)range {
    
    NSMutableArray<MKUColorComponents *> *arr = [[NSMutableArray alloc] init];
    
    [self enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if ([attrs.allKeys containsObject:NSForegroundColorAttributeName]) {
            UIColor *color = [attrs objectForKey:NSForegroundColorAttributeName];
            MKUColorComponents *comps = [color colorComponents];
            if (comps) [arr addObject:comps];
        }
    }];
    
    return arr;
}

- (NSArray<NSNumber *> *)widthsOfGlyphs {
    
    NSMutableArray<NSNumber *> *widths = [[NSMutableArray alloc] init];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self);
    CFArrayRef runArr = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArr);
    CFIndex glyphOffsetX = 0.0;
    
    for (CFIndex i=0; i<runCount; i++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArr, i);
        CFIndex runGlyphCount = CTRunGetGlyphCount((CTRunRef)run);
        
        for (CFIndex runIndex=0; runIndex<runGlyphCount; runIndex++) {
            NSNumber *width = @(CTRunGetTypographicBounds((CTRunRef)run, CFRangeMake(runIndex, 1), NULL, NULL, NULL));
            [widths insertObject:width atIndex:runIndex + glyphOffsetX];
        }
        glyphOffsetX = runCount + 1;
    }
    CFRelease(line);
    return widths;
}

- (CGFloat)lineHeight {
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self);
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat lineHeight = ascent + descent + leading;
    CFRelease(line);
    return lineHeight;
}

@end


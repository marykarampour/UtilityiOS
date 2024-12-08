//
//  MKUTableViewCellContentProtocols.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKUTitleSubTitleProtocol <NSCopying>

@optional
- (NSString *)title;
- (NSString *)subtitle;
- (NSAttributedString *)attributedTitle;
- (NSAttributedString *)attributedSubtitle;

@end

@protocol MKUPlaceholderProtocol <MKUTitleSubTitleProtocol>

@optional
/** @brief The title of the view, section, etc. containing a list of objects of this type */
+ (NSString *)titleForContainingList;
+ (NSString *)addItemTitle;

@end

@protocol MKUSearchProtocol <MKUPlaceholderProtocol>

@optional
+ (NSString *)searchPredicateKey;
/** @brief Used in constructing OR predicate in search.
 If this has count greater than 0, searchPredicateKey will be ignored. */
+ (StringArr *)searchPredicateKeys;
- (BOOL)hasDetail;
- (NSUInteger)numberOfLines;

@end

@protocol MKUCellStyleProtocol <NSObject>

@optional
+ (UIFont *)cellTitleFont;
+ (UIColor *)cellTitleColor;
+ (UIFont *)cellSubtitleFont;
+ (UIColor *)cellSubtitleColor;

@end

@protocol MKURefreshViewControllerDelegate <NSObject>

@optional
- (void)performRefreshWithControl:(UIRefreshControl *)sender;//TODO: Add to subclasses

@end

@protocol MKUViewContentStyleProtocols <NSObject>

@end


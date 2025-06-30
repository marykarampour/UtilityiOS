//
//  MKUCollapsableSectionsViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-07.
//

#import "MKUCollapsableSectionsViewController.h"
#import "NSArray+Utility.h"
#import "UIImage+Editing.h"

@interface MKUCollapsableSectionsViewController ()

@end

@implementation MKUCollapsableSectionsViewController

- (void)initBase {
    [super initBase];
    
    self.sectionHeaderTheme = MKU_THEME_STYLE_DARK;
    self.sectionObjects = [[NSMutableArray alloc] init];
}

- (UIImage *)expandedImageInSection:(NSInteger)section {
    return [MKUAssets systemIconWithName:[MKUAssets Chevron_Down_Image_Name] size:[Constants ButtonChevronSize]];
}

- (UIImage *)collapsedImageInSection:(NSInteger)section {
    return [MKUAssets systemIconWithName:[MKUAssets Chevron_Right_Image_Name] size:[Constants ButtonChevronSize]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionObjects.count;
}

- (NSUInteger)numberOfRowsInNonDateSection:(NSUInteger)section {
    return self.sectionObjects[section].expanded ? [self numberOfRowsInNonDateSectionWhenExpanded:section] : 0;
}

- (NSUInteger)numberOfRowsInNonDateSectionWhenExpanded:(NSUInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    if (title.length == 0) return 0.0;
    
    MKUSectionObject *obj = [self.sectionObjects nullableObjectAtIndex:section];
    if (!obj) return 0.0;
    if (!obj.isCollapsable)
        return [self heightForNoneCollapsableHeaderInSection:section];
    if ([self numberOfRowsInNonDateSectionWhenExpanded:section] == 0) return 0.0;
    return [self heightForCollapsableHeaderInSection:section];
}

- (CGFloat)heightForCollapsableHeaderInSection:(NSInteger)section {
    return [MKUButtonHeaderView estimatedHeight];
}

- (CGFloat)heightForNoneCollapsableHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    if (title.length == 0) return nil;
    
    MKUSectionObject *obj = [self.sectionObjects nullableObjectAtIndex:section];
    if (!obj) return nil;
    if (!obj.isCollapsable)
        return [self viewForNonCollapsableHeaderInSection:section];
    return [self defaultHeaderViewInSection:section];
}

- (UIView *)viewForNonCollapsableHeaderInSection:(NSInteger)section {
    return nil;
}

- (MKUButtonHeaderView *)defaultHeaderViewInSection:(NSInteger)section {
    NSString *title = [self tableView:self.tableView titleForHeaderInSection:section];
    if (title.length == 0) return nil;
    
    MKUSectionObject *obj = [self.sectionObjects nullableObjectAtIndex:section];
    if (!obj) return nil;
    
    MKUButtonHeaderView *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[MKUButtonHeaderView identifier]];
    
    if (!header) {
        header = [[MKUButtonHeaderView alloc] initWithAccessoryImageSize:[Constants ButtonChevronSize]];
        header.contentView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, [MKUButtonHeaderView estimatedHeight]);
        
        header.view.titleView.font = [AppTheme largeBoldLabelFont];
        header.view.titleView.textColor = self.sectionHeaderTheme == MKU_THEME_STYLE_DARK ? [AppTheme mistBlueColorWithAlpha:1.0] : [AppTheme nightBlueColorWithAlpha:1.0];
        header.view.badgeView.tintColor = self.sectionHeaderTheme == MKU_THEME_STYLE_DARK ? [AppTheme mistBlueColorWithAlpha:1.0] : [AppTheme nightBlueColorWithAlpha:1.0];
        header.view.backgroundColor = self.sectionHeaderTheme == MKU_THEME_STYLE_DARK ? [AppTheme nightBlueColorWithAlpha:1.0] : [AppTheme defaultSectionHeaderColor];
        [header.view setSeparatorColor:self.sectionHeaderTheme == MKU_THEME_STYLE_DARK ? [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4] : [UIColor whiteColor]];
        [header.view addTarget:self action:@selector(headerPressed:)];
    }
    
    [header.view setIndexPath:[NSIndexPath indexPathWithIndex:section]];
    [header.view setLabelTitle:title];
    [header.view setImage:[obj.expanded ? [self expandedImageInSection:section] : [self collapsedImageInSection:section] templateImage]];
    
    return header;
}

- (void)didSelectNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = nil;
}

#pragma mark - data

- (void)setSectionObjects:(NSMutableArray<MKUSectionObject *> *)sectionObjects {
    _sectionObjects = [self expandOnlySectionInSectionObjects:sectionObjects];
    [self reloadDataAnimated:NO];
}

#pragma mark - utility

- (NSMutableArray<MKUSectionObject *> *)expandOnlySectionInSectionObjects:(NSMutableArray<MKUSectionObject *> *)sectionObjects {
    NSMutableArray <MKUSectionObject *> *sectionsWithRows = [[NSMutableArray alloc] init];
    [sectionObjects enumerateObjectsUsingBlock:^(MKUSectionObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 < [self numberOfRowsInNonDateSectionWhenExpanded:idx]) {
            [sectionsWithRows addObject:obj];
        }
    }];
    
    if (sectionsWithRows.count == 1) {
        sectionsWithRows.firstObject.expanded = YES;
    }
    return sectionObjects;
}

- (void)headerPressed:(UIButton *)sender {
    NSIndexPath *indexPath = sender.indexPath;
    MKUSectionObject *object = [self.sectionObjects nullableObjectAtIndex:indexPath.section];
    if (!object.isCollapsable) return;
    
    if (self.canExpandMultipleSections) {
        object.expanded = !object.expanded;
        [self reloadSection:indexPath.section withHeader:YES];
    }
    else {
        [self.sectionObjects enumerateObjectsUsingBlock:^(MKUSectionObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == indexPath.section)
                obj.expanded = !obj.expanded;
            else
                obj.expanded = NO;
        }];
        [self reloadDataAnimated:NO];
    }
}

- (void)reloadSectionKeepSelection:(NSUInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    });
}

- (void)reloadRowsKeepSelection:(NSArray *)indexPaths {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    });
}

@end

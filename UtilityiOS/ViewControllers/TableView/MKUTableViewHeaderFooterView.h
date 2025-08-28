//
//  MKUTableViewHeaderFooterView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUViewProtocol.h"

typedef NS_ENUM(NSUInteger, MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE) {
    MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_HEADER,
    MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_FOOTER
};

@interface MKUTableViewHeaderFooterView : UITableViewHeaderFooterView <MKUViewProtocol>

@end


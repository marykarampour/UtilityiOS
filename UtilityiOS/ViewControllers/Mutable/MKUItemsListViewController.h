//
//  MKUItemsListViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUEditingListsViewController.h"

/** @brief A list of items of the same object type.
 By default has navbar buttons of types MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE, MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_ADD,
 MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_REFRESH, MKU_NAV_BAR_BUTTON_TYPE_CLEAR, MKU_NAV_BAR_BUTTON_TYPE_CLOSE.
 initSelectedActionHandler sets selectedActionHandler to MKU_LIST_ITEM_SELECTED_ACTION_SELECT. */
@interface MKUItemsListViewController <__covariant ObjectType : NSObject<MKUPlaceholderProtocol> *> : MKUEditingListViewController <ObjectType>

@end


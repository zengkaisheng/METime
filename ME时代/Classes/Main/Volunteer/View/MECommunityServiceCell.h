//
//  MECommunityServiceCell.h
//  ME时代
//
//  Created by gao lei on 2019/10/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MECommunityServericeListModel;

#define kMECommunityServiceCellHeight 95

@interface MECommunityServiceCell : UITableViewCell

- (void)setUIWithModel:(MECommunityServericeListModel *)model;

@end

NS_ASSUME_NONNULL_END

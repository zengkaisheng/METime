//
//  MEOperationTotalListCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEOperationTotalListModel;
#define kMEOperationTotalListCellHeight 89

NS_ASSUME_NONNULL_BEGIN

@interface MEOperationTotalListCell : UITableViewCell

- (void)setUIWithTotalModel:(MEOperationTotalListModel *)model;


@end

NS_ASSUME_NONNULL_END

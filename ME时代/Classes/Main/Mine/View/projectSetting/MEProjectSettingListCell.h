//
//  MEProjectSettingListCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEProjectSettingListModel;
NS_ASSUME_NONNULL_BEGIN

@interface MEProjectSettingListCell : UITableViewCell

@property (nonatomic, copy) kMeIndexBlock indexBlock;

- (void)setUIWithModel:(MEProjectSettingListModel *)model;

@end

NS_ASSUME_NONNULL_END

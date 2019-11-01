//
//  MEServiceCardCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MEServiceDetailSubModel;
@class MEExpenseDetailSubModel;
NS_ASSUME_NONNULL_BEGIN

#define kMEServiceCardCellHeight 113

@interface MEServiceCardCell : UITableViewCell
//服务
- (void)setUIWithServiceModel:(MEServiceDetailSubModel *)model index:(NSInteger)index;
//消费
- (void)setUIWithExpenseModel:(MEExpenseDetailSubModel *)model;

@end

NS_ASSUME_NONNULL_END

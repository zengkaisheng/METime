//
//  MECustomerServiceContentCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MECustomerServiceContentCell : UITableViewCell

//0.查看详情 1.添加服务
@property (nonatomic, copy) kMeIndexBlock indexBlock;
- (void)setUIWithInfo:(NSDictionary *)info;
+ (CGFloat)getCellHeightWithInfo:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END

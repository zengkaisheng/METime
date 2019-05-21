//
//  MEStoreHomeIntroduceCell.h
//  ME时代
//
//  Created by hank on 2018/10/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEStoreDetailModel;
const static CGFloat kMEStoreHomeIntroduceCellHeight = 120;

@interface MEStoreHomeIntroduceCell : UITableViewCell

- (void)setUIWithModel:(MEStoreDetailModel *)model isExpand:(BOOL)isExpand ExpandBlock:(kMeBOOLBlock)expandBlock;
+ (CGFloat)getCellHeightWithModel:(MEStoreDetailModel *)model isExpand:(BOOL)isExpand;
@end

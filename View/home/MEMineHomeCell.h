//
//  MEMineHomeCell.h
//  志愿星
//
//  Created by Hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMineHomeCellHeight = 49;



@interface MEMineHomeCell : UITableViewCell

- (void)setUiWithType:(MEMineHomeMenuCellStyle)type;
- (void)setUnMeaasge;
@end

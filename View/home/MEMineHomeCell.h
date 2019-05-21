//
//  MEMineHomeCell.h
//  ME时代
//
//  Created by Hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEMineHomeCellHeight = 49;



@interface MEMineHomeCell : UITableViewCell

- (void)setUiWithType:(MEMineHomeCellStyle)type;
- (void)setUnMeaasge;
@end

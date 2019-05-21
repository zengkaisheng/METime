//
//  MEMemberHomeProductCell.h
//  ME时代
//
//  Created by hank on 2018/10/16.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MESuperMemberHomeModel;
@interface MEMemberHomeProductCell : UITableViewCell

+ (CGFloat)getCellHeightWithModel:(MESuperMemberHomeModel *)model;
- (void)setUiWithModel:(MESuperMemberHomeModel *)model;

@end

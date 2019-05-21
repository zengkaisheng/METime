//
//  MEGetCaseMainCell.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGetCaseMainModel;
const static CGFloat kMEGetCaseMainCellHeight = 205;

@interface MEGetCaseMainCell : UITableViewCell

- (void)setUIWithModel:(MEGetCaseMainModel *)model;
+(CGFloat)getCellHeightWithModel:(MEGetCaseMainModel *)model;
@end

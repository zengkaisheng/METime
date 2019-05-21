//
//  MEGetCaseContentCell.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGetCaseContentModel;
const static CGFloat kMEGetCaseContentCellHeight = 110;

@interface MEGetCaseContentCell : UITableViewCell

- (void)setUIWIthModel:(MEGetCaseContentModel *)model;
+ (CGFloat)getCellHeightWithModel:(MEGetCaseContentModel *)model;


- (void)setUIDataDealWIthModel:(MEGetCaseContentModel *)model;

@end

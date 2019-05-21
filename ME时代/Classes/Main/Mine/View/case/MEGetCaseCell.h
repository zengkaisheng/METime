//
//  MEGetCaseCell.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGetCaseModel;
@interface MEGetCaseCell : UITableViewCell

+ (CGFloat)getCellHeightWithModel:(MEGetCaseModel *)model;
+ (CGFloat)getCellDataDealHeightWithModel:(MEGetCaseModel *)model;
- (void)setUIDataDealWIthModel:(MEGetCaseModel *)model;
- (void)setUIWithModel:(MEGetCaseModel *)model;

@end

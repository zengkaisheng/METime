//
//  MEVistorPathMainCell.h
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEVistorUserModel;
const static CGFloat kMEVistorPathMainCellHeight = 150;

@interface MEVistorPathMainCell : UITableViewCell

- (void)setUiWIthModle:(MEVistorUserModel *)model;

@end

//
//  MEVisterDetailCell.h
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MESpreadUserModel;
@class MEVistorUserModel;
const static CGFloat kMEVisterDetailCellHeight = 436;

@interface MEVisterDetailCell : UITableViewCell

- (void)setUIWithModle:(MEVistorUserModel *)model dicUser:(MESpreadUserModel *)dicUser;

@end

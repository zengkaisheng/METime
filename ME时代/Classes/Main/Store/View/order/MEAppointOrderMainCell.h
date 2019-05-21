//
//  MEAppointOrderMainCell.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEServiceDetailsModel;
@class MEAppointAttrModel;

//const static CGFloat kMEAppointOrderMainCellHeight = 360;
const static CGFloat kMEAppointOrderMainCellHeight = 287;//265;
@interface MEAppointOrderMainCell : UITableViewCell

- (void)setUIWithModel:(MEServiceDetailsModel *)model attrModel:(MEAppointAttrModel *)attrModel;

@end

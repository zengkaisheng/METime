//
//  MENoticeCell.h
//  ME时代
//
//  Created by hank on 2018/11/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MENoticeModel;
const static CGFloat kMENoticeCellHeight = 72;

@interface MENoticeCell : UITableViewCell

- (void)setUIWIthModel:(MENoticeModel *)model;

@end

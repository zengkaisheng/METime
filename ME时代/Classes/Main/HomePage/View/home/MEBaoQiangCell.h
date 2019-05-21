//
//  MEBaoQiangCell.h
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEBaoQiangCellHeoght  = 286;
const static CGFloat kMEBaoQiangCellTitleHeight  = 34;

@interface MEBaoQiangCell : UITableViewCell

- (void)setUIWithArr:(NSArray *)arrModel;
@property (nonatomic, copy) kMeIndexBlock indexBlock;

+ (CGFloat)getCellHeightWithArr:(NSArray *)arr;

@end

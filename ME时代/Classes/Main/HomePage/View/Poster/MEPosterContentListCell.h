//
//  MEPosterContentListCell.h
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEPosterModel;
const static CGFloat kMEPosterContentListCellHeight  = 285;
@interface MEPosterContentListCell : UITableViewCell

- (void)setUIWithModel:(MEPosterModel *)model;
@property (nonatomic, copy) kMeBasicBlock moreBlock;
+ (CGFloat)getCellWithModel:(MEPosterModel *)model;

@end

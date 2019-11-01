//
//  MEDiagnoseOrderListCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEDiagnoseOrderListModel;

#define kMEDiagnoseOrderListCellHeight 245

@interface MEDiagnoseOrderListCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock tapBlock;

- (void)setUIWithModel:(MEDiagnoseOrderListModel *)model;

+ (CGFloat)getCellHeightWithModel:(MEDiagnoseOrderListModel *)model;

@end

NS_ASSUME_NONNULL_END

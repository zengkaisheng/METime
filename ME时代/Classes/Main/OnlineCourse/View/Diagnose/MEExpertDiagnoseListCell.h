//
//  MEExpertDiagnoseListCell.h
//  志愿星
//
//  Created by gao lei on 2019/8/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEDiagnoseProductModel;

#define kMEExpertDiagnoseListCellHeight 112

@interface MEExpertDiagnoseListCell : UITableViewCell

- (void)setUIWithModel:(MEDiagnoseProductModel *)model;

+ (CGFloat)getCellHeightWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END

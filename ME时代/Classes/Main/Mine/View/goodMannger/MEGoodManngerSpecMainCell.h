//
//  MEGoodManngerSpecMainCell.h
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEGoodManngerAddSpecModel;
@class MEGoodManngerSpecBasicCell;
typedef void (^kMeSpecBasicCellBlock)(MEGoodManngerSpecBasicCell *cell);

@interface MEGoodManngerSpecMainCell : UITableViewCell

+ (CGFloat)getCellHeightWithModel:(MEGoodManngerAddSpecModel*)model;
- (void)setUiWihtModel:(MEGoodManngerAddSpecModel*)model;
@property (nonatomic, copy) kMeBasicBlock delBlock;
@property (nonatomic, copy) kMeSpecBasicCellBlock tapImgBlock;

@end

NS_ASSUME_NONNULL_END

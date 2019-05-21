//
//  MESkuBuyCell.h
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodDetailModel;
@interface MESkuBuyCell : UITableViewCell

+ (CGFloat)getCellHeigthWithModel:(id)goodModel;
+ (CGFloat)getCellHeigthWithdetailModel:(MEGoodDetailModel *)goodModel;
- (void)setUIWithModel:(MEGoodDetailModel *)goodModel isInteral:(BOOL)isInteral slectBlock:(kMeBasicBlock)slectBlock;

/**
 加
 */
@property (nonatomic, copy) kMeLblBlock AddBlock;

/**
 减
 */
@property (nonatomic, copy) kMeLblBlock CutBlock;

@property (nonatomic, copy) kMeBasicBlock confirmBlock;

@end

//
//  MEMyDistributionReusableView.h
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEDistributionCentreModel;
@class MEadminDistributionModel;
const static CGFloat kMEMyDistributionHeaderViewHeight = 290.0;

@interface MEMyDistributionReusableView : UICollectionReusableView

//C端
- (void)setUIWithModel:(MEDistributionCentreModel *)model;
//B端
- (void)setUIBWithModel:(MEadminDistributionModel *)model;
//提现
@property (nonatomic, copy) kMeBasicBlock costBlock;
@end

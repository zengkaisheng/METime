//
//  MEFourHomeTopHeaderView.h
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEFourHomeTopHeaderViewHeight = 142;

@class MEHomeRecommendAndSpreebuyModel;
@class METhridHomeStudyTogetherModel;

@interface MEFourHomeTopHeaderView : UICollectionReusableView

@property (nonatomic,copy)kMeBasicBlock leftBlock;
@property (nonatomic,copy)kMeBasicBlock rightBlock;
- (void)setUiWithModel:(MEHomeRecommendAndSpreebuyModel *)model;

- (void)setUIWithCourseModel:(METhridHomeStudyTogetherModel *)model;

@end

NS_ASSUME_NONNULL_END

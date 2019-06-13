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

@interface MEFourHomeTopHeaderView : UICollectionReusableView

- (void)setUiWithModel:(MEHomeRecommendAndSpreebuyModel *)model;

@end

NS_ASSUME_NONNULL_END

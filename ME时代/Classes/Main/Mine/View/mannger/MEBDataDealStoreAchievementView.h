//
//  MEBDataDealStoreAchievementView.h
//  ME时代
//
//  Created by hank on 2019/2/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBDataDealModel;
@interface MEBDataDealStoreAchievementView : UIView

+(CGFloat)getViewHeightWithModel:(MEBDataDealModel *)model;
- (void)setUIWithModel:(MEBDataDealModel *)model;

@end

NS_ASSUME_NONNULL_END

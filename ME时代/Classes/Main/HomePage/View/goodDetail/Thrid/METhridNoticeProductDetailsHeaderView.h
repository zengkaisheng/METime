//
//  METhridNoticeProductDetailsHeaderView.h
//  ME时代
//
//  Created by hank on 2019/1/24.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEGoodDetailModel;
@interface METhridNoticeProductDetailsHeaderView : UIView

- (void)setNormalUIWithModel:(MEGoodDetailModel *)model;
- (void)setUINoticeWithModel:(MEGoodDetailModel *)model;
+ (CGFloat)getNormalHeightWithModel:(MEGoodDetailModel *)model;
+ (CGFloat)getNoticeHeightWithModel:(MEGoodDetailModel *)model;
-(void)downSecondHandle:(NSString *)aTimeString;

@end

NS_ASSUME_NONNULL_END

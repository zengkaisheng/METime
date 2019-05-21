//
//  METhridProductDetailsHeaderView.h
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEGoodDetailModel;
@interface METhridProductDetailsHeaderView : UIView

- (void)setUIWithModel:(MEGoodDetailModel *)model;
+ (CGFloat)getHeightWithModel:(MEGoodDetailModel *)model;
-(void)downSecondHandle:(NSString *)aTimeString;

@end

NS_ASSUME_NONNULL_END

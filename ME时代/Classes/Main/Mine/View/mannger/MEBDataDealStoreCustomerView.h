//
//  MEBDataDealStoreCustomerView.h
//  ME时代
//
//  Created by hank on 2019/2/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBDataDealModel;
@interface MEBDataDealStoreCustomerView : UIView

- (void)setUIWithModel:(MEBDataDealModel *)model;
+(CGFloat)getViewHeightWithModel:(MEBDataDealModel *)model;

@end

NS_ASSUME_NONNULL_END

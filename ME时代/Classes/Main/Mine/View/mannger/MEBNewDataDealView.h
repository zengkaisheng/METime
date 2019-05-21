//
//  MEBNewDataDealView.h
//  ME时代
//
//  Created by hank on 2019/2/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBDataDealModel;
const static CGFloat kMEBNewDataDealViewHeight = 1197;

@interface MEBNewDataDealView : UIView

- (void)setUIWithModel:(MEBDataDealModel *)Model;

@property (nonatomic, copy) kMeBasicBlock StructBlock;
@property (nonatomic, copy) kMeBasicBlock storeCustomer;

@end

NS_ASSUME_NONNULL_END

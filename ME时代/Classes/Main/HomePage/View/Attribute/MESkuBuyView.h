//
//  MESkuBuyView.h
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEGoodDetailModel;
@interface MESkuBuyView : UIView

//isInteral yes 是积分兑换 NO 普通商品 
- (instancetype)initPurchaseViewWithFrame:(CGRect)frame serviceModel:(MEGoodDetailModel *)goodModel WithSuperView:(UIView *)superView isInteral:(BOOL)isInteral;
- (void)setSubView;
- (void)show;
- (void)hide:(kMeBasicBlock)finishBlock;
- (void)hide;
@property (nonatomic, copy) kMeBasicBlock confirmBlock;

//获取库存失败
@property (nonatomic, copy) kMeBasicBlock failGetStoreBlock;
//获取库成功
@property (nonatomic, copy) kMeBasicBlock sucessGetStoreBlock;

@end

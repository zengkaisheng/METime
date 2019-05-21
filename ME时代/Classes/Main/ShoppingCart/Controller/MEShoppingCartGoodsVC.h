//
//  MEShoppingCartGoodsVC.h
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MEGoodsModel;
@class MEShopppingCartBottomView;
@interface MEShoppingCartGoodsVC : MEBaseVC

//@property (nonatomic, strong) NSMutableArray<MEGoodsModel *> *arrStore;//商品
/**
 选中的数组
 */
@property (nonatomic, strong) NSMutableArray *arrSelect;
- (void)reloadData;
@property (nonatomic, copy) kMeBasicBlock countPriceBlock;
@property (nonatomic, copy) kMeBasicBlock judgeIsAllSelectBlock;

@end

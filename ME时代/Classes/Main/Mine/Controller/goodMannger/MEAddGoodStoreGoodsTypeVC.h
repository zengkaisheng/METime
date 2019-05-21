//
//  MEAddGoodStoreGoodsTypeVC.h
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MEAddGoodStoreGoodsType;
typedef void (^kMeAddGoodStoreGoodsTypeBlock)(MEAddGoodStoreGoodsType *model);

@interface MEAddGoodStoreGoodsTypeVC : MEBaseVC

@property (nonatomic, copy) kMeAddGoodStoreGoodsTypeBlock blcok;

@end

NS_ASSUME_NONNULL_END

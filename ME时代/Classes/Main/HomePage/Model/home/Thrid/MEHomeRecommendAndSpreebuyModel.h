//
//  MEHomeRecommendAndSpreebuyModel.h
//  ME时代
//
//  Created by hank on 2019/4/30.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MEGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEHomeRecommendAndSpreebuyModel : MEBaseModel

@property (nonatomic, strong) MEGoodModel * recommend_goods;
@property (nonatomic, strong) MEGoodModel * spreebuy_goods;


@end

NS_ASSUME_NONNULL_END

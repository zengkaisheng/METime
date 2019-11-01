//
//  MEHomeRecommendAndSpreebuyModel.h
//  志愿星
//
//  Created by hank on 2019/4/30.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MEGoodModel.h"
#import "MEAdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MEHomeRecommendAndSpreebuyModel : MEBaseModel

@property (nonatomic, strong) MEGoodModel * recommend_goods;
@property (nonatomic, strong) MEGoodModel * spreebuy_goods;

//新3.4.3
@property (nonatomic, strong) MEAdModel * recommend_left;
@property (nonatomic, strong) MEAdModel * recommend_right;



@end

NS_ASSUME_NONNULL_END

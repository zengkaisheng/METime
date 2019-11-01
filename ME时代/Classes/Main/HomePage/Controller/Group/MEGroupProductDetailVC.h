//
//  MEGroupProductDetailVC.h
//  志愿星
//
//  Created by gao lei on 2019/7/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEGroupProductDetailVC : MEBaseVC

- (instancetype)initWithProductId:(NSInteger)productId;
//来自好友分享
@property(nonatomic, copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END

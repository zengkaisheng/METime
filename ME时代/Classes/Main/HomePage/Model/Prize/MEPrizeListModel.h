//
//  MEPrizeListModel.h
//  志愿星
//
//  Created by gao lei on 2019/6/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEPrizeListModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *open_time;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END

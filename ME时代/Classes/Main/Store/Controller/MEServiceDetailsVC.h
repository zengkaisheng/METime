//
//  MEServiceDetailsVC.h
//  志愿星
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MEStoreDetailModel;
@interface MEServiceDetailsVC : MEBaseVC

- (instancetype)initWithId:(NSInteger)detailsId storeDetailModel:(MEStoreDetailModel *)storeDetailModel;
- (instancetype)initWithId:(NSInteger)detailsId;

@end

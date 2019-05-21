//
//  MEServiceDetailsModel.h
//  ME时代
//
//  Created by hank on 2018/10/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MEGoodDetailModel.h"

@interface MEServiceDetailsModel : MEBaseModel

@property (nonatomic, copy) MEGoodDetailModel *serviceDetail;
@property (nonatomic, copy) NSArray *recommendService;

@end

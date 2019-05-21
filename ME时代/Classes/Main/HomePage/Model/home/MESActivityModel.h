//
//  MESActivityModel.h
//  ME时代
//
//  Created by hank on 2018/12/3.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MESActivityContentModel.h"

@interface MESActivityModel : MEBaseModel

@property (nonatomic, strong) MESActivityContentModel *background;
@property (nonatomic, strong) NSArray *banner;

@end

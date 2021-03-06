//
//  MEPayStatusVC.h
//  志愿星
//
//  Created by hank on 2018/9/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEPayStatusVC : MEBaseVC

- (instancetype)initWithSucessConfireBlock:(kMeBasicBlock)block;
- (instancetype)initWithFailRePayBlock:(kMeBasicBlock)rePayBlock CheckOrderBlock:(kMeBasicBlock)checkOrderBlock;

@property (nonatomic, strong) NSString *order_sn;

@end

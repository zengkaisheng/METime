//
//  MEAppointmentSelectStoreVC.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEAppointmentSelectStoreVC : MEBaseVC

@property (nonatomic, copy) kMeObjBlock stroeBlock;

- (instancetype)initWithStoreId:(NSInteger)storId;

@end

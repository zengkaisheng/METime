//
//  MEAppointmentCustomerListVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseBlock)(NSString *str, NSInteger ids);

@interface MEAppointmentCustomerListVC : MEBaseVC

@property (nonatomic ,copy) ChooseBlock chooseBlock;
@property (nonatomic, assign) BOOL isFileList;

@end

NS_ASSUME_NONNULL_END

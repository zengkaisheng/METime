//
//  MEAddAppointmentVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddAppointmentVC : MEBaseVC

@property (nonatomic, copy) kMeBasicBlock finishBlock;
@property (nonatomic, assign) BOOL isAddProject;

- (instancetype)initWithAppointmentId:(NSInteger)appointmentId;

@end

NS_ASSUME_NONNULL_END

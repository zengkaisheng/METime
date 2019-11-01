//
//  MEDiagnoseFeedBackBaseVC.h
//  志愿星
//
//  Created by gao lei on 2019/8/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEDiagnoseFeedBackBaseVC : MEBaseVC
//1问题咨询 2诊断报告
- (instancetype)initWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END

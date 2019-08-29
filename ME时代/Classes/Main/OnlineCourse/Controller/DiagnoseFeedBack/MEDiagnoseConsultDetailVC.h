//
//  MEDiagnoseConsultDetailVC.h
//  ME时代
//
//  Created by gao lei on 2019/8/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MEDiagnoseConsultModel;

@interface MEDiagnoseConsultDetailVC : MEBaseVC

- (instancetype)initWithModel:(MEDiagnoseConsultModel *)model;

@property (nonatomic, assign) BOOL isReply;

- (instancetype)initWithConsultId:(NSInteger )consultId;

@end

NS_ASSUME_NONNULL_END

//
//  MEJDCoupleMailDetalVC.h
//  志愿星
//
//  Created by hank on 2019/2/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class MEJDCoupleModel;
@interface MEJDCoupleMailDetalVC : MEBaseVC

@property (nonatomic, assign) BOOL isDynamic;
- (instancetype)initWithModel:(MEJDCoupleModel *)model;

@end

NS_ASSUME_NONNULL_END

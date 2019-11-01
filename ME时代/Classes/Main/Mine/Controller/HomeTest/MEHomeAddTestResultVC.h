//
//  MEHomeAddTestResultVC.h
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MEHomeAddTestDecModel;

@interface MEHomeAddTestResultVC : MEBaseVC

@property (nonatomic,copy)NSString *token;
@property (nonatomic,assign)MEHomeAddTestDecTypeVC type;

- (instancetype)initWithModel:(MEHomeAddTestDecModel *)model;

@end

NS_ASSUME_NONNULL_END

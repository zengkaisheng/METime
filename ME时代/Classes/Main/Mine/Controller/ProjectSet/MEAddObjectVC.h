//
//  MEAddObjectVC.h
//  志愿星
//
//  Created by gao lei on 2019/8/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"
@class MEProjectSettingListModel;
NS_ASSUME_NONNULL_BEGIN

@interface MEAddObjectVC : MEBaseVC

@property (nonatomic, copy) kMeBasicBlock finishBlock;
- (instancetype)initWithModel:(MEProjectSettingListModel *)model;

@end

NS_ASSUME_NONNULL_END

//
//  MEProjectSettingVC.h
//  志愿星
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEProjectSettingVC : MEBaseVC

@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic ,copy) kMeDictionaryBlock chooseBlock;

@end

NS_ASSUME_NONNULL_END

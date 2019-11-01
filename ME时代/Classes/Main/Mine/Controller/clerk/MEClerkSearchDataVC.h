//
//  MEClerkSearchDataVC.h
//  志愿星
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEClerkSearchDataVC : MEBaseVC

- (instancetype)initWithKey:(NSString *)key;

@property (nonatomic, copy) kMeBasicBlock finishUpdatClerkBlock;
@end

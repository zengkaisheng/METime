//
//  MEVIPViewController.h
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class MEMyCourseVIPDetailModel;

@interface MEVIPViewController : MEBaseVC

- (instancetype)initWithVIPModel:(MEMyCourseVIPDetailModel *)model;
@property (nonatomic, copy) kMeBasicBlock finishBlock;

@end

NS_ASSUME_NONNULL_END

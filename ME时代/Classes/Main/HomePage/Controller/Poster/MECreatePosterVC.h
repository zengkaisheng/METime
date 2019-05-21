//
//  MECreatePosterVC.h
//  ME时代
//
//  Created by hank on 2018/11/30.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MEPosterChildrenModel;
@class MEActivePosterModel;
@interface MECreatePosterVC : MEBaseVC

- (instancetype)initWithModel:(MEPosterChildrenModel *)model;
- (instancetype)initWithActiveModel:(MEActivePosterModel *)model;

@end

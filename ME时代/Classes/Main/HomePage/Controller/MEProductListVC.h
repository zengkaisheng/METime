//
//  MEProductListVC.h
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEProductListVC : MEBaseVC

- (instancetype)initWithType:(MEGoodsTypeNetStyle)type;
@property (nonatomic,copy)kMeBasicBlock finishBlock;
@end

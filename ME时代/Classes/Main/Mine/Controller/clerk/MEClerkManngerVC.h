//
//  MEClerkManngerVC.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

typedef void(^kMEChooseBlock)(NSString *name, NSString *memberId);

@interface MEClerkManngerVC : MEBaseVC

@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic, copy) kMEChooseBlock chooseBlock;

@end

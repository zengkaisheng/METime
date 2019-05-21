//
//  MENewAddressVC.h
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseVC.h"

@class MEAddressModel;
@interface MENewAddressVC : MEBaseVC

- (instancetype)initWithModel:(MEAddressModel *)model;
@property (nonatomic, copy) kMeBasicBlock reloadBlock;

@end

//
//  MELocationCLLModel.h
//  ME时代
//
//  Created by gao lei on 2018/9/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MELocationCLLModel : MEBaseModel

@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;

@end

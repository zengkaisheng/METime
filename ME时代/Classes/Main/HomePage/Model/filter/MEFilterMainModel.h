//
//  MEFilterMainModel.h
//  ME时代
//
//  Created by hank on 2018/11/2.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEFilterMainModel : MEBaseModel

@property (nonatomic, strong) NSString * category_name;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, assign) NSInteger idField;

@property (nonatomic, assign) NSInteger unRead;
@end

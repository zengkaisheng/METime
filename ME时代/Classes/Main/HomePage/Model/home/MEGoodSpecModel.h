//
//  MEGoodSpecModel.h
//  ME时代
//
//  Created by hank on 2018/9/17.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEGoodSpecModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, assign) NSInteger spec;
@property (nonatomic, strong) NSString * spec_value;

@property (nonatomic, assign) BOOL isSelect;
@end



//
//  MEAdvModel.h
//  ME时代
//
//  Created by hank on 2018/12/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"
//首页公告
@interface MEAdvModel : MEBaseModel

@property (nonatomic, assign) NSInteger article_id;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger message_type;
@property (nonatomic, assign) NSInteger product_id;
@property (nonatomic, strong) NSString * title;

@end

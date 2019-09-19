//
//  MECourseVIPModel.h
//  ME时代
//
//  Created by gao lei on 2019/9/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MECourseVIPDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSString * old_price;
@property (nonatomic, strong) NSString * price;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;

@end



@interface MECourseVIPModel : MEBaseModel

@property (nonatomic, strong) NSArray * vip;
@property (nonatomic, strong) NSString * vip_rule;

@property (nonatomic, assign) CGFloat ruleHeight;

@end

NS_ASSUME_NONNULL_END

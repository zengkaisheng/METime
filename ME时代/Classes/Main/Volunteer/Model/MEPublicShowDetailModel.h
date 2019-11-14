//
//  MEPublicShowDetailModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"
#import "MERecruitDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MEPublicShowDetailModel : MEBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSArray * comment;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * header_pic;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_praise;
@property (nonatomic, strong) NSString * nick_name;
@property (nonatomic, assign) NSInteger praise_num;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END

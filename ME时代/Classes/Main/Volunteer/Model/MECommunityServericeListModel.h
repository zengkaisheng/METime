//
//  MECommunityServericeListModel.h
//  志愿星
//
//  Created by gao lei on 2019/10/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECommunityServericeListModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * updated_at;

//公益秀相关
@property (nonatomic, assign) NSInteger praise_num;  //点赞数
@property (nonatomic, assign) NSInteger comment_num; //评论数
@property (nonatomic, assign) NSInteger is_praise;   //是否点赞 1是 0 否

@end

NS_ASSUME_NONNULL_END

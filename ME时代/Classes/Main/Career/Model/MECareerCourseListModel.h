//
//  MECareerCourseListModel.h
//  ME时代
//
//  Created by gao lei on 2019/10/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECareerCourseListModel : MEBaseModel

@property (nonatomic, assign) NSInteger a_id;
@property (nonatomic, strong) NSString * a_img_url;
@property (nonatomic, strong) NSString * a_img_urls;
@property (nonatomic, strong) NSString * a_name;
@property (nonatomic, assign) NSInteger c_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * img_url;
@property (nonatomic, strong) NSString * img_urls;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger is_like;  //是否点赞1是0否
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updated_at;


@end

NS_ASSUME_NONNULL_END

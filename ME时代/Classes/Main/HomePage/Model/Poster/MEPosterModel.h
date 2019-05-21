//
//  MEPosterModel.h
//  ME时代
//
//  Created by hank on 2018/11/30.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEPosterChildrenModel : MEBaseModel

@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * read_amount;
@property (nonatomic, strong) NSString * share_amount;
@property (nonatomic, strong) NSString * show_time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;

@end

@interface MEPosterModel : MEBaseModel

@property (nonatomic, strong) NSString * classify_name;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * icon;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSArray * children;

@end

//
//  MEVistorCountModel.h
//  ME时代
//
//  Created by hank on 2018/12/4.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEBaseModel.h"

@interface MEVistorCountModel : MEBaseModel

@property (nonatomic, strong) NSString* all_day;
@property (nonatomic, strong) NSString* share_all;
@property (nonatomic, strong) NSString* share_count_all;
@property (nonatomic, strong) NSString* share_count_today;
@property (nonatomic, strong) NSString* share_today;

@property (nonatomic, strong) NSString* today;
//海报
@property (nonatomic, strong) NSString* poster_count;
//文章
@property (nonatomic, strong) NSString* article_count;
@end

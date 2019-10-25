//
//  MECommunityServericeListModel.h
//  ME时代
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

@end

NS_ASSUME_NONNULL_END

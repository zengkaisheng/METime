//
//  MEHomeTestTitleModel.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEHomeTestTitleModel : MEBaseModel

@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * deleted_at;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * image_url;
@property (nonatomic, assign) NSInteger is_delete;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * updated_at;

@end

NS_ASSUME_NONNULL_END

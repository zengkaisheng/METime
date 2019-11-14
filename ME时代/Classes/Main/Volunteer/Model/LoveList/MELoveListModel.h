//
//  MELoveListModel.h
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MELoveListModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * header_pic;

@end

NS_ASSUME_NONNULL_END

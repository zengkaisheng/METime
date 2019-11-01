//
//  MECommonQuestionListModel.h
//  志愿星
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MECommonQuestionSubModel : MEBaseModel

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString *title;

@end


@interface MECommonQuestionListModel : MEBaseModel

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *problem;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END

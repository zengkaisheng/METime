//
//  MELivingHabitListModel.h
//  ME时代
//
//  Created by gao lei on 2019/8/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MELivingHabitsOptionModel : MEBaseModel

@property (nonatomic, assign) NSInteger classify_id;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSString * habit;
@property (nonatomic, assign) NSInteger habit_type;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger is_del;
@property (nonatomic, assign) NSInteger store_id;
@property (nonatomic, strong) NSString * updated_at;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) CGFloat cellHeight;

@end


@interface MELivingHabitListModel : MEBaseModel

@property (nonatomic, strong) NSString * classify_title;
@property (nonatomic, strong) NSArray * habit;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END

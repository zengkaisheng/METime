//
//  MELivingHabitListModel.m
//  志愿星
//
//  Created by gao lei on 2019/8/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELivingHabitListModel.h"

@implementation MELivingHabitsOptionModel

MEModelIdToIdField

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.habit).length > 0) {
        height = [kMeUnNilStr(self.habit) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-54-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+15;
    }
    return height+5;
}

@end


@implementation MELivingHabitListModel

MEModelIdToIdField

MEModelObjectClassInArrayWithDic((@{@"habit" : [MELivingHabitsOptionModel class]}))

@end

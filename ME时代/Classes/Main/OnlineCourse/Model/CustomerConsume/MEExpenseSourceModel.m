//
//  MEExpenseSourceModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEExpenseSourceModel.h"

@implementation MEExpenseSourceModel

MEModelIdToIdField

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.option).length > 0) {
        height = [kMeUnNilStr(self.option) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-54-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+15;
    }
    if (kMeUnNilStr(self.nature).length > 0) {
        height = [kMeUnNilStr(self.nature) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-54-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+15;
    }
    return height+5;
}

@end

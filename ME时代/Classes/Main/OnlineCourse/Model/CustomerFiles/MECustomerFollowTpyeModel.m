//
//  MECustomerFollowTpyeModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECustomerFollowTpyeModel.h"

@implementation MECustomerFollowTpyeModel

MEModelIdToIdField

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.follow_type_title).length > 0) {
        height = [kMeUnNilStr(self.follow_type_title) boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-54-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+15;
    }
    return height+5;
}

@end

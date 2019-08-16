//
//  MEDiagnoseOrderListModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEDiagnoseOrderListModel.h"

@implementation MEDiagnoseOrderListModel

MEModelIdToIdField

- (CGFloat)contentHeight {
    CGFloat height = 0;
    if (self.desc) {
        height = [self.desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+6;
    }
    return height;
}

@end

//
//  MEAddCustomerInfoModel.m
//  ME时代
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAddCustomerInfoModel.h"

@implementation MEAddCustomerInfoModel

- (CGFloat)cellHeight {
    CGFloat height = 0.0;
    if (kMeUnNilStr(self.title).length > 0) {
        height += [[NSString stringWithFormat:@"%@",kMeUnNilStr(self.title)] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+15;
    }
    if (kMeUnNilStr(self.value).length > 0) {
        height += [[NSString stringWithFormat:@"%@",kMeUnNilStr(self.value)] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+10;
    }
    
    return height+15>75?height+15:75;
}

@end

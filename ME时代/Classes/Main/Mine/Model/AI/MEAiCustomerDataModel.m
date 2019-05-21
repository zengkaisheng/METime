//
//  MEAiCustomerDataModel.m
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAiCustomerDataModel.h"

@implementation MEAiCustomerDataModel


- (void)setSex:(NSInteger)sex{
    _sex = sex;
    switch (_sex) {
        case 1:
            self.sexStr = @"男";
            break;
        case 2:
            self.sexStr = @"女";
            break;
        default:
            self.sexStr = @"保密";
            break;
    }
}

@end

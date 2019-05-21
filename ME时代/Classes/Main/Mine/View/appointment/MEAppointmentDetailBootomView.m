//
//  MEAppointmentDetailBootomView.m
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentDetailBootomView.h"

@implementation MEAppointmentDetailBootomView


- (IBAction)cancelAction:(UIButton *)sender {
    kMeCallBlock(_cancelBlock);
}

- (IBAction)finishAction:(UIButton *)sender {
    kMeCallBlock(_finishBlock);
}


@end

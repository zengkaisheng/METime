//
//  MEAppointmentDetailBootomView.h
//  ME时代
//
//  Created by hank on 2018/12/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEAppointmentDetailBootomViewheight = 84;

@interface MEAppointmentDetailBootomView : UIView

@property (nonatomic, copy) kMeBasicBlock cancelBlock;
@property (nonatomic, copy) kMeBasicBlock finishBlock;

@end

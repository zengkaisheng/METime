//
//  MEAppointmentTimeCell.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentTimeCell.h"

@interface MEAppointmentTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation MEAppointmentTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithModel:(METimeModel *)model isSelect:(BOOL)isSelect{
    self.backgroundColor = isSelect?kMEHexColor(@"cc9e69"):[UIColor whiteColor];
    _lblTitle.textColor = isSelect?[UIColor whiteColor]:kMEblack;
    _lblTitle.text = kMeUnNilStr(model.time);
}

@end

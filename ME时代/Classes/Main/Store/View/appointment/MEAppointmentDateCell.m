//
//  MEAppointmentDateCell.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentDateCell.h"

@interface MEAppointmentDateCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblWeek;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end

@implementation MEAppointmentDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.borderColor = kMEHexColor(@"dbdbdb");
    self.borderWidth = 1;
    // Initialization code
}

- (void)setUIWithModel:(METimeModel *)model isSelect:(BOOL)isSelect{
    self.backgroundColor = isSelect?kMEHexColor(@"cc9e69"):[UIColor whiteColor];
    _lblWeek.textColor = isSelect?[UIColor whiteColor]:kMEblack;
    _lblDate.textColor = isSelect?[UIColor whiteColor]:kMEblack;
    _lblWeek.text = kMeUnNilStr(model.week);
    _lblDate.text = kMeUnNilStr(model.month);
}

@end

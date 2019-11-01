//
//  MEAppointmentListCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/27.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAppointmentListCell.h"
#import "MEAppointmentListModel.h"

@interface MEAppointmentListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *projectLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnConsWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editBtnConsTtailing;

@end


@implementation MEAppointmentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 5;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEAppointmentListModel *)model {
    _timeLbl.text = kMeUnNilStr(model.appointment_time);
    _nameLbl.text = kMeUnNilStr(model.name);
    _subTitleLbl.text = kMeUnNilStr(model.cosmetologist_name);
    _projectLbl.text = kMeUnNilStr(model.object_name);
    
    int compare = [self compareDate:kMeUnNilStr(model.appointment_date)];
    if (compare == 1) {
        _cancelBtn.hidden = YES;
        _confirmBtn.hidden = YES;
        _confirmBtnConsWidth.constant = 0.0;
        _editBtnConsTtailing.constant = 0.0;
    }else {
        _cancelBtn.hidden = NO;
        _confirmBtn.hidden = NO;
        _confirmBtnConsWidth.constant = 70.0;
        _editBtnConsTtailing.constant = 10.0;
    }
    if (model.is_confirm == 1) {
        [_confirmBtn setTitle:@"已确定" forState:UIControlStateNormal];
        _cancelBtn.hidden = YES;
    }else {
        [_confirmBtn setTitle:@"确认预约" forState:UIControlStateNormal];
        _cancelBtn.hidden = NO;
    }
}

/// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date];
    
    NSDate *todayDate = [[NSDate alloc] init];
    NSString *today = [[todayDate getNowDateFormatterString] componentsSeparatedByString:@" "].firstObject;
    dt2 = [df dateFromString:today];
    
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}

- (IBAction)confirmAction:(id)sender {
    kMeCallBlock(self.tapBlock,0);
}
- (IBAction)editAppointmentAction:(id)sender {
    kMeCallBlock(self.tapBlock,1);
}
- (IBAction)cancelAppointmentAction:(id)sender {
    kMeCallBlock(self.tapBlock,2);
}

@end

//
//  MERecruitInfoCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitInfoCell.h"
#import "MERecruitDetailModel.h"

@interface MERecruitInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet UILabel *organizerLbl;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@end


@implementation MERecruitInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MERecruitDetailModel *)model {
    kSDLoadImg(_headerPic, model.image);
    _titleLbl.text = kMeUnNilStr(model.title);
    _remainingTimeLbl.text = kMeUnNilStr(model.time_remaining);
    _distanceLbl.text = kMeUnNilStr(model.distance);
    _areaLbl.text = kMeUnNilStr(model.area);
    _organizerLbl.text = [NSString stringWithFormat:@"举办方：%@",kMeUnNilStr(model.organizers)];
    _joinTimeLbl.text = [NSString stringWithFormat:@"招募时间：%@-%@",kMeUnNilStr(model.join_start_date),kMeUnNilStr(model.join_end_date)];
    _startTimeLbl.text = [NSString stringWithFormat:@"活动时间：%@-%@",kMeUnNilStr(model.start_date),kMeUnNilStr(model.end_date)];
    _phoneLbl.text = [NSString stringWithFormat:@"联系电话：%@",kMeUnNilStr(model.tel)];
}

@end

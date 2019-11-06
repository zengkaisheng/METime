//
//  MEAppointmentEyesightCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/6.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAppointmentEyesightCell.h"
#import "MEAppointDetailModel.h"

@interface MEAppointmentEyesightCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;


@end

@implementation MEAppointmentEyesightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEAppointDetailModel *)model {
    kSDLoadImg(_headerPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images)));
    _titleLbl.text = kMeUnNilStr(model.title);
    _timeLbl.text = [NSString stringWithFormat:@"创建时间:%@",kMeUnNilStr(model.created_at)];
    _countLbl.text = [NSString stringWithFormat:@"数量：%@",kMeUnNilStr(model.reserve_number)];
    CGFloat price = [kMeUnNilStr(model.money) floatValue] * [kMeUnNilStr(model.reserve_number) floatValue];
    _priceLbl.text = [NSString stringWithFormat:@"¥%@",@(price)];
}

@end

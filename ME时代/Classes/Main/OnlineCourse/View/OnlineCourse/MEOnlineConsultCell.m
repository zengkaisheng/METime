//
//  MEOnlineConsultCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineConsultCell.h"
#import "MEDiagnoseProductModel.h"

@interface MEOnlineConsultCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgVConsWidth;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *BGimageView;

@end

@implementation MEOnlineConsultCell

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

- (void)setUIWithDict:(NSDictionary *)dict {
    _titleLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(dict[@"title"])];
    _priceLbl.hidden = YES;
    _rightArrow.hidden = YES;
    if ([kMeUnNilStr(dict[@"title"]) isEqualToString:@"定制店铺专属方案"]) {
        _titleLbl.font = [UIFont boldSystemFontOfSize:15];
        _leftImgV.image = [UIImage imageNamed:@"icon_planDIY"];
        _leftImgVConsWidth.constant = 22.0;
        _BGimageView.image = [UIImage imageNamed:@"planDIY_BG"];
    }else if ([kMeUnNilStr(dict[@"title"]) isEqualToString:@"免费诊断店铺问题"]) {
        _titleLbl.font = [UIFont boldSystemFontOfSize:15];
        _leftImgV.image = [UIImage imageNamed:@"icon_consult"];
        _leftImgVConsWidth.constant = 26.0;
        _BGimageView.image = [UIImage imageNamed:@"diagnoseBGImage"];
    }
}

- (void)setUIWithModel:(MEDiagnoseProductModel *)model{
    _titleLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.title)];
    _priceLbl.hidden = NO;
    _rightArrow.hidden = YES;
    
    _titleLbl.font = [UIFont systemFontOfSize:15];
    kSDLoadImg(_leftImgV, kMeUnNilStr(model.image));
    _leftImgVConsWidth.constant = 22.0;
    _priceLbl.text = [NSString stringWithFormat:@"%@元/%@",kMeUnNilStr(model.price),kMeUnNilStr(model.type_name)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end

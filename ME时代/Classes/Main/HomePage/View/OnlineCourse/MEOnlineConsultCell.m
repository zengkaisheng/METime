//
//  MEOnlineConsultCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineConsultCell.h"

@interface MEOnlineConsultCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgVConsWidth;

@end

@implementation MEOnlineConsultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithModel:(id)model{
    _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 5;
    _bgView.clipsToBounds = false;
    
    if ([model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)model;
        _titleLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(dict[@"title"])];
        if ([dict.allKeys containsObject:@"price"]) {
            _priceLbl.hidden = NO;
            _titleLbl.font = [UIFont systemFontOfSize:15];
            _priceLbl.text = kMeUnNilStr(dict[@"price"]);
            _leftImgV.image = [UIImage imageNamed:@"icon_diagnoseService"];
            _leftImgVConsWidth.constant = 22.0;
        }else {
            _priceLbl.hidden = YES;
            _titleLbl.font = [UIFont systemFontOfSize:12];
            _leftImgV.image = [UIImage imageNamed:@"icon_consult"];
            _leftImgVConsWidth.constant = 26.0;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end

//
//  MEExpertDiagnoseListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEExpertDiagnoseListCell.h"
#import "MEDiagnoseProductModel.h"

@interface MEExpertDiagnoseListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;


@end


@implementation MEExpertDiagnoseListCell

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

- (void)setUIWithModel:(MEDiagnoseProductModel *)model{
    _titleLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.title)];
    _priceLbl.hidden = NO;
    
    _titleLbl.font = [UIFont systemFontOfSize:15];
    kSDLoadImg(_leftImgV, kMeUnNilStr(model.image));
    _priceLbl.text = [NSString stringWithFormat:@"%@元/%@",kMeUnNilStr(model.price),kMeUnNilStr(model.type_name)];
    _contentLbl.text = [NSString stringWithFormat:@"服务介绍：%@",kMeUnNilStr(model.desc)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end

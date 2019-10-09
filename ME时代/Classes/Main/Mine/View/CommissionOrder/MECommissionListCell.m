//
//  MECommissionListCell.m
//  ME时代
//
//  Created by gao lei on 2019/10/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommissionListCell.h"
#import "MEMoneyDetailedModel.h"

@interface MECommissionListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *commissionLbl;

@end

@implementation MECommissionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FBFBFB"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEMoneyDetailedModel *)model {
    kSDLoadImg(_productImageView, kMeUnNilStr(model.product_image));
    kSDLoadImg(_headerPic, kMeUnNilStr(model.member.header_pic));
    _productNameLbl.text = kMeUnNilStr(model.product_name);
    _nameLbl.text = kMeUnNilStr(model.member.name);
    _timeLbl.text  = [NSString stringWithFormat:@"下单时间:%@",kMeUnNilStr(model.created_at)];
    _amountLbl.text = [NSString stringWithFormat:@"消费金额:¥%@",kMeUnNilStr(model.all_amount)];
    _commissionLbl.text = [NSString stringWithFormat:@"获得金额:¥%@",kMeUnNilStr(model.money)];
}

@end

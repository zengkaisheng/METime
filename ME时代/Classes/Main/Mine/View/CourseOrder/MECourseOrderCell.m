//
//  MECourseOrderCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseOrderCell.h"
#import "MECourseOrderModel.h"

@interface MECourseOrderCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation MECourseOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 10;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setupUIWithModel:(MECourseOrderModel *)model {
    MECourseOrderGoodsModel *goodModel = model.order_goods;
    kSDLoadImg(_headerPic, kMeUnNilStr(goodModel.product_images_url));
    _numberLbl.text = [NSString stringWithFormat:@"订单编号：%@",kMeUnNilStr(model.order_sn)];
    _titleLbl.text = kMeUnNilStr(goodModel.product_name);
    _priceLbl.text = [NSString stringWithFormat:@"￥%@",kMeUnNilStr(goodModel.product_amount).length>0?kMeUnNilStr(goodModel.product_amount):@"0.00"];
    _timeLbl.text = [NSString stringWithFormat:@"购买时间：%@",kMeUnNilStr(model.created_at)];
}

@end

//
//  MEFourHomeActivityCell.m
//  志愿星
//
//  Created by gao lei on 2019/7/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeActivityCell.h"
#import "MEBargainListModel.h"
#import "MEGroupListModel.h"
#import "MEGoodModel.h"

@interface MEFourHomeActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIImageView *groupImgV;
@property (weak, nonatomic) IBOutlet UILabel *groupNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *origainlPriceLbl;
@property (weak, nonatomic) IBOutlet UIButton *avtivityBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConsWidth;
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consStockRate;
@property (weak, nonatomic) IBOutlet UILabel *rateLbl;
@property (weak, nonatomic) IBOutlet UILabel *sellNumLbl;

@end


@implementation MEFourHomeActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithBargainModel:(MEBargainListModel *)model {
    _subTitleLbl.hidden = NO;
    _countLbl.hidden = NO;
    _groupImgV.hidden = YES;
    _groupNumberLbl.hidden = YES;
    _origainlPriceLbl.hidden = YES;
    _rateView.hidden = YES;
    _sellNumLbl.hidden = YES;
    
    kSDLoadImg(_headerPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images)));
    _titleLbl.text = kMeUnNilStr(model.title);
    _subTitleLbl.text = kMeUnNilStr(model.desc);
    _countLbl.text = [NSString stringWithFormat:@"已有%@人领取",kMeUnNilNumber(@(model.finish_bargin_num))];
    
    if (kMeUnNilStr(model.product_price).length > 0) {
        NSArray *productPrice = [model.product_price componentsSeparatedByString:@"."];
        if ([productPrice.lastObject intValue] == 0) {
            _priceLbl.text = [NSString stringWithFormat:@"价值%@元",productPrice.firstObject];
        }else {
            _priceLbl.text = [NSString stringWithFormat:@"价值%@元",kMeUnNilStr(model.product_price)];
        }
    }else {
        _priceLbl.text = @"价值0元";
    }
    
    NSString *content = [NSString stringWithFormat:@"砍价%.2f元得",[kMeUnNilStr(model.product_price) floatValue] - [kMeUnNilStr(model.amount_money) floatValue]];
    NSString *balance = [NSString stringWithFormat:@"%.2f",[kMeUnNilStr(model.product_price) floatValue] - [kMeUnNilStr(model.amount_money) floatValue]];
    NSArray *balanceArr = [balance componentsSeparatedByString:@"."];
    if ([balanceArr.lastObject intValue] == 0) {
        content = [NSString stringWithFormat:@"砍价%@元得",balanceArr.firstObject];
    }else {
        content = [NSString stringWithFormat:@"砍价%@元得",balance];
    }
    
//    _priceLbl.text = [NSString stringWithFormat:@"价值%@元",kMeUnNilStr(model.product_price).length>0?kMeUnNilStr(model.product_price):@"0"];
//
//    NSString *content = [NSString stringWithFormat:@"砍价%.2f元得",[kMeUnNilStr(model.product_price) floatValue] - [kMeUnNilStr(model.amount_money) floatValue]];
    CGFloat width = [content boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    [_avtivityBtn setTitle:content forState:UIControlStateNormal];
    _btnConsWidth.constant = width+10;
    [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#FCA830"]];
}

- (void)setUIWithGroupModel:(MEGroupListModel *)model {
//    _subTitleLbl.hidden = YES;
    _countLbl.hidden = YES;
    _groupImgV.hidden = NO;
    _groupNumberLbl.hidden = NO;
    _origainlPriceLbl.hidden = NO;
    _rateView.hidden = YES;
    _sellNumLbl.hidden = YES;
    
    kSDLoadImg(_headerPic, kMeUnNilStr(model.image_url));
    _titleLbl.text = kMeUnNilStr(model.title);
    _subTitleLbl.text = kMeUnNilStr(model.desc);
    _groupNumberLbl.text = [NSString stringWithFormat:@"%@人团",@(kMeUnNilStr(model.group_num).intValue)];
    
    if (IS_IPHONE_4S||IS_IPHONE_5||IS_iPhone5S) {
        _priceLbl.font = [UIFont systemFontOfSize:10];
        _origainlPriceLbl.font = [UIFont systemFontOfSize:8];
    }else if (IS_IPHONE_6) {
        _priceLbl.font = [UIFont systemFontOfSize:12];
        _origainlPriceLbl.font = [UIFont systemFontOfSize:11];
    }else {
        _priceLbl.font = [UIFont systemFontOfSize:14];
        _origainlPriceLbl.font = [UIFont systemFontOfSize:13];
    }
    
    _priceLbl.text = [NSString stringWithFormat:@"拼团价￥%@",kMeUnNilStr(model.money)];
//    _origainlPriceLbl.text = [NSString stringWithFormat:@"%@",kMeUnNilStr(model.market_price)];
    [_origainlPriceLbl setLineStrWithStr:[NSString stringWithFormat:@"%@",kMeUnNilStr(model.market_price)]];
    [_avtivityBtn setTitle:@"去开团" forState:UIControlStateNormal];
    [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#FCA830"]];
}

- (void)setUIWithGoodModel:(MEGoodModel *)model {
    kSDLoadImg(_headerPic,kMeUnNilStr(model.images_url));
    _titleLbl.text = kMeUnNilStr(model.title);
    _groupImgV.hidden = YES;
    _groupNumberLbl.hidden = YES;
//    _countLbl.hidden = YES;
    _rateView.hidden = YES;
    _sellNumLbl.hidden = YES;
    
    if (model.type == 5) {
        _origainlPriceLbl.hidden = YES;
        _priceLbl.text = [NSString stringWithFormat:@"价值%@元",kMeUnNilStr(model.money).length>0?kMeUnNilStr(model.money):@"0"];
        _subTitleLbl.text = kMeUnNilStr(model.desc);
        _countLbl.text = [NSString stringWithFormat:@"开奖时间：%@",model.end_time];
        switch (model.join_type) {
            case 1:
            {//未参加
                [_avtivityBtn setTitle:@"立即签到" forState:UIControlStateNormal];
                [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#FCA830"]];
            }
                break;
            case 2:
            {//等待开奖
                [_avtivityBtn setTitle:@"等待开奖" forState:UIControlStateNormal];
                [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#FCA830"]];
            }
                break;
            case 3:
            {//中奖(待领取)
                [_avtivityBtn setTitle:@"领取奖品" forState:UIControlStateNormal];
                [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#FCA830"]];
            }
                break;
            case 4:
            {//未中奖
                [_avtivityBtn setTitle:@"已结束" forState:UIControlStateNormal];
                [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
            }
                break;
            case 5:
            {//已领取
                [_avtivityBtn setTitle:@"已领取" forState:UIControlStateNormal];
                [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
            }
                break;
            default:
                break;
        }
    }else if (model.type == 4) {
        _origainlPriceLbl.hidden = NO;
        _rateView.hidden = NO;
        _sellNumLbl.hidden = NO;
        
        NSInteger rate = ((model.sell_num+model.sales) *100)/(model.stock+model.sell_num+model.sales);
        _rateLbl.text = [NSString stringWithFormat:@"%ld%%",(long)rate];
        _consStockRate.constant = rate*1.27;
        _sellNumLbl.text = [NSString stringWithFormat:@"已抢%ld件",(long)model.sell_num+model.sales];
        
        [_avtivityBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_avtivityBtn setBackgroundColor:[UIColor colorWithHexString:@"#FCA830"]];
        _subTitleLbl.text = kMeUnNilStr(model.desc).length?kMeUnNilStr(model.desc):kMeUnNilStr(model.title);
        
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.money).floatValue)];
        [_origainlPriceLbl setLineStrWithStr:[NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.market_price).floatValue)]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}
- (IBAction)activityBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = 0;
    if ([btn.titleLabel.text isEqualToString:@"已兑换"]) {
        return;
    }
    if ([btn.titleLabel.text isEqualToString:@"重砍一个"]) {
        index = 1;
    }
    if (self.tapBlock) {
        self.tapBlock(index);
    }
}

@end

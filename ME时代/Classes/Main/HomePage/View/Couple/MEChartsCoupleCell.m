//
//  MEChartsCoupleCell.m
//  志愿星
//
//  Created by gao lei on 2019/6/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEChartsCoupleCell.h"
#import "MECoupleModel.h"
#import "MEJDCoupleModel.h"
#import "MEPinduoduoCoupleModel.h"

@interface MEChartsCoupleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblOrigalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSale;
@property (weak, nonatomic) IBOutlet UILabel *lblJuanPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblJuan;
@property (weak, nonatomic) IBOutlet UIImageView *imgJuan;
@property (weak, nonatomic) IBOutlet UILabel *lblMaterSale;
@property (weak, nonatomic) IBOutlet UILabel *lblCommission;

@end

@implementation MEChartsCoupleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lblJuan.adjustsFontSizeToFitWidth = YES;
    _lblCommission.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MECoupleModel *)model{
//    [_imgPic sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(model.pict_url)] placeholderImage:kImgPlaceholder];
//    _lblTitle.text = kMeUnNilStr(model.title);
//    _lblSale.text = [NSString stringWithFormat:@"已售%@",kMeUnNilStr(model.volume)];
//    //原价
//    _lblOrigalPrice.text =[NSString stringWithFormat:@"原价¥%@",@(kMeUnNilStr(model.zk_final_price).floatValue)];
//    //卷后价
//    NSString *fstr = [NSString stringWithFormat:@"卷后¥%@", @(kMeUnNilStr(model.truePrice).floatValue)];
//    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
//    NSUInteger secondLoc = [[faString string] rangeOfString:@"¥"].location;
//
//    NSRange range = NSMakeRange(0, secondLoc+1);
//    [faString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:11] range:range];
//    _lblJuanPrice.attributedText = faString;
//    //卷价格
//    if(kMeUnNilStr(model.coupon_info).length){
//        _imgJuan.hidden = NO;
//        _lblJuan.hidden = NO;
//        _lblTitle.numberOfLines = 1;
//        _lblJuan.text =[NSString stringWithFormat:@"%@元券",kMeUnNilStr(model.couponPrice)];
//        _lblOrigalPrice.hidden = NO;
//        _lblSale.hidden = NO;
//        _lblMaterSale.hidden = YES;
//    }else{
//        _lblTitle.numberOfLines = 2;
//        _imgJuan.hidden = YES;
//        _lblJuan.hidden = YES;
//        _lblJuan.text = @"";
//        _lblOrigalPrice.hidden = YES;
//        _lblSale.hidden = YES;
//        _lblMaterSale.hidden = NO;
//        _lblMaterSale.text = [NSString stringWithFormat:@"已售%@",kMeUnNilStr(model.couponSale)];
//    }
//
    
    [_imgPic sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(model.pict_url)] placeholderImage:kImgPlaceholder];
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSale.text = [NSString stringWithFormat:@"已售%d",kMeUnNilStr(model.volume).intValue];
    //原价
//    _lblOrigalPrice.text =[NSString stringWithFormat:@"原价¥%@",@(kMeUnNilStr(model.zk_final_price).floatValue)];
    NSString *fstr = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.zk_final_price).floatValue)];
    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
    [faString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, fstr.length)];
    _lblOrigalPrice.attributedText = faString;
    //卷后价
        _lblJuanPrice.text =[NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.truePrice).floatValue)];
//    NSString *fstr = [NSString stringWithFormat:@"卷后¥%.1f",kMeUnNilStr(model.truePrice).floatValue];
//    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
//    NSUInteger secondLoc = [[faString string] rangeOfString:@"¥"].location;
//
//    NSRange range = NSMakeRange(0, secondLoc+1);
//    [faString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:11] range:range];
//    _lblJuanPrice.attributedText = faString;
    //卷价格
    if(kMeUnNilStr(model.coupon_info).length){
        _imgJuan.hidden = NO;
        _lblJuan.hidden = NO;
        _lblTitle.numberOfLines = 1;
        _lblJuan.text =[NSString stringWithFormat:@"%@元券",kMeUnNilStr(model.couponPrice)];
        _lblOrigalPrice.hidden = NO;
        _lblSale.hidden = NO;
        _lblMaterSale.hidden = YES;
    }else{
        _imgJuan.hidden = NO;
        _lblJuan.hidden = NO;
        _lblTitle.numberOfLines = 2;
        _lblJuan.text =[NSString stringWithFormat:@"%@元券",kMeUnNilStr(model.coupon_amount)];
        _lblOrigalPrice.hidden = NO;
        _lblSale.hidden = NO;
        _lblMaterSale.hidden = YES;
    }
    _lblCommission.text = [NSString stringWithFormat:@"预估佣金￥%.2f",model.min_ratio];
}

- (void)setpinduoduoUIWithModel:(MEPinduoduoCoupleModel *)model{
    _imgJuan.hidden = NO;
    _lblJuan.hidden = NO;
    _lblMaterSale.hidden = YES;
    _lblOrigalPrice.hidden = NO;
    _lblSale.hidden = NO;
    _lblTitle.numberOfLines = 1;
    [_imgPic sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(model.goods_thumbnail_url)] placeholderImage:kImgPlaceholder];
    _lblTitle.text = kMeUnNilStr(model.goods_name);
    _lblSale.text = [NSString stringWithFormat:@"已售%@",kMeUnNilStr(model.sales_tip).length>0?kMeUnNilStr(model.sales_tip):@"0"];
    _lblOrigalPrice.text = [NSString stringWithFormat:@"原价¥%@", [MECommonTool changeformatterWithFen:@(model.min_group_price)]];
    _lblJuan.text =[NSString stringWithFormat:@"%@元券",[MECommonTool changeformatterWithFen:@(model.coupon_discount)]];
    //    _lblJuanPrice.text =[NSString stringWithFormat:@"¥%@", [MECommonTool changeformatterWithFen:@(model.min_group_price-model.coupon_discount)]];
    
    NSString *fstr = [NSString stringWithFormat:@"券后¥%@", [MECommonTool changeformatterWithFen:@(model.min_group_price-model.coupon_discount)]];
    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
    NSUInteger secondLoc = [[faString string] rangeOfString:@"¥"].location;
    
    NSRange range = NSMakeRange(0, secondLoc+1);
    [faString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:11] range:range];
    _lblJuanPrice.attributedText = faString;
}

- (void)setJDUIWithModel:(MEJDCoupleModel *)model{
    _imgJuan.hidden = NO;
    _lblJuan.hidden = NO;
    _lblMaterSale.hidden = YES;
    _lblOrigalPrice.hidden = NO;
    _lblSale.hidden = NO;
    _lblTitle.numberOfLines = 1;
    NSString *str = @"";
    if(kMeUnArr(model.imageInfo.imageList).count>0){
        ImageContentInfo *imageInfo = model.imageInfo.imageList[0];
        str = kMeUnNilStr(imageInfo.url);
    }
    [_imgPic sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:kImgPlaceholder];
    _lblTitle.text = kMeUnNilStr(model.skuName);
    _lblSale.text = [NSString stringWithFormat:@"%@评论",kMeUnNilStr(model.comments).length>0?kMeUnNilStr(model.comments):@"0"];
    _lblOrigalPrice.text = [NSString stringWithFormat:@"原价¥%@",kMeUnNilStr(model.priceInfo.price)];
    CouponContentInfo *couponInfoModel = [CouponContentInfo new];
    if(kMeUnArr(model.couponInfo.couponList).count>0){
        couponInfoModel = model.couponInfo.couponList[0];
    }
    _lblJuan.text =[NSString stringWithFormat:@"%@元券",kMeUnNilStr(couponInfoModel.discount)];
    
    CGFloat oPrice = [kMeUnNilStr(model.priceInfo.price) floatValue];
    CGFloat dPrice = [kMeUnNilStr(couponInfoModel.discount) floatValue];
    CGFloat price =  oPrice- dPrice;
    if(price<0){
        price = 0;
    }
    NSString *strPrice = [NSString stringWithFormat:@"%.2f",price];
    _lblJuanPrice.text =[NSString stringWithFormat:@"¥%@", strPrice];
}

@end

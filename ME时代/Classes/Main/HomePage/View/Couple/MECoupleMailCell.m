//
//  MECoupleMailCell.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MECoupleMailCell.h"
#import "MECoupleModel.h"
#import "MEJDCoupleModel.h"
#import "MEPinduoduoCoupleModel.h"

@interface MECoupleMailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblOrigalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSale;
@property (weak, nonatomic) IBOutlet UILabel *lblJuanPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblJuan;
@property (weak, nonatomic) IBOutlet UIImageView *imgJuan;
@property (weak, nonatomic) IBOutlet UILabel *lblMaterSale;

@end

@implementation MECoupleMailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblJuan.adjustsFontSizeToFitWidth = YES;
    _consImgHeight.constant = kMECoupleMailCellWdith;
    // Initialization code
}

- (void)setUIWithModel:(MECoupleModel *)model{
    [_imgPic sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(model.pict_url)] placeholderImage:kImgPlaceholder];
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSale.text = [NSString stringWithFormat:@"已售%@",kMeUnNilStr(model.couponSale)];
    //原价
    _lblOrigalPrice.text =[NSString stringWithFormat:@"原价¥%@",@(kMeUnNilStr(model.zk_final_price).floatValue)];
    //卷后价
    _lblJuanPrice.text =[NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.truePrice).floatValue)];
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
        _lblTitle.numberOfLines = 2;
        _imgJuan.hidden = YES;
        _lblJuan.hidden = YES;
        _lblJuan.text = @"";
        _lblOrigalPrice.hidden = YES;
        _lblSale.hidden = YES;
        _lblMaterSale.hidden = NO;
        _lblMaterSale.text = [NSString stringWithFormat:@"已售%@",kMeUnNilStr(model.couponSale)];
    }
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
    _lblSale.text = [NSString stringWithFormat:@"已售%@",kMeUnNilStr(model.sold_quantity)];
    _lblOrigalPrice.text = [NSString stringWithFormat:@"原价¥%@", [MECommonTool changeformatterWithFen:@(model.min_group_price)]];
     _lblJuan.text =[NSString stringWithFormat:@"%@元券",[MECommonTool changeformatterWithFen:@(model.coupon_discount)]];
    _lblJuanPrice.text =[NSString stringWithFormat:@"¥%@", [MECommonTool changeformatterWithFen:@(model.min_group_price-model.coupon_discount)]];
   
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
    _lblSale.text = [NSString stringWithFormat:@"已售%@",kMeUnNilStr(model.comments)];
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

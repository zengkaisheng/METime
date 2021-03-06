//
//  MEOrderDetailContentCell.m
//  志愿星
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEOrderDetailContentCell.h"
#import "MEOrderDetailModel.h"
#import "MEOrderModel.h"
#import "MEAppointDetailModel.h"
#import "MERefundModel.h"
#import "MEGroupOrderDetailModel.h"

@interface MEOrderDetailContentCell(){
    NSArray *_arrAppointType;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSku;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgVHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVWidthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVHeightConstraints;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end


@implementation MEOrderDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblSku.adjustsFontSizeToFitWidth = YES;
    _arrAppointType = MEAppointmenyStyleTitle;
    // Initialization code
}

//- (void)setUiWithModel:(MEOrderGoodModel *)model{
//    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.product_image)));
//    _lblTitle.text = kMeUnNilStr(model.product_name);
//    _lblSku.text = [NSString stringWithFormat:@"规格:%@数量:%@",kMeUnNilStr(model.product_name),@(model.product_number)];
//    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.product_amount)];
//}

- (void)setUIWithChildModel:(MEOrderGoodModel *)model{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.product_image)));
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSku.text = [NSString stringWithFormat:@"规格:%@ 数量:%@",kMeUnNilStr(model.order_spec_name),@(model.product_number)];
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.product_amount)];
    _imgVWidthConstraints.constant = 95;
    _lblAppointStatus.hidden = YES;
}

- (void)setAppointUIWithChildModel:(MEAppointDetailModel *)model{
    _lblAppointStatus.hidden = NO;
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images)));
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSku.text = kMeUnNilStr(model.arrive_time);
    CGFloat price = [kMeUnNilStr(model.money) floatValue] * [kMeUnNilStr(model.reserve_number) floatValue];
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",@(price)];
    if(model.is_use<2 && model.is_use>0){
        _lblAppointStatus.text = _arrAppointType[model.is_use];
    }
}

- (void)setUIWithRefundModel:(MERefundGoodModel *)model {
    _bgVHeightConstraints.constant = 127;
    _imgVWidthConstraints.constant = 95;
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.product_image)));
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSku.text = [NSString stringWithFormat:@"规格:%@ 数量:%@",kMeUnNilStr(model.order_spec_name),@(model.product_number)];
    _lblAppointStatus.hidden = YES;
}

- (void)setUIWithGroupModel:(MEGroupOrderDetailModel *)model {
    _bgVHeightConstraints.constant = 155;
    _imgVWidthConstraints.constant = 120;
    kSDLoadImg(_imgPic, kMeUnNilStr(model.image_url));
    _lblTitle.text = kMeUnNilStr(model.order_goods.product_name);
    _lblSku.text = [NSString stringWithFormat:@"规格:%@ 数量:%@",kMeUnNilStr(model.order_goods.order_spec_name),@(model.order_goods.product_number)];
    _lblAppointStatus.hidden = YES;
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",model.order_goods.product_amount];
}

- (void)setIsApplyRefund:(BOOL)isApplyRefund {
    if (isApplyRefund) {
        _bgVHeightConstraints.constant = 127;
    }else {
        _bgVHeightConstraints.constant = 121;
    }
}

- (void)setIsRefundDetail:(BOOL)isRefundDetail {
    if (isRefundDetail) {
        _bgView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _imgVWidthConstraints.constant = 62;
        _imgVHeightConstraints.constant = 68;
        _bgVHeightConstraints.constant = 98;
        _lblPrice.hidden = YES;
    }else {
        _bgView.backgroundColor = [UIColor whiteColor];
        _imgVWidthConstraints.constant = 82;
        _imgVHeightConstraints.constant = 106;
        _bgVHeightConstraints.constant = 121;
        _lblPrice.hidden = NO;
    }
}

@end

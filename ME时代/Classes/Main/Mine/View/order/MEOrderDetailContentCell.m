//
//  MEOrderDetailContentCell.m
//  ME时代
//
//  Created by gao lei on 2018/9/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEOrderDetailContentCell.h"
#import "MEOrderDetailModel.h"
#import "MEOrderModel.h"
#import "MEAppointDetailModel.h"

@interface MEOrderDetailContentCell(){
    NSArray *_arrAppointType;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSku;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointStatus;

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

@end

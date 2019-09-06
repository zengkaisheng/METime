//
//  MEMyChildOrderContentCell.m
//  ME时代
//
//  Created by gao lei on 2018/9/21.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyChildOrderContentCell.h"
#import "MEOrderModel.h"
#import "MERefundModel.h"
#import "MEGroupOrderModel.h"

@interface MEMyChildOrderContentCell (){
    NSArray *_arrType;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSkuAndNum;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *pinLbl;
@property (weak, nonatomic) IBOutlet UILabel *topUpStatusLbl;

@end

@implementation MEMyChildOrderContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _arrType = MEOrderStyleTitle;
    _pinLbl.hidden = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEOrderGoodModel *)model{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.product_image)));
    _lblStatus.text = kMeUnNilStr(model.order_goods_status_name);
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.product_amount)];
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSkuAndNum.text = [NSString stringWithFormat:@"规格:%@ 数量:%@",kMeUnNilStr(model.order_spec_name),@(model.product_number)];
    _topUpStatusLbl.text = kMeUnNilStr(model.top_up_status_name);
    if (model.isTopUp) {
        _topUpStatusLbl.hidden = YES;
        _lblStatus.text = kMeUnNilStr(model.top_up_status_name);
    }
}

- (void)setSelfUIWithModel:(MEOrderGoodModel *)model extractStatus:(NSString *)status{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.product_image)));
    _lblStatus.text = kMeUnNilStr(status);
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.product_amount)];
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSkuAndNum.text = [NSString stringWithFormat:@"规格:%@ 数量:%@",kMeUnNilStr(model.order_spec_name),@(model.product_number)];
}


- (void)setUIWithRefundModel:(MERefundGoodModel *)model{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.product_image)));
    _lblStatus.text = kMeUnNilStr(model.order_goods_status_name);
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.product_amount)];
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSkuAndNum.text = [NSString stringWithFormat:@"规格:%@ 数量:%@",kMeUnNilStr(model.order_spec_name),@(model.product_number)];
}

- (void)setUIWithGroupModel:(MEGroupOrderModel *)model {
    kSDLoadImg(_imgPic,kMeUnNilStr(model.images_url));
    _lblStatus.hidden = YES;
    _pinLbl.hidden = NO;
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.group_price)];
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSkuAndNum.text = [NSString stringWithFormat:@"规格:%@ 数量:%@",kMeUnNilStr(model.order_spec_name),@(model.product_number)];
}

@end

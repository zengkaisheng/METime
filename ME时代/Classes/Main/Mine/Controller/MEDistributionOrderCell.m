//
//  MEDistributionOrderCell.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEDistributionOrderCell.h"
#import "MEDistributionOrderCell.h"
#import "MEDistrbutionOrderModel.h"

@interface MEDistributionOrderCell (){
    NSArray *_arrType;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSku;
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;



@end

@implementation MEDistributionOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _arrType = MEDistrbutionOrderStyleTitle;
    
}

- (void)setUIWithModel:(id)model Type:(MEDistrbutionOrderStyle)type{
    kSDLoadImg(_imgPic, @"");
//    _lblStatus.text = _arrType[type];
//    _lblStatus.textColor = type==MEDistrbutionNeedPayOrder?kMEHexColor(@"ff809e"):kMEHexColor(@"6ed23c");
//    _lblStatus.borderColor =type==MEDistrbutionNeedPayOrder?kMEHexColor(@"ff809e"):kMEHexColor(@"6ed23c");
}

- (void)setUIWithModel:(MEDistrbutionOrderModel *)model{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.product_image)));
    _lblTitle.text = kMeUnNilStr(model.product_name);
    _lblSku.text = kMeUnNilStr(model.order_spec_name);
    _lblNum.text = [NSString stringWithFormat:@"X%@",@(model.product_number)];
    _lblPrice.text = kMeUnNilStr(model.all_amount);
    
}


@end

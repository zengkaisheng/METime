//
//  MEServiceDetailTelAddressCell.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEServiceDetailTelAddressCell.h"
#import "MEStoreDetailModel.h"

@interface MEServiceDetailTelAddressCell (){
    MEStoreDetailModel *_model;
}
@property (weak, nonatomic) IBOutlet UIView *viewForAddress;
@property (weak, nonatomic) IBOutlet UIView *viewForTel;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTel;

@end

@implementation MEServiceDetailTelAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _viewForAddress.userInteractionEnabled = YES;
    _viewForTel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressAction:)];
    [_viewForAddress addGestureRecognizer:ges];
    
    UITapGestureRecognizer *gestel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(telAction:)];
    [_viewForTel addGestureRecognizer:gestel];
    // Initialization code
}

- (void)addressAction:(UITapGestureRecognizer *)ges{
    [MECommonTool doNavigationWithEndLocation:@[kMeUnNilStr(_model.latitude),kMeUnNilStr(_model.longitude)]];
}

- (void)telAction:(UITapGestureRecognizer*)ges{
    if(kMeUnNilStr(_model.mobile).length){
         [MECommonTool showWithTellPhone:kMeUnNilStr(_model.mobile) inView:self];
    }else{
         [MECommonTool showWithTellPhone:kMeUnNilStr(_model.cellphone) inView:self];
    }
}

- (void)setUIWithModel:(MEStoreDetailModel *)model{
    _model = model;
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
    _lblAddress.text = address;
    if(kMeUnNilStr(_model.mobile).length){
        _lblTel.text = kMeUnNilStr(model.mobile);
    }else{
        _lblTel.text = kMeUnNilStr(model.cellphone);
    }
}



@end

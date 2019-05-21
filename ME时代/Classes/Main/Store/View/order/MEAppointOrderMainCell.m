//
//  MEAppointOrderMainCell.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointOrderMainCell.h"
#import "MEStoreDetailModel.h"
#import "MEAppointAttrModel.h"
#import "MEServiceDetailsModel.h"

@interface MEAppointOrderMainCell (){
    MEServiceDetailsModel *_model;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCommonPrice;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblAllPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblActivePrice;
@property (strong   , nonatomic) MEAppointAttrModel *attrModel;
@property (weak, nonatomic) IBOutlet UILabel *lblFristBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectFristBuy;

@end

@implementation MEAppointOrderMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblFristBuy.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModel:(MEServiceDetailsModel *)model attrModel:(MEAppointAttrModel *)attrModel{
    _lblFristBuy.hidden = YES;
    _btnSelectFristBuy.hidden = YES;
    if(model.serviceDetail.is_first_buy){
        NSInteger f = [[[NSUserDefaults standardUserDefaults] objectForKey:kcheckFirstBuy] integerValue];
        if(f){
            _lblFristBuy.hidden = NO;
            _btnSelectFristBuy.hidden = NO;
            if (self.attrModel.is_first_buy) {
                [_btnSelectFristBuy setImage:[UIImage imageNamed:@"inc-gg"] forState:(UIControlStateNormal)];
            } else {
                [_btnSelectFristBuy setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:(UIControlStateNormal)];
            }
        }
    }
    _model = model;
    self.attrModel = attrModel;
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.serviceDetail.images)));
    _lblTitle.text = kMeUnNilStr(model.serviceDetail.title);
    _lblSubTitle.text = kMeUnNilStr(model.serviceDetail.title);
    _lblPrice.text = kMeUnNilStr(model.serviceDetail.money);
    
    // 赋值
//    [_lblCommonPrice setLineStrWithStr:@"¥1000"];
    CGFloat allPrice = ([kMeUnNilStr(model.serviceDetail.money) floatValue] *  attrModel.reserve_number);
    _lblAllPrice.text = [NSString stringWithFormat:@"¥%@",@(allPrice)];
}

//减
- (IBAction)cut:(UIButton *)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count--;
    if (count <= 0) {
        return;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
    self.attrModel.reserve_number = count;
    
    CGFloat allPrice = ([kMeUnNilStr(_model.serviceDetail.money) floatValue] *  _attrModel.reserve_number);
    _lblAllPrice.text = [NSString stringWithFormat:@"¥%@",@(allPrice)];
}

//加
- (IBAction)add:(UIButton *)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
    self.attrModel.reserve_number = count;
    
    CGFloat allPrice = ([kMeUnNilStr(_model.serviceDetail.money) floatValue] *  _attrModel.reserve_number);
    _lblAllPrice.text = [NSString stringWithFormat:@"¥%@",@(allPrice)];
}

- (IBAction)fristBuyAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.attrModel.is_first_buy = sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"inc-gg"] forState:(UIControlStateNormal)];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:(UIControlStateNormal)];
    }
}

@end

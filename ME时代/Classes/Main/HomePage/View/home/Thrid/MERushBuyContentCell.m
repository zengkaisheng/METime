//
//  MERushBuyContentCell.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MERushBuyContentCell.h"
#import "METhridHomeRudeGoodModel.h"

@interface MERushBuyContentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consRateWdith;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblUnderLinePrice;

@property (weak, nonatomic) IBOutlet UIView *viewForStock;

@end

@implementation MERushBuyContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblTitle.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
    _lblPrice.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17];
    _lblPrice.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModel:(METhridHomeRudeGoodModel *)model{
    kSDLoadImg(_imgPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images)));
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSubTitle.text = kMeUnNilStr(model.desc);
    if(model.stock ==0 && model.sell_num==0){
        _viewForStock.hidden = YES;
        _lblRate.hidden = YES;
    }else{
        _viewForStock.hidden = NO;
        _lblRate.hidden = NO;
        NSInteger rate = (model.sell_num *100)/(model.stock+model.sell_num);
        _lblRate.text = [NSString stringWithFormat:@"%ld%%",(long)rate];
        _consRateWdith.constant = rate;
    }
 
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.money).floatValue)];
    NSString *commStr = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.market_price).floatValue)];
    [_lblUnderLinePrice setLineStrWithStr:commStr];
    
}

@end

//
//  MEShoppingMallCell.m
//  ME时代
//
//  Created by hank on 2018/12/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShoppingMallCell.h"
#import "MEGoodModel.h"

@interface MEShoppingMallCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgH;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblComPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consPriceBottomMargin;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnW;

@end

@implementation MEShoppingMallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _consImgW.constant = 125 * kMeFrameScaleX();
    _consImgH.constant = 125 * kMeFrameScaleX();
    _consTitleTop.constant = 12* kMeFrameScaleX();
    _consPriceBottomMargin.constant = -(12* kMeFrameScaleX());
    _consBtnW.constant = 65* kMeFrameScaleX();
    if(kMeFrameScaleY()<1){
        _lblTitle.font = [UIFont systemFontOfSize:(15 * kMeFrameScaleX())];
         _lblComPrice.font = [UIFont systemFontOfSize:(15 * kMeFrameScaleX())];
        _lblPrice.font = [UIFont systemFontOfSize:(15 * kMeFrameScaleX())];
         _lblSubtitle.font = [UIFont systemFontOfSize:(12 * kMeFrameScaleX())];
    }
    // Initialization code
    
}

- (void)setUIWithModel:(MEGoodModel *)model{
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblSubtitle.text = kMeUnNilStr(model.title);
    [_imgProduct sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images))] placeholderImage:kImgPlaceholder];
    NSString *commStr = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.market_price).floatValue)];
    [_lblComPrice setLineStrWithStr:commStr];
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.money).floatValue)];
}

@end

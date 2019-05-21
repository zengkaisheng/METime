//
//  MENewHomeMainCell.m
//  ME时代
//
//  Created by hank on 2018/11/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MENewHomeMainCell.h"
#import "MEGoodModel.h"

@interface MENewHomeMainCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblComPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnAppoint;

@end

@implementation MENewHomeMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _consImgHeight.constant = 167 * kMeFrameScaleX();
    // Initialization code
}

- (void)setUIWithModel:(MEGoodModel *)model{
    _imgIcon.hidden = NO;
    _lblPrice.hidden = NO;
    _btnAppoint.hidden = YES;
    [_imgPic sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(model.image_rec))] placeholderImage:kImgPlaceholder];
    _lblComPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.market_price).floatValue)];
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.money).floatValue)];
    _lblTitle.text = kMeUnNilStr(model.title);
}

- (void)setServiceUIWithModel:(MEGoodModel *)model{
    _imgIcon.hidden = YES;
    _lblPrice.hidden = YES;
    _btnAppoint.hidden = NO;
    [_imgPic sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(model.image_rec))] placeholderImage:kImgPlaceholder];
    _lblComPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.market_price).floatValue)];
    _lblTitle.text = kMeUnNilStr(model.title);
}

+ (CGFloat)getCellHeight{
    CGFloat height = kMENewHomeMainCellHeight;
    return ((height-167)+(167 * kMeFrameScaleX()));
}

@end

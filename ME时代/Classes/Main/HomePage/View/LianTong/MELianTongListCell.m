//
//  MELianTongListCell.m
//  志愿星
//
//  Created by gao lei on 2019/9/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELianTongListCell.h"
#import "MEGoodModel.h"

@interface MELianTongListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *billLbl;

@end

@implementation MELianTongListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setUIWithModel:(MEGoodModel *)model{
    [_headerPic sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images))] placeholderImage:kImgPlaceholder];
    _titleLbl.text = kMeUnNilStr(model.title);
    _countLbl.text = [NSString stringWithFormat:@"已售出%@",@(model.sales)];
    _priceLbl.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.money).floatValue)];
    _billLbl.text = [NSString stringWithFormat:@"领 %@元话费",@(model.get_phone_bill)];
}

@end

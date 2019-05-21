//
//  MEShoppingCartCell.m
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShoppingCartCell.h"
#import "MEShoppingCartModel.h"

@interface MEShoppingCartCell()

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;//数量

@property (weak, nonatomic) IBOutlet UIButton *cutBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) MEShoppingCartModel *goodsModel;

@end

@implementation MEShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
//    _brandLabel.hidden = YES;
    _brandLabel.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWIthModel:(MEShoppingCartModel *)model{
    [self setGoodsModel:model];
}

//减
- (IBAction)cut:(UIButton *)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count--;
    if (count <= 0) {
        return;
    }
    
    kMeWEAKSELF
    [MEPublicNetWorkTool posteditCartNumWithShopCartId:_goodsModel.product_cart_id num:count successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSString *countStr = [NSString stringWithFormat:@"%ld", count];
        strongSelf.countLabel.text = countStr;
        kMeCallBlock(strongSelf.CutBlock,strongSelf.countLabel);
    } failure:^(id object) {
        
    }];
}

//加
- (IBAction)add:(UIButton *)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count++;
    if(count>_goodsModel.stock){
        [MEShowViewTool showMessage:@"库存不足" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool posteditCartNumWithShopCartId:_goodsModel.product_cart_id num:count successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSString *countStr = [NSString stringWithFormat:@"%ld", count];
        strongSelf.countLabel.text = countStr;
        kMeCallBlock(strongSelf.AddBlock,strongSelf.countLabel);
    } failure:^(id object) {
        
    }];
}

//选中
- (IBAction)click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"inc-gg"] forState:(UIControlStateNormal)];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:(UIControlStateNormal)];
    }
    kMeCallBlock(self.ClickRowBlock,sender.selected);
}

- (void)setGoodsModel:(MEShoppingCartModel *)goodsModel {
    _goodsModel = goodsModel;
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(goodsModel.images))] placeholderImage:kImgPlaceholder];
    self.clickBtn.selected = goodsModel.isSelect;
    if (goodsModel.isSelect) {
        [self.clickBtn setImage:[UIImage imageNamed:@"inc-gg"] forState:(UIControlStateNormal)];
    } else {
        [self.clickBtn setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:(UIControlStateNormal)];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld", goodsModel.goods_num];
    self.goodsNameLabel.text = goodsModel.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@元", goodsModel.money];
    _brandLabel.text = kMeUnNilStr(goodsModel.spec_name);
//    self.brandLabel.text = [NSString stringWithFormat:@"%@", goodsModel.shopName];
}

@end

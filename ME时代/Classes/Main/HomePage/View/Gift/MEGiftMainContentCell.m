//
//  MEGiftMainContentCell.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEGiftMainContentCell.h"
#import "MEShoppingCartModel.h"

@interface MEGiftMainContentCell (){
    MEShoppingCartModel *_goodsModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblSku;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;//数量
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation MEGiftMainContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWIthModel:(MEShoppingCartModel *)goodsModel{
    _goodsModel = goodsModel;
    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:MELoadQiniuImagesWithUrl(kMeUnNilStr(goodsModel.images))] placeholderImage:kImgPlaceholder];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", goodsModel.goods_num];
    self.goodsNameLabel.text = goodsModel.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@元", goodsModel.money];
    self.lblSku.text = kMeUnNilStr(goodsModel.spec_name);
}

//减
- (IBAction)cut:(UIButton *)sender {
    NSInteger count = [self.countLabel.text integerValue];
    count--;
    if (count <= 0) {
        NSString *strCartId =  @(_goodsModel.product_cart_id).description;
        [MEPublicNetWorkTool postDelGoodForShopWithMemberId:0 productCartId:strCartId successBlock:^(ZLRequestResponse *responseObject) {
           kNoticeReloadShopCart
        } failure:^(id object) {
            
        }];
    }else{
        kMeWEAKSELF
        [MEPublicNetWorkTool posteditCartNumWithShopCartId:_goodsModel.product_cart_id num:count successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            NSString *countStr = [NSString stringWithFormat:@"%ld", count];
            strongSelf.countLabel.text = countStr;
            kMeCallBlock(strongSelf.CutBlock,strongSelf.countLabel);
        } failure:^(id object) {
            
        }];
    }
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


@end

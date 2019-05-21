//
//  MEAddGoodBasicCell.m
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAddGoodBasicCell.h"
#import "MEAddGoodModel.h"
#import "MEBlockTextField.h"


@interface MEAddGoodBasicCell ()

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfSort;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfTitle;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfDesc;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfMarketPrice;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfMoney;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfPostage;


@property (nonatomic,strong) MEAddGoodModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btnGood;
@property (weak, nonatomic) IBOutlet UIButton *btnActive;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfCat;


@end

@implementation MEAddGoodBasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEAddGoodModel *)model{
    _model = model;
    if(self.model.store_product_type == 1){
        _btnGood.selected = YES;
        _btnActive.selected = NO;
    }else{
        _btnGood.selected = NO;
        _btnActive.selected = YES;
    }
    kMeWEAKSELF
    _tfSort.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.list_order = kMeUnNilStr(str);
    };
    _tfSort.text = kMeUnNilStr(self.model.list_order);
    
    _tfTitle.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.title = kMeUnNilStr(str);
    };
    _tfTitle.text = kMeUnNilStr(self.model.title);
    
    _tfDesc.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.desc = kMeUnNilStr(str);
    };
    _tfDesc.text = kMeUnNilStr(self.model.desc);
    
    _tfMarketPrice.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.market_price = kMeUnNilStr(str);
    };
    _tfMarketPrice.text = kMeUnNilStr(self.model.market_price);
    
    _tfMoney.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.money = kMeUnNilStr(str);
    };
    _tfMoney.text = kMeUnNilStr(self.model.money);
    
    _tfPostage.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.postage = kMeUnNilStr(str);
    };
    _tfPostage.text = kMeUnNilStr(self.model.postage);
    
    _tfCat.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.category = kMeUnNilStr(str);
    };
    _tfCat.text = kMeUnNilStr(self.model.category);
}

- (IBAction)goodAction:(UIButton *)sender {
    self.model.store_product_type = 1;
    _btnGood.selected = YES;
    _btnActive.selected = NO;
    kMeCallBlock(_selectType);
}

- (IBAction)actionAction:(UIButton *)sender {
    self.model.store_product_type = 7;
    _btnGood.selected = NO;
    _btnActive.selected = YES;
    kMeCallBlock(_selectType);
}
- (IBAction)goodSortAction:(UIButton *)sender {
    kMeCallBlock(_selectGoodType);

}

@end

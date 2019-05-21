//
//  MEAddGoodDivideCell.m
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAddGoodDivideCell.h"
#import "MEAddGoodModel.h"
#import "MEBlockTextField.h"

@interface MEAddGoodDivideCell ()

@property (weak, nonatomic) IBOutlet MEBlockTextField *tfSale;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfMarket;
@property (weak, nonatomic) IBOutlet MEBlockTextField *tfStore;
@property (nonatomic, strong) MEAddGoodModel *model;

@end

@implementation MEAddGoodDivideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setUIWithModel:(MEAddGoodModel *)model{
    _model = model;
    kMeWEAKSELF
    _tfSale.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.ratio_after_sales = kMeUnNilStr(str).floatValue;
    };
    _tfSale.text = @(_model.ratio_after_sales).description;
    
    _tfMarket.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.ratio_marketing = kMeUnNilStr(str).floatValue;
    };
    _tfMarket.text = @(_model.ratio_marketing).description;
    
    _tfStore.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        strongSelf.model.ratio_store = kMeUnNilStr(str).floatValue;
    };
    _tfStore.text = @(_model.ratio_store).description;
}

@end

//
//  MEGoodManngerCell.m
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEGoodManngerCell.h"
#import "MEGoodManngerModel.h"

@interface MEGoodManngerCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblGoodId;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblsort;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSaled;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;



@end

@implementation MEGoodManngerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUiWithModel:(MEGoodManngerModel *)model{
    _lblGoodId.text = [NSString stringWithFormat:@"商品ID:%@",kMeUnNilStr(model.product_id)];
    kSDLoadImg(_imgPic, kMeUnNilStr(model.images));
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblsort.text = kMeUnNilStr(model.category_name);
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.money).floatValue)];
    _lblSaled.text = [NSString stringWithFormat:@"销量:%@",kMeUnNilStr(model.sales)];
    _lblTime.text =[NSString stringWithFormat:@"创建时间:%@",kMeUnNilStr(model.updated_at)];
}

- (IBAction)delAction:(UIButton *)sender {
    kMeCallBlock(_delBlock);
}

@end

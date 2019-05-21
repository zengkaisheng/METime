//
//  MESkuBuyContentCell.m
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESkuBuyContentCell.h"
#import "MEGoodSpecModel.h"

@interface MESkuBuyContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end

@implementation MESkuBuyContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = kMESkuBuyContentCellHeight * 0.5;
    _lblContent.textColor = [UIColor whiteColor];
    _lblContent.backgroundColor = kMEUnSelect;
    _lblContent.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setmodelWithStr:(MEGoodSpecModel *)model isSelect:(BOOL)isSelect{
    _lblContent.text = kMeUnNilStr(model.spec_value);
    _lblContent.backgroundColor = isSelect ? kMEPink:kMEUnSelect;
    
}


@end

//
//  MEPreferentialCell.m
//  ME时代
//
//  Created by gao lei on 2019/6/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPreferentialCell.h"

@interface MEPreferentialCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;

@end


@implementation MEPreferentialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAmount:(NSString *)amount {
    _amountLbl.text = [NSString stringWithFormat:@"¥%@",amount.floatValue==0?@"0.0":amount];
}

- (void)setTitle:(NSString *)title amount:(NSString *)amount {
    _titleLbl.text = title.length>0?title:@"已优惠金额";
    _amountLbl.text = amount.floatValue==0?@"包邮":[NSString stringWithFormat:@"¥%@",amount];
}

@end

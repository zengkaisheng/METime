//
//  MEPreferentialCell.m
//  ME时代
//
//  Created by gao lei on 2019/6/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPreferentialCell.h"

@interface MEPreferentialCell ()

@property (weak, nonatomic) IBOutlet UILabel *amountLbl;

@end


@implementation MEPreferentialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAmount:(NSString *)amount {
    _amountLbl.text = [NSString stringWithFormat:@"¥%@",amount.length==0?@"0.0":amount];
}

@end

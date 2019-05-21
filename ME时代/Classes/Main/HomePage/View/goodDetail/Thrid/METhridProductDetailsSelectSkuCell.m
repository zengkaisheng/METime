//
//  METhridProductDetailsSelectSkuCell.m
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridProductDetailsSelectSkuCell.h"

@implementation METhridProductDetailsSelectSkuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblSku.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

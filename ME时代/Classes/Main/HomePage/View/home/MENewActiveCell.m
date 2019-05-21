//
//  MENewActiveCell.m
//  ME时代
//
//  Created by hank on 2018/11/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MENewActiveCell.h"

@implementation MENewActiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

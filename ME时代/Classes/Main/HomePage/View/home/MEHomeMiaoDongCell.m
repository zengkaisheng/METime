//
//  MEHomeMiaoDongCell.m
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEHomeMiaoDongCell.h"

@interface MEHomeMiaoDongCell(){
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consWdith;
@end

@implementation MEHomeMiaoDongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _consWdith.constant = 108 * kMeFrameScaleX();
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

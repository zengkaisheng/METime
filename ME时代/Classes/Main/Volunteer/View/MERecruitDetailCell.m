//
//  MERecruitDetailCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitDetailCell.h"

@interface MERecruitDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@end


@implementation MERecruitDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithContent:(NSString *)content {
    _detailLbl.text = kMeUnNilStr(content);
}

+ (CGFloat)getCellHeightWithContent:(NSString *)content {
    CGFloat height = 40;
    NSString *str = kMeUnNilStr(content);
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:12] width:(SCREEN_WIDTH-15-18-11-15) lineH:0 maxLine:0];
    if (titleHeight < 17) {
        height += 17;
    }else if (titleHeight > 17 && titleHeight <= 75) {
        height += titleHeight;
    }else {
        height += 75;
    }
    height += 9;
    return height;
}

@end

//
//  MEFilterMainCell.m
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEFilterMainCell.h"
#import "MEFilterMainModel.h"

@interface MEFilterMainCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblUnread;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;

@end

@implementation MEFilterMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEFilterMainModel *)model{
    _lblUnread.hidden = YES;
    _lblTitle.text = kMeUnNilStr(model.category_name);
}

- (void)setUnreadUIWithModel:(MEFilterMainModel *)model{
    _lblUnread.hidden = YES;
    _imgArrow.hidden = YES;
    _lblTitle.text = kMeUnNilStr(model.category_name);
    NSString *str = @(model.unRead).description;
    if(model.unRead>99){
        str = @"99+";
    }
    _lblUnread.hidden = model.unRead == 0;
    _lblUnread.text = [NSString stringWithFormat:@"%@",str];
}
@end

//
//  MENoticeCell.m
//  ME时代
//
//  Created by hank on 2018/11/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MENoticeCell.h"
#import "MENoticeModel.h"

@interface MENoticeCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *viewForUnread;


@end

@implementation MENoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWIthModel:(MENoticeModel *)model{
    _lblTitle.text = kMeUnNilStr(model.title);
    _lblTime.text = kMeUnNilStr(model.updated_at);
    _viewForUnread.hidden = model.is_read==2;
}

@end

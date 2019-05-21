//
//  MEDistrbutionMyTeamCell.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEDistrbutionMyTeamCell.h"
#import "MEDistributionTeamModel.h"

@interface MEDistrbutionMyTeamCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end

@implementation MEDistrbutionMyTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
}

- (void)setUIWithModel:(MEDistributionTeamModel *)model{
    kSDLoadImg(_imgPic, model.header_pic);
    _lblTitle.text = kMeUnNilStr(model.nick_name);
    _lblDate.text = kMeUnNilStr(model.created_at);
}

@end

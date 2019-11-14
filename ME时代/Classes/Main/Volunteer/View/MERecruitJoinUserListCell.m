//
//  MERecruitJoinUserListCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitJoinUserListCell.h"
#import "MERecruitDetailModel.h"
#import "MELoveListModel.h"

@interface MERecruitJoinUserListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;


@end

@implementation MERecruitJoinUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 9;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MERecruitJoinUserModel *)model {
    kSDLoadImg(_headerPic,kMeUnNilStr(model.header_pic));
    _nameLbl.text = kMeUnNilStr(model.nick_name);
    _timeLbl.text = kMeUnNilStr(model.join_time);
    _timeLbl.textColor = [UIColor colorWithHexString:@"#999999"];
}

- (void)setLoveListUIWithModel:(MELoveListModel *)model {
    kSDLoadImg(_headerPic,kMeUnNilStr(model.header_pic));
    _nameLbl.text = kMeUnNilStr(model.name);
    _timeLbl.text = [NSString stringWithFormat:@"%@小时",kMeUnNilStr(model.duration)];
    _timeLbl.textColor = kMEPink;
}

@end

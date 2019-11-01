//
//  MEPersonalCourseListCell.m
//  志愿星
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseListCell.h"
#import "MEPersonalCourseListModel.h"

@interface MEPersonalCourseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *playCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *vipLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsWidth;


@end

@implementation MEPersonalCourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (IS_iPhone5S) {
        _headerPicConsWidth.constant = 165;
    }else {
        _headerPicConsWidth.constant = 195;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MECourseListModel *)model {
    kSDLoadImg(_headerPic, kMeUnNilStr(model.courses_images));
    _nameLbl.text = kMeUnNilStr(model.name);
    _descLbl.text = kMeUnNilStr(model.desc);
    _playCountLbl.text = [NSString stringWithFormat:@"播放量:%@",kMeUnNilStr(model.study_num)];
    if (model.is_charge == 1) {
        _vipLbl.text = @"VIP";
    }else {
        _vipLbl.text = @"免费";
    }
}

@end

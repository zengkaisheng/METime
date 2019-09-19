//
//  MEPersonalCourseCell.m
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseCell.h"
#import "MEPersonalCourseListModel.h"

@interface MEPersonalCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *vipLbl;


@end


@implementation MEPersonalCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MECourseListModel *)model {
    kSDLoadImg(_headerPic, kMeUnNilStr(model.courses_images));
    _titleLbl.text = kMeUnNilStr(model.name);
    _descLbl.text = kMeUnNilStr(model.desc);
    _countLbl.text = [NSString stringWithFormat:@"已有%@人学习",@(model.browse+model.unreal_browse)];
    if (model.is_charge == 1) {
        _vipLbl.text = @"VIP";
    }else {
        _vipLbl.text = @"免费";
    }
}

@end

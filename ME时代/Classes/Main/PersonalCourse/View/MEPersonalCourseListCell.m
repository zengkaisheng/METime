//
//  MEPersonalCourseListCell.m
//  ME时代
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
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;
@property (weak, nonatomic) IBOutlet UILabel *reloadTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *playCountLbl;


@end

@implementation MEPersonalCourseListCell

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
    kSDLoadImg(_headerPic, kMeUnNilStr(model.images));
    _nameLbl.text = [NSString stringWithFormat:@"《%@》",kMeUnNilStr(model.name)];
    _descLbl.text = kMeUnNilStr(model.desc);
    _playCountLbl.text = [NSString stringWithFormat:@"%@人观看",kMeUnNilStr(model.study_num)];
}

@end

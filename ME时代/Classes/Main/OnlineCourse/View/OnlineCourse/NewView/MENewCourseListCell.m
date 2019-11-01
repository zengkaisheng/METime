//
//  MENewCourseListCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewCourseListCell.h"
#import "MEOnlineCourseListModel.h"

@interface MENewCourseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsHeight;


@end


@implementation MENewCourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEOnlineCourseListModel *)model {
    kSDLoadImg(_headerPic, kMeUnNilStr(model.images_url));
    
    if (kMeUnNilStr(model.video_name).length > 0) {
        _nameLbl.text = kMeUnNilStr(model.video_name);
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.video_price)];
    }else if (kMeUnNilStr(model.audio_name).length > 0) {
        _nameLbl.text = kMeUnNilStr(model.audio_name);
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.audio_price)];
    }
    _priceLbl.hidden = model.is_charge==2?YES:NO;
    _countLbl.text = [NSString stringWithFormat:@"%@次学习",@(model.browse)];
}

@end

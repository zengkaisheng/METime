//
//  MEFineCourseCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFineCourseCell.h"
#import "MEOnlineCourseListModel.h"

@interface MEFineCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end

@implementation MEFineCourseCell

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
        _descLbl.text = kMeUnNilStr(model.video_desc);
    }else if (kMeUnNilStr(model.audio_name).length > 0) {
        _nameLbl.text = kMeUnNilStr(model.audio_name);
        _descLbl.text = kMeUnNilStr(model.audio_desc);
    }
}

@end

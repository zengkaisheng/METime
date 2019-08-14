//
//  MEOnlineCourseListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseListCell.h"
#import "MEOnlineCourseListModel.h"

@interface MEOnlineCourseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageViewConsLeading;

@end

@implementation MEOnlineCourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEOnlineCourseListModel *)model isHomeVC:(BOOL)isHome {
    if (isHome) {
        _ImageViewConsLeading.constant = 9.0;
    }else {
        _ImageViewConsLeading.constant = 15.0;
    }
    
    kSDLoadImg(_headerPic, kMeUnNilStr(model.images_url));
    
    if (kMeUnNilStr(model.video_name).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.video_name);
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.video_price)];
    }else if (kMeUnNilStr(model.audio_name).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.audio_name);
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.audio_price)];
    }
    _priceLbl.hidden = model.is_charge==2?YES:NO;
    _learnCountLbl.text = [NSString stringWithFormat:@"%ld次学习",model.browse];
}

@end

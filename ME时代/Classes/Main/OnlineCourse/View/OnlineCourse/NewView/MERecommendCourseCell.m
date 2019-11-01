//
//  MERecommendCourseCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecommendCourseCell.h"
#import "MEOnlineCourseListModel.h"

@interface MERecommendCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *leftDescLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgViewConsHeight;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightDescLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImgViewConsHeight;

@end

@implementation MERecommendCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftImgViewConsHeight.constant = _rightImgViewConsHeight.constant = 96*kMeFrameScaleX();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithArray:(NSArray *)array {
    if (array.count <= 0) {
        return;
    }
    MEOnlineCourseListModel *model1 = array[0];
    kSDLoadImg(_leftImageView, kMeUnNilStr(model1.images_url));
    
    if (kMeUnNilStr(model1.video_name).length > 0) {
        _leftNameLbl.text = kMeUnNilStr(model1.video_name);
        _leftDescLbl.text = kMeUnNilStr(model1.video_desc);
    }else if (kMeUnNilStr(model1.audio_name).length > 0) {
        _leftNameLbl.text = kMeUnNilStr(model1.audio_name);
        _leftDescLbl.text = kMeUnNilStr(model1.audio_desc);
    }
    
    if (array.count >= 2) {
        MEOnlineCourseListModel *model2 = array[1];
        kSDLoadImg(_rightImageView, kMeUnNilStr(model2.images_url));
        
        if (kMeUnNilStr(model2.video_name).length > 0) {
            _rightNameLbl.text = kMeUnNilStr(model2.video_name);
            _rightDescLbl.text = kMeUnNilStr(model2.video_desc);
        }else if (kMeUnNilStr(model2.audio_name).length > 0) {
            _rightNameLbl.text = kMeUnNilStr(model2.audio_name);
            _rightDescLbl.text = kMeUnNilStr(model2.audio_desc);
        }
    }
}

- (IBAction)leftCourseAction:(id)sender {
    kMeCallBlock(_indexBlock,0);
}
- (IBAction)rightCourseAction:(id)sender {
    kMeCallBlock(_indexBlock,1);
}

@end

//
//  MENewCourseCell.m
//  ME时代
//
//  Created by gao lei on 2019/10/11.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewCourseCell.h"
#import "MEOnlineCourseListModel.h"

@interface MENewCourseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgViewConsHeight;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@end

@implementation MENewCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftImgViewConsHeight.constant = 200*kMeFrameScaleX();
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
    
//    if (kMeUnNilStr(model1.video_name).length > 0) {
//        _leftNameLbl.text = kMeUnNilStr(model1.video_name);
//        _leftDescLbl.text = kMeUnNilStr(model1.video_desc);
//    }else if (kMeUnNilStr(model1.audio_name).length > 0) {
//        _leftNameLbl.text = kMeUnNilStr(model1.audio_name);
//        _leftDescLbl.text = kMeUnNilStr(model1.audio_desc);
//    }
    
    if (array.count > 1) {
        MEOnlineCourseListModel *model2 = array[1];
        kSDLoadImg(_topImageView, kMeUnNilStr(model2.images_url));
    }
    if (array.count > 2) {
        MEOnlineCourseListModel *model3 = array[2];
        kSDLoadImg(_bottomImageView, kMeUnNilStr(model3.images_url));
    }
}

- (IBAction)leftCourseAction:(id)sender {
    kMeCallBlock(_indexBlock,0);
}

- (IBAction)topCourseAction:(id)sender {
    kMeCallBlock(_indexBlock,1);
}

- (IBAction)bottomCourseAction:(id)sender {
    kMeCallBlock(_indexBlock,2);
}

@end

//
//  MEOnlineCourseListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOnlineCourseListCell.h"
#import "MEOnlineCourseListModel.h"
#import "MEMyCollectionModel.h"

@interface MEOnlineCourseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *collectionDelBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImageViewConsLeading;

@end

@implementation MEOnlineCourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionDelBtn.hidden = YES;
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
        _descLbl.text = kMeUnNilStr(model.video_desc);
    }else if (kMeUnNilStr(model.audio_name).length > 0) {
        _titleLbl.text = kMeUnNilStr(model.audio_name);
        _priceLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.audio_price)];
        _descLbl.text = kMeUnNilStr(model.audio_desc);
    }
    _priceLbl.hidden = model.is_charge==2?YES:NO;
    _learnCountLbl.text = [NSString stringWithFormat:@"%ld次学习",model.browse];
}

- (void)setUIWithCollectionModel:(MEMyCollectionModel *)model {
    kSDLoadImg(_headerPic, kMeUnNilStr(model.c_images_url));
    _titleLbl.text = kMeUnNilStr(model.c_name);
    _priceLbl.text = @"";
    _learnCountLbl.text = @"";
    if (model.isEdit) {
        _collectionDelBtn.hidden = NO;
        _collectionDelBtn.selected = model.isSelected;
        _ImageViewConsLeading.constant = 30.0;
    }else {
        _collectionDelBtn.hidden = YES;
        _ImageViewConsLeading.constant = 15.0;
    }
    
}

@end

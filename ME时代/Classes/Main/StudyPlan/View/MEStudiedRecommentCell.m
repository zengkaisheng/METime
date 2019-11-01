//
//  MEStudiedRecommentCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEStudiedRecommentCell.h"
#import "MEStudiedHomeModel.h"
#import "MECareerCourseListModel.h"

@interface MEStudiedRecommentCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;

@end


@implementation MEStudiedRecommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 12;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEStudiedCourseModel *)model {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-30, 164*kMeFrameScaleX()) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 164*kMeFrameScaleX());
    maskLayer.path = maskPath.CGPath;
    _headerPic.layer.mask = maskLayer;
    
    _headerPicConsHeight.constant = 164*kMeFrameScaleX();
    kSDLoadImg(_headerPic, kMeUnNilStr(model.c_images_url));
    _titleLbl.text = kMeUnNilStr(model.c_name);
    _descLbl.hidden = NO;
    _descLbl.text = kMeUnNilStr(model.c_desc);
    _learnCountLbl.text = [NSString stringWithFormat:@"%@人已经学习",@(model.browse)];
    _likeCountLbl.text = [NSString stringWithFormat:@"%@",@(model.class_like_num)];
    if (model.is_like == 1) {
        _likeImageView.image = [UIImage imageNamed:@"icon_courseLike_sel"];
    }else {
        _likeImageView.image = [UIImage imageNamed:@"icon_courseLike_nor"];
    }
}

- (void)setCareerUIWithModel:(MECareerCourseListModel *)model {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH-30, 200*kMeFrameScaleX()) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 200*kMeFrameScaleX());
    maskLayer.path = maskPath.CGPath;
    _headerPic.layer.mask = maskLayer;
    
    _headerPicConsHeight.constant = 200*kMeFrameScaleX();
    kSDLoadImg(_headerPic, kMeUnNilStr(model.img_urls));
    _titleLbl.text = kMeUnNilStr(model.name);
    _descLbl.hidden = YES;
    _learnCountLbl.text = kMeUnNilStr(model.created_at);
    _likeCountLbl.text = [NSString stringWithFormat:@"%@",@(model.like)];
    if (model.is_like == 1) {
        _likeImageView.image = [UIImage imageNamed:@"icon_courseLike_sel"];
    }else {
        _likeImageView.image = [UIImage imageNamed:@"icon_courseLike_nor"];
    }
}

- (IBAction)courseLikeAction:(id)sender {
    kMeCallBlock(_likeCourseBlock);
}

@end

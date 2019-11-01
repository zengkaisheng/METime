//
//  MEPersionalCourseListCell.m
//  志愿星
//
//  Created by gao lei on 2019/9/16.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersionalCourseListCell.h"
#import "MEPersonalCourseListModel.h"

@interface MEPersionalCourseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *freeLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@end

@implementation MEPersionalCourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MECourseListModel *)model{
    kSDLoadImg(_headerPic, kMeUnNilStr(model.courses_images));
    _titleLbl.text = kMeUnNilStr(model.name);
    _descLbl.text = kMeUnNilStr(model.desc);
    _typeLbl.text = kMeUnNilStr(model.type_name);
    _freeLbl.text = kMeUnNilStr(model.charge_name);
    _countLbl.text = [NSString stringWithFormat:@"%@次学习",kMeUnNilStr(model.study_num)];
    if (model.is_charge == 1) {
        _descLbl.hidden = YES;
        _freeLbl.hidden = NO;
    }else {
        _descLbl.hidden = NO;
        _freeLbl.hidden = YES;
    }
    _typeLbl.hidden = NO;
    _freeLbl.backgroundColor = [UIColor colorWithHexString:@"#FE4B77"];
    _freeLbl.textColor = [UIColor whiteColor];
}

- (void)setPublicServiceUIWithModel:(MECourseListModel *)model {
    kSDLoadImg(_headerPic, kMeUnNilStr(model.courses_images));
    _titleLbl.text = kMeUnNilStr(model.name);
    _descLbl.text = kMeUnNilStr(model.desc);
//    _typeLbl.text = kMeUnNilStr(model.type_name);
    _freeLbl.text = kMeUnNilStr(model.charge_name);
    _countLbl.text = [NSString stringWithFormat:@"%@次学习",kMeUnNilStr(model.study_num)];
    
    _typeLbl.hidden = YES;
    _freeLbl.text = kMeUnNilStr(model.type_name);
    _freeLbl.backgroundColor = [UIColor clearColor];
    _freeLbl.textColor = [UIColor colorWithHexString:@"#2ED9A4"];
}

@end

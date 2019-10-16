//
//  MENewBCourseListCell.m
//  ME时代
//
//  Created by gao lei on 2019/10/15.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewBCourseListCell.h"
#import "MEStudiedHomeModel.h"

@interface MENewBCourseListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *browseLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation MENewBCourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEStudiedCourseModel *)model {
    kSDLoadImg(_headerPic, kMeUnNilStr(model.c_images_url));
    _titleLbl.text = kMeUnNilStr(model.c_name);
    _browseLbl.text = [NSString stringWithFormat:@"%@",@(model.browse)];
    if (kMeUnNilStr(model.study_time).length > 0) {
        _timeLbl.hidden = NO;
        _timeLbl.text = kMeUnNilStr(model.study_time);
    }else {
        _timeLbl.hidden = YES;
    }
}

@end

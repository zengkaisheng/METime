//
//  MEPersonalCourseFreeCell.m
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPersonalCourseFreeCell.h"
#import "MEPersonalCourseListModel.h"

@interface MEPersonalCourseFreeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftHeaderPic;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *leftDescLbl;
@property (weak, nonatomic) IBOutlet UILabel *LeftCountLbl;

@property (weak, nonatomic) IBOutlet UIImageView *rightHeaderPic;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightDescLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLbl;


@end

@implementation MEPersonalCourseFreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithArray:(NSArray *)array {
    for (id obj in array) {
        if (![obj isKindOfClass:[MECourseListModel class]]) {
            return;
        }
    }
    for (int i = 0; i < 2; i++) {
        MECourseListModel *model = (MECourseListModel *)array[i];
        if (i == 0) {
            kSDLoadImg(_leftHeaderPic, kMeUnNilStr(model.courses_images));
            _leftTitleLbl.text = kMeUnNilStr(model.name);
            _leftDescLbl.text = kMeUnNilStr(model.desc);
            _LeftCountLbl.text = [NSString stringWithFormat:@"%@人观看",kMeUnNilStr(model.study_num)];
        }else if (i == 1) {
            kSDLoadImg(_rightHeaderPic, kMeUnNilStr(model.courses_images));
            _rightTitleLbl.text = kMeUnNilStr(model.name);
            _rightDescLbl.text = kMeUnNilStr(model.desc);
            _rightCountLbl.text = [NSString stringWithFormat:@"%@人观看",kMeUnNilStr(model.study_num)];
        }
    }
}

- (IBAction)leftBtnAction:(id)sender {
    kMeCallBlock(_indexBlock,0);
}
- (IBAction)rightBtnAction:(id)sender {
    kMeCallBlock(_indexBlock,1);
}

@end

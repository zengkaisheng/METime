//
//  MECourseDetailListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseDetailListCell.h"

@interface MECourseDetailListCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *learnCountLbl;

@end


@implementation MECourseDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}
- (IBAction)playBtnAction:(id)sender {
}

@end

//
//  MECourseDetailCommentCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECourseDetailCommentCell.h"

@interface MECourseDetailCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation MECourseDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeightWithModel:(id)model {
    CGFloat height = [@"有帮助" boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
    return 10+25+9.5+height+5+15+3+20;
}

@end

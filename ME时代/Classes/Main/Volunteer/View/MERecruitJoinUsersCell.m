//
//  MERecruitJoinUsersCell.m
//  ME时代
//
//  Created by gao lei on 2019/10/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERecruitJoinUsersCell.h"
#import "MERecruitDetailModel.h"

@interface MERecruitJoinUsersCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;

@end


@implementation MERecruitJoinUsersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithModel:(MERecruitDetailModel *)model {
    _numberLbl.text = [NSString stringWithFormat:@"%@/%@",@(model.join_num),@(model.need_num)];
    
    for (id obj in _bgView.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *view = (UIImageView *)obj;
            if (view.tag >= 100) {
                [view removeFromSuperview];
            }
        }
    }
    CGFloat itemW = 26;
    for (int i = 0; i < model.join_users.count; i++) {
        MERecruitJoinUserModel *user = model.join_users[i];
        UIImageView *headerPic = [self creatreHeaderPicWithImage:kMeUnNilStr(user.header_pic) frame:CGRectMake(15+(itemW+14)*i, 42, itemW, itemW)];
        headerPic.tag = 100+i;
        [self.bgView addSubview:headerPic];
    }
}

- (UIImageView *)creatreHeaderPicWithImage:(NSString *)image frame:(CGRect)frame{
    UIImageView *headerPic = [[UIImageView alloc] initWithFrame:frame];
    kSDLoadImg(headerPic, kMeUnNilStr(image));
    headerPic.layer.cornerRadius = frame.size.width/2.0;
    return headerPic;
}

@end

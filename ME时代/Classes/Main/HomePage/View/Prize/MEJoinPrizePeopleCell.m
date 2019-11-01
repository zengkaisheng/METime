//
//  MEJoinPrizePeopleCell.m
//  志愿星
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEJoinPrizePeopleCell.h"
#import "MEPrizeDetailsModel.h"

@interface MEJoinPrizePeopleCell ()
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkAllBtn;
@property (weak, nonatomic) IBOutlet UIView *headerImgView;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailsBtn;

@end

@implementation MEJoinPrizePeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEPrizeDetailsModel *)model {
    _countLbl.text = [NSString stringWithFormat:@"已有%ld人参与",(long)model.join_number];
    _checkAllBtn.hidden = model.join_number<=0?YES:NO;
    for (UIView *view in _headerImgView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@" 点击查看图文详情" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    _checkDetailsBtn.titleLabel.attributedText = string;
    
    if (model.prizeLog.count > 0) {
        UIView *headerV = [self createHeaderPicViewWithArray:model.prizeLog];
        CGRect frame = headerV.frame;
        frame.origin.x = _headerImgView.frame.size.width - frame.size.width;
        frame.origin.y = (_headerImgView.frame.size.height - frame.size.height)/2;
        headerV.frame = frame;
        [_headerImgView addSubview:headerV];
    }
}

- (UIView *)createHeaderPicViewWithArray:(NSArray *)array {
    UIView *headerView = [[UIView alloc] init];
    
    CGFloat itemW = 29;
    CGFloat width = 0.0;
    if (array.count > 0) {
        NSInteger count = array.count>6?6:array.count;
        for (int i = 0; i < count; i++) {
            MEPrizeLogModel *logModel = array[i];
            UIImageView *headerPic = [[UIImageView alloc] init];
            headerPic.frame = CGRectMake((itemW-6)*i, 0, itemW, itemW);
            headerPic.backgroundColor = [UIColor colorWithHexString:@"#979797"];
            headerPic.layer.borderColor = [UIColor whiteColor].CGColor;
            headerPic.layer.borderWidth = 2;
            headerPic.layer.cornerRadius = itemW/2.0;
            headerPic.layer.masksToBounds = YES;
            kSDLoadImg(headerPic, logModel.header_pic);
            if (i == count - 1) {
                width = (itemW-6)*i + itemW;
            }
            [headerView addSubview:headerPic];
        }
    }
    headerView.frame = CGRectMake(0, 0, width, itemW);
    return headerView;
}

- (IBAction)checkAllAction:(id)sender {
    if (self.checkAllBlock) {
        self.checkAllBlock();
    }
}
- (IBAction)checkDetailAction:(id)sender {
    if (self.checkDetailBlock) {
        self.checkDetailBlock();
    }
}

@end

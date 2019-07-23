//
//  MEPublishPrizeCell.m
//  ME时代
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEPublishPrizeCell.h"
#import "MEPrizeDetailsModel.h"

@interface MEPublishPrizeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *prizeMessageLbl;
@property (weak, nonatomic) IBOutlet UIView *luckyView;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkAllBtn;
@property (weak, nonatomic) IBOutlet UIView *headerPicView;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLblConsLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *luckyViewConsHeight;


@end


@implementation MEPublishPrizeCell

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
    _countLbl.text = [NSString stringWithFormat:@"感谢%ld人参与",(long)model.join_number];
    _checkAllBtn.hidden = model.join_number<=0?YES:NO;
    
    if (model.join_type == 3) {
        _topImgView.image = [UIImage imageNamed:@"winPrize"];
        _prizeMessageLbl.text = @"中奖啦！";
    }else if (model.join_type == 4) {
        _topImgView.image = [UIImage imageNamed:@"noPrize"];
        _prizeMessageLbl.text = @"未中奖";
    }else if (model.join_type == 5) {
        _topImgView.image = [UIImage imageNamed:@"winPrize"];
        _prizeMessageLbl.text = @"已领取";
    }
    
    for (UIView *view in _headerPicView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in _luckyView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@" 点击查看图文详情" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    _checkDetailBtn.titleLabel.attributedText = string;
    //中奖人数
    NSArray *array = model.lucky;
    if (array.count > 0) {
        _luckyViewConsHeight.constant = 71;
        
        NSInteger count = array.count>4?4:array.count;
        CGFloat width = (SCREEN_WIDTH - 80)/4;
        for (int i = 0; i < count; i++) {
            MEPrizeLogModel *logModel = array[i];
            UIView *view;
            if (i == 3) {
                view = [self createViewWithImage:@"icon_prizeMore" title:@"查看全部" frame:CGRectMake(width * i, 0, width, 71) showCrown:NO showInvite:NO];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = view.frame;
                [btn addTarget:self action:@selector(checkAllAction) forControlEvents:UIControlEventTouchUpInside];
                [_luckyView addSubview:view];
                [_luckyView addSubview:btn];
            }else {
                BOOL isShowCrown = NO;
                if (i == 0) {
                    isShowCrown = YES;
                }
                BOOL showInvite = NO;
                if (logModel.oneself == 1) {
                    showInvite = NO;
                }else {
                    if (logModel.is_friend == 1) {
                        showInvite = YES;
                    }
                }
                
                view = [self createViewWithImage:logModel.header_pic title:logModel.name frame:CGRectMake(width * i, 0, width, 71) showCrown:isShowCrown showInvite:showInvite];
                [_luckyView addSubview:view];
            }
        }
    }else {
        _luckyViewConsHeight.constant = 0;
    }
    
    //参与人数
    if (model.prizeLog.count > 0) {
        _countLblConsLeading.constant = 96;
        _checkAllBtn.hidden = NO;
        
        UIView *headerV = [self createHeaderPicViewWithArray:model.prizeLog];
        CGRect frame = headerV.frame;
        frame.origin.x = (_headerPicView.frame.size.width - frame.size.width)/2;
        frame.origin.y = (_headerPicView.frame.size.height - frame.size.height)/2;
        headerV.frame = frame;
        [_headerPicView addSubview:headerV];
    }else {
        NSString *string = @"感谢0人参与";
        CGSize size = [string boundingRectWithSize:CGSizeMake(300, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        _countLblConsLeading.constant = (SCREEN_WIDTH - size.width-16)/2;
        _checkAllBtn.hidden = YES;
    }
}

- (UIView *)createViewWithImage:(NSString *)image title:(NSString *)title frame:(CGRect)frame showCrown:(BOOL)showCrown showInvite:(BOOL)showInvite{
    //71
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.frame = CGRectMake((frame.size.width - 31)/2, 10, 31, 31);
    imgV.layer.cornerRadius = 31/2.0;
    if ([title isEqualToString:@"查看全部"]) {
        imgV.image = [UIImage imageNamed:image];
    }else {
        kSDLoadImg(imgV, image);
    }
    [view addSubview:imgV];
    
    if (showCrown) {
        UIImageView *crownImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_crown"]];
        crownImg.frame = CGRectMake((frame.size.width - 31)/2 - 8, 0, 18, 18);
        [view addSubview:crownImg];
    }
    
    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.frame = CGRectMake(0, 51, frame.size.width, 10);
    nameLbl.text = title;
    nameLbl.font = [UIFont systemFontOfSize:10];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    if ([title isEqualToString:@"查看全部"]) {
        nameLbl.textColor = [UIColor colorWithHexString:@"#217ABB"];
    }else {
        nameLbl.textColor = [UIColor colorWithHexString:@"#646464"];
    }
    [view addSubview:nameLbl];
    
    if (showInvite) {
        UILabel *inviteLbl = [[UILabel alloc] init];
        inviteLbl.frame = CGRectMake(0, 64, frame.size.width, 8);
        inviteLbl.text = @"邀请奖励X1";
        inviteLbl.font = [UIFont systemFontOfSize:7];
        inviteLbl.textAlignment = NSTextAlignmentCenter;
        inviteLbl.textColor = [UIColor colorWithHexString:@"#F23E2E"];
        [view addSubview:inviteLbl];
    }
    
    return view;
}

- (UIView *)createHeaderPicViewWithArray:(NSArray *)array {
    UIView *headerView = [[UIView alloc] init];
    
    CGFloat itemW = 31;
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

- (void)checkAllAction {
    if (self.checkAllBlock) {
        self.checkAllBlock(0);
    }
}

- (IBAction)checkAllAction:(id)sender {
    if (self.checkAllBlock) {
        self.checkAllBlock(1);
    }
}
- (IBAction)CheckDetailAction:(id)sender {
    if (self.checkDetailBlock) {
        self.checkDetailBlock();
    }
}

@end

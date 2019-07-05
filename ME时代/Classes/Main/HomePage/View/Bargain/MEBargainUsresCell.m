//
//  MEBargainUsresCell.m
//  ME时代
//
//  Created by gao lei on 2019/7/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainUsresCell.h"
#import "MEBargainDetailModel.h"

@interface MEBargainUsresCell ()
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UIButton *checkMoreBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end


@implementation MEBargainUsresCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEBargainDetailModel *)model {
    for (UIView *view in self.BGView.subviews) {
        if (view.tag >= 100) {
            [view removeFromSuperview];
        }
    }
    
    if (model.bargin_user.count == 3) {
        [_checkMoreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_checkMoreBtn setImage:[UIImage imageNamed:@"icon_arrow_red"] forState:UIControlStateNormal];
        [_checkMoreBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:7];
        _checkMoreBtn.enabled = YES;
    }else {
        [_checkMoreBtn setTitle:@"人多力量大,快喊小伙伴们来帮忙" forState:UIControlStateNormal];
        [_checkMoreBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _checkMoreBtn.enabled = NO;
    }
    for (int i = 0; i < model.bargin_user.count; i++) {
        MEBargainUserModel *subModel = model.bargin_user[i];
        UIView *subView = [self createSubViewWithUserModel:subModel frame:CGRectMake(0, 54+49*i, self.frame.size.width-30, 49) tag:100+i];
        [self.BGView addSubview:subView];
    }
    //绘制虚线
    [self createShapeLine];
}

- (void)createShapeLine {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, self.frame.size.width-30-36, 1)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色
    [shapeLayer setStrokeColor:[UIColor colorWithHexString:@"#D8D8D8"].CGColor];
    //设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置虚线的线宽及间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil]];
    //创建虚线绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置虚线绘制路径起点
    CGPathMoveToPoint(path, NULL, 0, 0);
    //设置虚线绘制路径终点
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    //设置虚线绘制路径
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //添加虚线
    [lineView.layer addSublayer:shapeLayer];
    [self.bottomView addSubview:lineView];
}

- (UIView *)createSubViewWithUserModel:(MEBargainUserModel*)userModel frame:(CGRect)frame tag:(NSInteger)tag {
    UIView *subView = [[UIView alloc] initWithFrame:frame];
    subView.tag = tag;
    //头像
    UIImageView *headerPic = [[UIImageView alloc] initWithFrame:CGRectMake(18, 0, 36, 36)];
    kSDLoadImg(headerPic, kMeUnNilStr(userModel.header_pic));
    headerPic.layer.cornerRadius = 18;
    [subView addSubview:headerPic];
    //name
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerPic.frame)+9, 9, frame.size.width-CGRectGetMaxX(headerPic.frame)-9-100-18, 13)];
    nameLbl.text = kMeUnNilStr(userModel.nick_name);
    nameLbl.font = [UIFont systemFontOfSize:13];
    [subView addSubview:nameLbl];
    //content
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerPic.frame)+9, 9+13+4, 130, 11)];
    contentLbl.text = kMeUnNilStr(userModel.tip);
    contentLbl.font = [UIFont systemFontOfSize:11];
    contentLbl.textColor = kME999999;
    [subView addSubview:contentLbl];
    //content
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-18-100, 11, 100, 15)];
    priceLbl.text = [NSString stringWithFormat:@"砍掉%@元",kMeUnNilStr(userModel.bargin_money)];
    priceLbl.font = [UIFont systemFontOfSize:15];
    priceLbl.textColor = [UIColor colorWithHexString:@"#FE5337"];
    priceLbl.textAlignment = NSTextAlignmentRight;
    [subView addSubview:priceLbl];
    
    return subView;
}

- (IBAction)moreAction:(id)sender {
    if (self.moreBlock) {
        self.moreBlock(YES);
    }
}

+ (CGFloat)getCellHeightWithArray:(NSArray *)array showMore:(BOOL)isShow {
    CGFloat height = 54+47;
    if (array.count <= 0) {
        return 0;
    }else {
        height += 49 * array.count;
    }
    return height;
}

@end

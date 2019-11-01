//
//  MEWaitPublishPrizeCell.m
//  志愿星
//
//  Created by gao lei on 2019/6/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEWaitPublishPrizeCell.h"
#import "MEPrizeDetailsModel.h"

@interface MEWaitPublishPrizeCell ()
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *inviteBGView;
@property (weak, nonatomic) IBOutlet UIView *headerPicView;
@property (weak, nonatomic) IBOutlet UIImageView *enptyImgView;

@end

@implementation MEWaitPublishPrizeCell

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
    _inviteBtn.backgroundColor = [UIColor colorWithHexString:@"#FD4736"];
    _inviteBtn.layer.shadowColor = [UIColor colorWithRed:254/255.0 green:85/255.0 blue:68/255.0 alpha:0.9].CGColor;
    _inviteBtn.layer.shadowOffset = CGSizeMake(0,3);
    _inviteBtn.layer.shadowOpacity = 1;
    _inviteBtn.layer.shadowRadius = 7;
    _inviteBtn.layer.cornerRadius = 4;
    
    _shareBtn.backgroundColor = [UIColor colorWithHexString:@"#FFB540"];
    _shareBtn.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:183/255.0 blue:65/255.0 alpha:0.9].CGColor;
    _shareBtn.layer.shadowOffset = CGSizeMake(0,3);
    _shareBtn.layer.shadowOpacity = 1;
    _shareBtn.layer.shadowRadius = 7;
    _shareBtn.layer.cornerRadius = 4;
    
    _inviteBGView.layer.borderColor = kMEf5f4f4.CGColor;
    _inviteBGView.layer.borderWidth = 1.0;
    _inviteBGView.layer.cornerRadius = 4;
    
    NSArray *array = model.inviteLog;
    if (array.count > 0) {
        _enptyImgView.hidden = YES;
        NSInteger count = model.inviteNum>4?4:array.count;
        CGFloat width = (SCREEN_WIDTH - 46)/4;
        for (int i = 0; i < count; i++) {
            
            UIView *view;
            if (i < array.count) {
                MEPrizeLogModel *logModel = array[i];
                view = [self createViewWithImage:logModel.header_pic title:logModel.name frame:CGRectMake(width * i, 25, width, 54)];
                [_headerPicView addSubview:view];
            }else {
                if (i == 3 && model.inviteNum > 4) {
                    view = [self createViewWithImage:@"icon_prizeMore" title:@"查看全部" frame:CGRectMake(width * i, 25, width, 54)];
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = view.frame;
                    [btn addTarget:self action:@selector(checkAllAction) forControlEvents:UIControlEventTouchUpInside];
                    [_headerPicView addSubview:view];
                    [_headerPicView addSubview:btn];
                }
            }
        }
    }else {
        _enptyImgView.hidden = NO;
    }
}

- (UIView *)createViewWithImage:(NSString *)image title:(NSString *)title frame:(CGRect)frame{
    //53
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.frame = CGRectMake((frame.size.width - 32)/2, 0, 32, 32);
    imgV.layer.cornerRadius = 16;
    if ([title isEqualToString:@"查看全部"]) {
        imgV.image = [UIImage imageNamed:image];
    }else {
        kSDLoadImg(imgV, image);
    }
    [view addSubview:imgV];
    
    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.frame = CGRectMake(0, 43, frame.size.width, 10);
    nameLbl.text = title;
    nameLbl.font = [UIFont systemFontOfSize:10];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    nameLbl.textColor = [UIColor colorWithHexString:@"#646464"];
    [view addSubview:nameLbl];
    
    return view;
}

- (void)checkAllAction {
    if (self.checkBlock) {
        self.checkBlock();
    }
}

- (IBAction)intiveAction:(id)sender {
    if (self.indexBlock) {
        self.indexBlock(0);
    }
}
- (IBAction)shareAction:(id)sender {
    if (self.indexBlock) {
        self.indexBlock(1);
    }
}

@end

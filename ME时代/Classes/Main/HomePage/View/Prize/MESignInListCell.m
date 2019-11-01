//
//  MESignInListCell.m
//  志愿星
//
//  Created by gao lei on 2019/6/18.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESignInListCell.h"
#import "MEPrizeListModel.h"

@interface MESignInListCell ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *automicBtn;
@property (weak, nonatomic) IBOutlet UIButton *prizeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;

@end

@implementation MESignInListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEPrizeListModel *)model {
    kSDLoadImg(_headerImgV, kMeUnNilStr(model.image));
    _sdView.hidden = YES;
    
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.delegate = self;
    _sdView.infiniteLoop = NO;
    _sdView.autoScroll = NO;
    _sdView.imageURLStringsGroup = @[model.image];
//    _sdView.autoScrollTimeInterval = 4;
    
    _titleLbl.text = model.title;
    _countLbl.text = [NSString stringWithFormat:@"份数%ld",(long)model.total];
    _timeLbl.text = [NSString stringWithFormat:@"开奖时间 %@",model.open_time];
    
    if (model.status == 1) {
        _automicBtn.hidden = NO;
    }else if (model.status == 2) {
        _automicBtn.hidden = YES;
    }
    switch (model.type) {
        case 1:
        {//未参加
            [_prizeBtn setTitle:@"参加抽奖" forState:UIControlStateNormal];
            [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#F03D38"]];
        }
            break;
        case 2:
        {//等待开奖
            [_prizeBtn setTitle:@"等待开奖" forState:UIControlStateNormal];
            [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#F03D38"]];
        }
            break;
        case 3:
        {//中奖(待领取)
            [_prizeBtn setTitle:@"领取奖品" forState:UIControlStateNormal];
            [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#F03D38"]];
        }
            break;
        case 4:
        {//未中奖
            [_prizeBtn setTitle:@"已结束" forState:UIControlStateNormal];
            [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
        }
            break;
        case 5:
        {//已领取
            [_prizeBtn setTitle:@"已领取" forState:UIControlStateNormal];
            [_prizeBtn setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
        }
            break;
        default:
            break;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedIndexBlock,index);
}

- (IBAction)drawAction:(id)sender {
//    NSLog(@"点击了参与抽奖按钮");
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end

//
//  MEOperationCountCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEOperationCountCell.h"
#import "MEOperateDataModel.h"

@interface MEOperationCountCell ()

@property (weak, nonatomic) IBOutlet UILabel *topLeftNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *topLeftTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *topCenterNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *topCenterTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *topRightNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *topRightTitleLbl;

@property (weak, nonatomic) IBOutlet UILabel *bottomLeftNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomCenterNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomCenterTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightTitleLbl;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *bgLeftNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *bgLeftTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bgRightNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *bgRightTitleLbl;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation MEOperationCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUpWithModel:(MEOperateDataSubModel *)model type:(NSInteger)type {
    switch (type) {
        case 1:
        {
            _bgView.hidden = YES;
            _topLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.top_up_total)];
            _topLeftTitleLbl.text = @"总充值";
            
            _topCenterNumLbl.text = [NSString stringWithFormat:@"%@",@(model.balance_total)];
            _topCenterTitleLbl.text = @"总余额";
            
            _topRightNumLbl.text = [NSString stringWithFormat:@"%@",@(model.customer_total)];
            _topRightTitleLbl.text = @"顾客数";
            
            _bottomLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.oject_total)];
            _bottomLeftTitleLbl.text = @"总项目次数";
            
            _bottomCenterNumLbl.text = kMeUnNilStr(model.give_num_total);
            _bottomCenterTitleLbl.text = @"赠送次数";
            
            _topLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.customer_classify_total)];
            _topLeftTitleLbl.text = @"顾客各分类数";
        }
            break;
        case 2:
        {
            _bgView.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = YES;
            
            _bgLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.performance)];
            _bgLeftTitleLbl.text = @"本月业绩";
            _bgLeftNumLbl.textColor = _bgLeftTitleLbl.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
            
            _bgRightNumLbl.text = [NSString stringWithFormat:@"%@",@(model.expense)];
            _bgRightTitleLbl.text = @"本月消耗";
            _bgRightNumLbl.textColor = _bgRightTitleLbl.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
            
            _bottomLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.object_num)];
            _bottomLeftTitleLbl.text = @"项目数";
            
            _bottomCenterNumLbl.text = [NSString stringWithFormat:@"%@",@(model.customer_num)];
            _bottomCenterTitleLbl.text = @"客次数";
            
            _topLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.workmanship_charge)];
            _topLeftTitleLbl.text = @"手工费";
        }
            break;
        case 3:
        {
            _bgView.hidden = NO;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            
            _bgLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.customer_num)];
            _bgLeftTitleLbl.text = @"今日顾客总人次";
            _bgLeftNumLbl.textColor = _bgLeftTitleLbl.textColor = [UIColor colorWithHexString:@"#540115"];
            
            _bgRightNumLbl.text = [NSString stringWithFormat:@"%@",@(model.workmanship_charge)];
            _bgRightTitleLbl.text = @"今日手工费总数";
            _bgRightNumLbl.textColor = _bgRightTitleLbl.textColor = [UIColor colorWithHexString:@"#540115"];
            
            _bottomLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.this_month_customer_num)];
            _bottomLeftTitleLbl.text = @"月顾客预约累计总数";
            
            _bottomCenterNumLbl.text = [NSString stringWithFormat:@"%@",@(model.this_day_customer_num)];
            _bottomCenterTitleLbl.text = @"今日顾客数量占比";
            
            _topLeftNumLbl.text = [NSString stringWithFormat:@"%@",@(model.this_month_workmanship_charge)];
            _topLeftTitleLbl.text = @"月手工费总数";
        }
            break;
        default:
            break;
    }
}

- (IBAction)leftBtnAction:(id)sender {
    kMeCallBlock(self.indexBlock,0);
}
- (IBAction)rightBtnAction:(id)sender {
    kMeCallBlock(self.indexBlock,1);
}

@end

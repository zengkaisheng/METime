//
//  MEServiceCardCell.m
//  志愿星
//
//  Created by gao lei on 2019/8/25.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEServiceCardCell.h"
#import "MECustomerServiceDetailModel.h"
#import "MECustomerExpenseDetailModel.h"

@interface MEServiceCardCell ()

@property (weak, nonatomic) IBOutlet UILabel *topTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *centerTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLbl;

@property (weak, nonatomic) IBOutlet UILabel *topValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *centerValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomValueLbl;

@end

@implementation MEServiceCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithServiceModel:(MEServiceDetailSubModel *)model index:(NSInteger)index{
    switch (model.type) {
        case 1:
        {
            _topTitleLbl.text = @"项目名称";
            _centerTitleLbl.text = @"总次数";
            _bottomTitleLbl.text = @"剩余次数";
            
            _topValueLbl.text = kMeUnNilStr(model.service_name);
            _centerValueLbl.text = [NSString stringWithFormat:@"%@次",@(model.total_num)];
            _bottomValueLbl.text = [NSString stringWithFormat:@"%@次",@(model.residue_num)];
        }
            break;
        case 2:
        {
            _topTitleLbl.text = @"项目名称";
            _centerTitleLbl.text = @"开卡时间";
            _bottomTitleLbl.text = @"剩余时间";
            
            _topValueLbl.text = kMeUnNilStr(model.service_name);
            _centerValueLbl.text = kMeUnNilStr(model.open_card_time);
            _bottomValueLbl.text = kMeUnNilStr(model.residue_time);
        }
            break;
        case 3:
        {
            _topTitleLbl.text = @"套盒产品名称";
            _centerTitleLbl.text = @"服务次数";
            _bottomTitleLbl.text = @"剩余次数";
            
            _topValueLbl.text = kMeUnNilStr(model.service_name);
            _centerValueLbl.text = [NSString stringWithFormat:@"%@次",@(model.total_num)];
            _bottomValueLbl.text = [NSString stringWithFormat:@"%@次",@(model.residue_num)];
        }
            break;
        default:
            break;
    }
}

- (void)setUIWithExpenseModel:(MEExpenseDetailSubModel *)model {
    switch (model.type) {
        case 4:
        {
            _topTitleLbl.text = @"充值时间";
            _centerTitleLbl.text = @"充值金额";
            _bottomTitleLbl.hidden = YES;
            
            _topValueLbl.text = kMeUnNilStr(model.created_at);
            _centerValueLbl.text = [NSString stringWithFormat:@"%@元",@(model.money)];
            _bottomValueLbl.hidden = YES;
        }
            break;
        case 1:
        {
            _topTitleLbl.text = @"消费时间";
            _centerTitleLbl.text = @"项目名称";
            _bottomTitleLbl.text = @"消费金额";
            
            _topValueLbl.text = kMeUnNilStr(model.created_at);
            _centerValueLbl.text = kMeUnNilStr(model.name);
            _bottomValueLbl.text = [NSString stringWithFormat:@"%@元",@(model.money)];
        }
            break;
        case 2:
        {
            _topTitleLbl.text = @"开卡时间";
            _centerTitleLbl.text = @"项目名称";
            _bottomTitleLbl.text = @"消费金额";
            
            _topValueLbl.text = kMeUnNilStr(model.created_at);
            _centerValueLbl.text = kMeUnNilStr(model.name);
            _bottomValueLbl.text = [NSString stringWithFormat:@"%@元",@(model.money)];
        }
            break;
        case 3:
        {
            _topTitleLbl.text = @"消费时间";
            _centerTitleLbl.text = @"项目名称";
            _bottomTitleLbl.text = @"消费金额";
            
            _topValueLbl.text = kMeUnNilStr(model.created_at);
            _centerValueLbl.text = kMeUnNilStr(model.name);
            _bottomValueLbl.text = [NSString stringWithFormat:@"%@元",@(model.money)];
        }
            break;
        default:
            break;
    }
}

@end

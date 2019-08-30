//
//  MERankingListCell.m
//  ME时代
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERankingListCell.h"
#import "MEOperationClerkRankModel.h"
#import "MEOperationObjectRankModel.h"

@interface MERankingListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLblConsLeading;

@end

@implementation MERankingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setUIWithClerkModel:(MEOperationClerkRankModel *)model index:(NSInteger)index {
    _headerImgV.hidden = YES;
    _nameLblConsLeading.constant = 30.0;
    _nameLbl.text = kMeUnNilStr(model.name);
    _numberLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//    if (index == 0 || index == 1) {
//        _numberLbl.text = [NSString stringWithFormat:@"%@",@(model.money)];
//    }
}

- (void)setUIWithObjectRankModel:(MEOperationObjectRankModel *)model index:(NSInteger)index {
    if (index < 4) {
        _headerImgV.hidden = NO;
        _nameLblConsLeading.constant = 54.5;
        switch (index) {
            case 1:
            {
                _headerImgV.image = [UIImage imageNamed:@"icon_gold"];
            }
                break;
            case 2:
            {
                _headerImgV.image = [UIImage imageNamed:@"icon_silver"];
            }
                break;
            case 3:
            {
                _headerImgV.image = [UIImage imageNamed:@"icon_brass"];
            }
                break;
            default:
                break;
        }
        _nameLbl.text = kMeUnNilStr(model.name);
        _numberLbl.text = [NSString stringWithFormat:@"%@",@(model.total_money)];
    }else {
        _headerImgV.hidden = YES;
        _nameLblConsLeading.constant = 30.0;
        _nameLbl.text = [NSString stringWithFormat:@"%ld、%@",index,kMeUnNilStr(model.name)];
        _numberLbl.text = [NSString stringWithFormat:@"%@",@(model.total_money)];
    }
}

@end

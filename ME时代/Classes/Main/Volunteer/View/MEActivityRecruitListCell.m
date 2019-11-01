//
//  MEActivityRecruitListCell.m
//  志愿星
//
//  Created by gao lei on 2019/10/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEActivityRecruitListCell.h"
#import "MERecruitListModel.h"

@interface MEActivityRecruitListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *areaLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;

@end


@implementation MEActivityRecruitListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 3;
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

- (void)setUIWithModel:(MERecruitListModel *)model {
    kSDLoadImg(_imageV, kMeUnNilStr(model.image));
    _titleLbl.text = kMeUnNilStr(model.title);
    _distanceLbl.text = kMeUnNilStr(model.distance);
    _areaLbl.text = kMeUnNilStr(model.area);
    _numberLbl.text = [NSString stringWithFormat:@"%@/%@",@(model.join_num),@(model.need_num)];
}

@end

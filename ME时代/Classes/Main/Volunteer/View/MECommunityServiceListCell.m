//
//  MECommunityServiceListCell.m
//  ME时代
//
//  Created by gao lei on 2019/10/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommunityServiceListCell.h"
#import "MECommunityServericeListModel.h"

@interface MECommunityServiceListCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end

@implementation MECommunityServiceListCell

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

- (void)setUIWithModel:(MECommunityServericeListModel *)model {
    _titleLbl.text = kMeUnNilStr(model.title);
    NSArray *timeArr = [kMeUnNilStr(model.created_at) componentsSeparatedByString:@" "];
    _timeLbl.text = [NSString stringWithFormat:@"%@%@",kMeUnNilStr(model.address),kMeUnNilStr(timeArr.firstObject)];
    if (kMeUnArr(model.images).count <= 0) {
        _leftImageView.hidden = _centerImageView.hidden = _rightImageView.hidden = YES;
    }else {
        _leftImageView.hidden = NO;
        if (kMeUnArr(model.images).count == 1) {
            _centerImageView.hidden = _rightImageView.hidden = YES;
            kSDLoadImg(_leftImageView, kMeUnNilStr(model.images.firstObject));
        }else if (kMeUnArr(model.images).count == 2) {
            _centerImageView.hidden = NO;
            _rightImageView.hidden = YES;
            kSDLoadImg(_leftImageView, kMeUnNilStr(model.images.firstObject));
            kSDLoadImg(_centerImageView, kMeUnNilStr(model.images[1]));
        }else if (kMeUnArr(model.images).count > 2) {
            _centerImageView.hidden = _rightImageView.hidden = NO;
            kSDLoadImg(_leftImageView, kMeUnNilStr(model.images.firstObject));
            kSDLoadImg(_centerImageView, kMeUnNilStr(model.images[1]));
            kSDLoadImg(_rightImageView, kMeUnNilStr(model.images[2]));
        }
    }
}

@end

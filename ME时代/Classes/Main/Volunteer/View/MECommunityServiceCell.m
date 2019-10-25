//
//  MECommunityServiceCell.m
//  ME时代
//
//  Created by gao lei on 2019/10/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommunityServiceCell.h"
#import "MECommunityServericeListModel.h"

@interface MECommunityServiceCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation MECommunityServiceCell

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
        _imageV.hidden = YES;
    } else {
        _imageV.hidden = NO;
        kSDLoadImg(_imageV, kMeUnNilStr(model.images.firstObject));
    }
}

@end

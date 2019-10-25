//
//  MECommunityServiceDetailCell.m
//  ME时代
//
//  Created by gao lei on 2019/10/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECommunityServiceDetailCell.h"
#import "MECommunityServericeListModel.h"

@interface MECommunityServiceDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;


@end

@implementation MECommunityServiceDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
}

@end

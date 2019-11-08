//
//  MEAttentionOrganizationCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAttentionOrganizationCell.h"
#import "MEVolunteerInfoModel.h"
#import "MEAttentionOrganizationsModel.h"

@interface MEAttentionOrganizationCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageV;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *durationTipLbl;
@property (weak, nonatomic) IBOutlet UILabel *organizersNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *organizersNumTipLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationImgConsW;

@end

@implementation MEAttentionOrganizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.16].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
    
    self.cancelBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)setOrganizationUIWithModel:(MEAttentionOrganizationsModel *)model {
    _cancelBtn.hidden = YES;
    _locationImgConsW.constant = 18;
    _locationImageV.hidden = NO;
    _durationLbl.hidden = _durationTipLbl.hidden = _organizersNumLbl.hidden = _organizersNumTipLbl.hidden = NO;
    
    _nameLbl.text = kMeUnNilStr(model.org_name);
    _contentLbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.county),kMeUnNilStr(model.address)];
    _durationLbl.text = kMeUnNilStr(model.duration);
    _organizersNumLbl.text = kMeUnNilStr(model.volunteer_num);
}

- (void)setVolunteerUIWithModel:(MEVolunteerInfoModel *)model {
    _cancelBtn.hidden = NO;
    _locationImgConsW.constant = 0;
    _locationImageV.hidden = YES;
    _durationLbl.hidden = _durationTipLbl.hidden = _organizersNumLbl.hidden = _organizersNumTipLbl.hidden = YES;
    
    _nameLbl.text = kMeUnNilStr(model.name);
    _contentLbl.text = kMeUnNilStr(model.signature).length>0?kMeUnNilStr(model.signature):@"Ta还没有设置签名";
    kSDLoadImg(_headerPic, kMeUnNilStr(model.header_pic));
}

- (IBAction)cancelBtnAction:(id)sender {
    //取消关注
    kMeCallBlock(self.tapBlock);
}


@end

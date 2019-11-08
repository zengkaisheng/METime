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
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

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
    self.statusLbl.hidden = YES;
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
    _durationLbl.text = kMeUnNilStr(model.duration).length>0?kMeUnNilStr(model.duration):@"0";
    _organizersNumLbl.text = [NSString stringWithFormat:@"%@",@(model.volunteer_num)];
    kSDLoadImg(_headerPic, kMeUnNilStr(model.org_images));
    if (model.is_own) {
        self.statusLbl.hidden = NO;
        switch (model.status) {
            case 1:
            {
                self.statusLbl.text = @"待审核";
                self.statusLbl.backgroundColor = [UIColor colorWithHexString:@"#FFA158"];
            }
                break;
            case 2:
            {
                self.statusLbl.text = @"已通过";
                self.statusLbl.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
            }
                break;
            case 3:
            {
                self.statusLbl.text = @"未通过";
                self.statusLbl.backgroundColor = [UIColor colorWithHexString:@"#FF5858"];
            }
                break;
            case 4:
            {
                self.statusLbl.text = @"禁用";
                self.statusLbl.backgroundColor = [UIColor colorWithHexString:@"#999999"];
            }
                break;
            default:
                break;
        }
    }else {
        self.statusLbl.hidden = YES;
    }
}

- (void)setVolunteerUIWithModel:(MEVolunteerInfoModel *)model {
    _cancelBtn.hidden = NO;
    self.statusLbl.hidden = YES;
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

//
//  MEEyesightStoreCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEyesightStoreCell.h"
#import "MEGoodDetailModel.h"
#import "MEAppointDetailModel.h"

@interface MEEyesightStoreCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *StoreNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (nonatomic, strong) NSString *cellPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeNameLblConsHeight;

@property (weak, nonatomic) IBOutlet UILabel *topStoreNameLbl;

@end


@implementation MEEyesightStoreCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setUIWithModel:(MEGoodDetailModel *)model {
    self.topStoreNameLbl.hidden = YES;
    self.StoreNameLbl.hidden = NO;
    _storeNameLblConsHeight.constant = 18;
    self.cellPhone = kMeUnNilStr(model.company_phone);
    _StoreNameLbl.text = kMeUnNilStr(model.company_name);
    _addressLbl.text = [NSString stringWithFormat:@"地址：%@%@%@%@",kMeUnNilStr(model.company_province),kMeUnNilStr(model.company_city),kMeUnNilStr(model.company_area),kMeUnNilStr(model.company_addr_detail)];
}

- (void)setAppointmentInfoUIWithModel:(MEAppointDetailModel *)model {
    self.topStoreNameLbl.hidden = NO;
    self.StoreNameLbl.hidden = YES;
    _storeNameLblConsHeight.constant = 0;
    self.cellPhone = kMeUnNilStr(model.company_phone);
    self.topStoreNameLbl.text = kMeUnNilStr(model.company_name);
    _addressLbl.text = [NSString stringWithFormat:@"地址：%@%@%@%@",kMeUnNilStr(model.company_province),kMeUnNilStr(model.company_city),kMeUnNilStr(model.company_area),kMeUnNilStr(model.company_addr_detail)];
}

- (IBAction)locationAction:(id)sender {
    //定位
    kMeCallBlock(self.pilotBlock);
}
- (IBAction)CallPhotoAction:(id)sender {
    //打电话
    if (kMeUnNilStr(self.cellPhone).length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",kMeUnNilStr(self.cellPhone)]]];
    }
}

@end

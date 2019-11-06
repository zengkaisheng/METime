//
//  MEEyesightStoreCell.m
//  ME时代
//
//  Created by gao lei on 2019/11/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEEyesightStoreCell.h"
#import "MEGoodDetailModel.h"

@interface MEEyesightStoreCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *StoreNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (nonatomic, strong) MEGoodDetailModel *model;

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
    self.model = model;
    _StoreNameLbl.text = kMeUnNilStr(model.company_name);
    _addressLbl.text = [NSString stringWithFormat:@"地址：%@%@%@%@",kMeUnNilStr(model.company_province),kMeUnNilStr(model.company_city),kMeUnNilStr(model.company_area),kMeUnNilStr(model.company_addr_detail)];
}

- (IBAction)locationAction:(id)sender {
    //定位
    kMeCallBlock(self.pilotBlock);
}
- (IBAction)CallPhotoAction:(id)sender {
    //打电话
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",kMeUnNilStr(self.model.company_phone)]]];
}

@end

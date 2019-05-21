//
//  MEMyAddressCell.m
//  ME时代
//
//  Created by hank on 2018/9/13.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyAddressCell.h"
#import "MEAddressModel.h"

@interface MEMyAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;


@end

@implementation MEMyAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEAddressModel *)model isSelect:(BOOL)isSelect{
    if(isSelect){
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@",@" 默认 ",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.detail_address)]];
        [str addAttribute:NSForegroundColorAttributeName value:kMEHexColor(@"ff5f2a") range:NSMakeRange(0,4)];
        [str addAttribute:NSBackgroundColorAttributeName value:kMEHexColor(@"fed5d5") range:NSMakeRange(0,4)];
        _lblAddress.attributedText = str;
    }else{
        _lblAddress.text = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.detail_address)];
    }
    _lblName.text = kMeUnNilStr(model.truename);
    _lblPhone.text = kMeUnNilStr(model.telphone);
}

- (IBAction)editAction:(UIButton *)sender {
    kMeCallBlock(_editBlock);
}




@end

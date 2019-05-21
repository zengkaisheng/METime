//
//  MEAppointmentStoreCell.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentStoreCell.h"
#import "MEStoreModel.h"

@interface MEAppointmentStoreCell (){
  
}

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@end

@implementation MEAppointmentStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _clickBtn.userInteractionEnabled = NO;
    // Initialization code
}


- (void)setUIWIthModel:(MEStoreModel *)model isSelect:(BOOL)isSelect{
    if(isSelect){
        [_clickBtn setImage:[UIImage imageNamed:@"inc-gg"] forState:(UIControlStateNormal)];
    }else{
        [_clickBtn setImage:[UIImage imageNamed:@"icon_xuanzhe01"] forState:(UIControlStateNormal)];
    }
    _lblTitle.text = kMeUnNilStr(model.store_name);
    _lblSubTitle.text = [NSString stringWithFormat:@"%@%@%@%@",kMeUnNilStr(model.province),kMeUnNilStr(model.city),kMeUnNilStr(model.district),kMeUnNilStr(model.address)];
}



@end

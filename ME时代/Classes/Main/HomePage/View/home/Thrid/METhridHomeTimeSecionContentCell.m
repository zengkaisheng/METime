//
//  METhridHomeTimeSecionContentCell.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeTimeSecionContentCell.h"
#import "METhridHomeRudeTimeModel.h"

@interface METhridHomeTimeSecionContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIView *viewForSelect;

@end

@implementation METhridHomeTimeSecionContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWIthModel:(METhridHomeRudeTimeModel *)model isSelect:(BOOL)isSelect{
    _lblTime.text = kMeUnNilStr(model.time);
    _lblStatus.text = kMeUnNilStr(model.tip);
    if(isSelect){
        _lblStatus.textColor = kMEea3782;
        _viewForSelect.hidden = NO;
        _lblTime.textColor = [UIColor whiteColor];
    }else{
        _lblStatus.textColor = kME999999;
        _viewForSelect.hidden = YES;
        _lblTime.textColor = kMEblack;
    }
}

@end

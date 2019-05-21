//
//  MEMineMyActityDetailCell.m
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEMineMyActityDetailCell.h"
#import "MEMineActiveModel.h"

@interface MEMineMyActityDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;


@end

@implementation MEMineMyActityDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWIthModel:(MEMineActiveLeveModel *)model finish:(BOOL)finish nowNum:(NSString*)nowNum{
//    _lblTitle.text = [NSString stringWithFormat:@"%@级达成条件:%@/%@人",kMeUnNilStr(model.level),kMeUnNilStr(nowNum),kMeUnNilStr(model.share_number)];
//    if(finish){
//        _lblStatus.text = @"已完成";
//        _lblStatus.textColor = kMEPink;
//    }else{
//        _lblStatus.text = @"未完成";
//         _lblStatus.textColor = kMEblack;
//    }
}


@end

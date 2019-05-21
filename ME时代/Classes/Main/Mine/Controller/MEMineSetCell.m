//
//  MEMineSetCell.m
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineSetCell.h"

@interface MEMineSetCell (){
    kMeBOOLBlock _switchBlock;
    BOOL _status;
    MESetStyle _type;
}

@property (weak, nonatomic) IBOutlet UISwitch *swotice;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;

@end

@implementation MEMineSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

//- (void)setType:(MESetStyle)type status:(BOOL)status switchBlock:(kMeBOOLBlock)switchBlock{
//    _swotice.on = status;
//    _status = status;
//    _type = type;
//    _switchBlock = switchBlock;
//    _swotice.hidden = type !=MESetNoticeStyle;
//    _imgArrow.hidden = type==MESetNoticeStyle;
//}

- (IBAction)switchstatusAction:(UISwitch *)sender {
    kMeCallBlock(_switchBlock,sender.on);
}


@end

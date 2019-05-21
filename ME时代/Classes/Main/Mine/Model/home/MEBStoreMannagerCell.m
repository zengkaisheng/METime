//
//  MEBStoreMannagerCell.m
//  ME时代
//
//  Created by hank on 2019/2/19.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBStoreMannagerCell.h"
#import "MEBStoreMannagerInfoModel.h"

@interface MEBStoreMannagerCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageTail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleHeight;


@end

@implementation MEBStoreMannagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUiWithModel:(MEBStoreMannagercontentInfoModel *)model{
    if(model.type == MEBStoreMannagerInfoStoreNameType || model.type == MEBStoreMannagerInfoStoreTelType ||model.type == MEBStoreMannagerInfocodeIdType ||model.type == MEBStoreMannagerStoreIntoduceType ||model.type == MEBStoreMannagerInfoAddressType){
        _imageTail.hidden = NO;
        _imageTail.image = model.type == MEBStoreMannagerInfoAddressType?[UIImage imageNamed:@"stroelocation"]:[UIImage imageNamed:@"icon_more"];
    }else{
        _imageTail.hidden = YES;
    }
    _lblTitle.lineBreakMode = UILineBreakModeCharacterWrap;
    NSString *str = [NSString stringWithFormat:@"%@%@",kMeUnNilStr(model.title),kMeUnNilStr(model.subTitle)];
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:13] width:(SCREEN_WIDTH - 75) lineH:0 maxLine:0];
    _consTitleHeight.constant = titleHeight>16?titleHeight:16;
    _lblTitle.text = str;
}

+ (CGFloat)getCellHeightWithModel:(MEBStoreMannagercontentInfoModel*)model{
    CGFloat height = 0;
    NSString *str = [NSString stringWithFormat:@"%@%@",kMeUnNilStr(model.title),kMeUnNilStr(model.subTitle)];
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:13] width:(SCREEN_WIDTH - 75) lineH:0 maxLine:0];
    height += titleHeight>16?titleHeight:16;
    height +=28;
    return height;
}


@end

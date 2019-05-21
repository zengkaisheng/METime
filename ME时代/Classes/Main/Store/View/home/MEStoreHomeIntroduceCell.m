//
//  MEStoreHomeIntroduceCell.m
//  ME时代
//
//  Created by hank on 2018/10/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEStoreHomeIntroduceCell.h"
#import "MEStoreDetailModel.h"

@interface MEStoreHomeIntroduceCell (){
    kMeBOOLBlock _expandBlock;
    BOOL _isExpand;
}

#define kFontOfTitle [UIFont systemFontOfSize:14]
#define kWidthOflblContent (SCREEN_WIDTH - 30)

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTitleHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;
@end

@implementation MEStoreHomeIntroduceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setUIWithModel:(MEStoreDetailModel *)model isExpand:(BOOL)isExpand ExpandBlock:(kMeBOOLBlock)expandBlock{
    NSString *title = kMeUnNilStr(model.intro);
    if(!title.length){
        title = @"该美店没有介绍";
    }
    _btnExpand.hidden = isExpand;
    _expandBlock = expandBlock;
    _isExpand = isExpand;
    if(isExpand){
        _lblTitle.numberOfLines = 0;
        CGFloat strHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(title) font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
        _conTitleHeight.constant = (strHeight<17?17:strHeight);
        [_lblTitle setAtsWithStr:kMeUnNilStr(title) lineGap:0];
    }else{
        _lblTitle.numberOfLines = 1;
        _conTitleHeight.constant = 17;
        _lblTitle.text = kMeUnNilStr(title);
    }
    
}

- (IBAction)expandAction:(UIButton *)sender {
    _btnExpand.hidden = YES;
    kMeCallBlock(_expandBlock,YES);
}

+ (CGFloat)getCellHeightWithModel:(MEStoreDetailModel *)model isExpand:(BOOL)isExpand{
    if(isExpand){
        CGFloat height = kMEStoreHomeIntroduceCellHeight -17;
        NSString *str = kMeUnNilStr(model.intro);
        if(!str.length){
            str = @"该美店没有介绍";
        }
        CGFloat strHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(str) font:kFontOfTitle width:kWidthOflblContent lineH:0 maxLine:0];
        height +=(strHeight<17?17:strHeight);
        return height-27;
    }else{
        return kMEStoreHomeIntroduceCellHeight;
    }
}

@end

//
//  MEBynamicCommentCell.m
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBynamicCommentCell.h"
#import "MEBynamicHomeModel.h"

#define kMEBynamicCommentCellMagin (10+36+10+10+10+10)

@interface MEBynamicCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleHeight;

@end

@implementation MEBynamicCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
//    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
    // Initialization code
}

- (void)setUIWithModel:(MEBynamicHomecommentModel *)model{
    NSString *str = [NSString stringWithFormat:@"%@:%@",kMeUnNilStr(model.nick_name),kMeUnNilStr(model.content)];
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:14] width:SCREEN_WIDTH-kMEBynamicCommentCellMagin lineH:0 maxLine:0];
    _consTitleHeight.constant = titleHeight>17?titleHeight:17;
//    [_lblTitle setAtsWithStr:str lineGap:0];
    _lblTitle.text = nil;
    _lblTitle.lineBreakMode = UILineBreakModeCharacterWrap;
    _lblTitle.attributedText = [str attributeWithRangeOfString:[NSString stringWithFormat:@"%@:",kMeUnNilStr(model.nick_name)] color:kME466889];
    
}

+ (CGFloat)getCellHeightWithhModel:(MEBynamicHomecommentModel *)model{
    CGFloat height = 8;
    NSString *str = [NSString stringWithFormat:@"%@:%@",kMeUnNilStr(model.nick_name),kMeUnNilStr(model.content)];
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:str font:[UIFont systemFontOfSize:14] width:SCREEN_WIDTH-kMEBynamicCommentCellMagin lineH:0 maxLine:0];
    height+=titleHeight>17?titleHeight:17;
    return height;
}



@end

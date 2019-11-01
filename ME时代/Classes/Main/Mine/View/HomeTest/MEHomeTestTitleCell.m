//
//  MEHomeTestTitleCell.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeTestTitleCell.h"
#import "MEHomeTestTitleModel.h"

@interface MEHomeTestTitleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeight;


@end

@implementation MEHomeTestTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;

}

- (void)setUIWithModel:(MEHomeTestTitleModel *)model{
    kSDLoadImg(_imgPic, kMeUnNilStr(model.image_url));
    _lbltitle.text = kMeUnNilStr(model.title);
    
    NSString *strattentStr = kMeUnNilStr(model.desc);
    CGFloat strattent =
    [NSAttributedString heightForAtsWithStr:kMeUnNilStr(strattentStr) font:[UIFont systemFontOfSize:13] width:(SCREEN_WIDTH- 58) lineH:0];
    CGFloat strattentHeight = strattent>16?strattent:16;
    _consHeight.constant = strattentHeight;
    [_lblContent setAtsWithStr:strattentStr lineGap:0];
}

- (IBAction)delAction:(UIButton *)sender {
    kMeCallBlock(_delBlock);
}

- (IBAction)shareAction:(UIButton *)sender {
    kMeCallBlock(_shareBlock);
}

+ (CGFloat)getCellheightWithMolde:(MEHomeTestTitleModel *)model{
    CGFloat height = 345 - 16 + 13;
    NSString *strattentStr = kMeUnNilStr(model.desc);
    CGFloat strattent =
    [NSAttributedString heightForAtsWithStr:kMeUnNilStr(strattentStr) font:[UIFont systemFontOfSize:13] width:(SCREEN_WIDTH- 58) lineH:0];
    CGFloat strattentHeight = strattent>16?strattent:16;
    height +=strattentHeight;
    return height;
}

@end

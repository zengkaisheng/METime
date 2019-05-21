//
//  MEMyPosterContentCell.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyPosterContentCell.h"
#import "MEPosterModel.h"
#import "MEActivePosterModel.h"

@interface MEMyPosterContentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPIc;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consIMageHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIView *viewForMask;

@end

@implementation MEMyPosterContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _consIMageHeight.constant = (152 * kMEMyPosterContentCellWdith)/102;
    _lblContent.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setiWithModel:(MEPosterChildrenModel *)Model{
    kSDLoadImg(_imgPIc, Model.image);
    _lblTitle.text = kMeUnNilStr(Model.title);
    _lblContent.text = [NSString stringWithFormat:@"被分享%@次",kMeUnNilStr(Model.share_amount)];//kMeUnNilStr(Model.updated_at);
}

- (void)setiWitMorehModel:(MEPosterChildrenModel *)Model{
    _btnDel.hidden = YES;
    [_btnShare setTitle:@"点击使用" forState:UIControlStateNormal];
    kSDLoadImg(_imgPIc, Model.image);
    _lblTitle.text = kMeUnNilStr(Model.title);
    _lblContent.text = [NSString stringWithFormat:@"被分享%@次",kMeUnNilStr(Model.share_amount)];
}

- (void)setiActiveWithModel:(MEActivePosterModel *)Model{
    _btnDel.hidden = YES;
    [_btnShare setTitle:@"立即分享" forState:UIControlStateNormal];
    kSDLoadImg(_imgPIc, Model.image);
    _lblTitle.text = kMeUnNilStr(Model.activity_name);
    
    _lblContent.text = [NSString stringWithFormat:@"红包金额:¥%@",@(kMeUnNilStr(Model.total_reward).floatValue)];
}

- (IBAction)DeleteAction:(UIButton *)sender {
    kMeCallBlock(_delBlock);
}

- (IBAction)shareAction:(UIButton *)sender {
    kMeCallBlock(_btnBlock);
}

+ (CGFloat)getCellHeight{
    CGFloat height = kMEMyPosterContentCellOrgialHeight-kMEMyPosterContentIMageHeight;
    height +=(152 * kMEMyPosterContentCellWdith)/102;
    return height;
}

@end

//
//  MEMineHomeCell.m
//  志愿星
//
//  Created by Hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineHomeCell.h"
#import "AppDelegate.h"

@interface MEMineHomeCell (){
    NSArray *_arrTitle;
    NSArray *_arrImage;
    MEMineHomeMenuCellStyle _type;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblUnMessage;

@end

@implementation MEMineHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _arrTitle = MEMineHomeMenuCellStyleTitle;
    _arrImage = MEMineHomeMenuCellStyleImage;
    // Initialization code
}

- (void)setUiWithType:(MEMineHomeMenuCellStyle)type{
    _type = type;
    _imgPic.image =  kMeGetAssetImage(_arrImage[type]);
    _lblTitle.text = _arrTitle[type];
    if(type == MeMyMenuCustomer){
        _lblUnMessage.hidden = NO;
        [self setUnMeaasge];
    }else{
        _lblUnMessage.hidden = YES;
    }
}

- (void)setUnMeaasge{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSInteger unmessgae =  [[RCIMClient sharedRCIMClient] getUnreadCount:@[
//                                                                           @(ConversationType_PRIVATE),
//                                                                           ]];
//    appDelegate.unMessageCount = unmessgae;
//    NSString *str = @(unmessgae).description;
//    if(appDelegate.unMessageCount>99){
//        str = @"99+";
//    }
//    _lblUnMessage.hidden = appDelegate.unMessageCount == 0;
//    _lblUnMessage.text = [NSString stringWithFormat:@"%@",str];
}

@end

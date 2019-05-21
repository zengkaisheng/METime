//
//  MEVisterDetailCell.m
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEVisterDetailCell.h"
#import "MEVisterDetailVC.h"
#import "MERCConversationVC.h"
#import "MEVistorUserModel.h"
#import "MESpreadUserModel.h"

@interface MEVisterDetailCell (){
    MEVistorUserModel *_model;
}
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblCountPage;
@property (weak, nonatomic) IBOutlet UILabel *lblChatTime;
@property (weak, nonatomic) IBOutlet UILabel *lblZFNum;
@property (weak, nonatomic) IBOutlet UILabel *lblInVialRead;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;

@end

@implementation MEVisterDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    _lblCountPage.adjustsFontSizeToFitWidth = YES;
    _lblChatTime.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setUIWithModle:(MEVistorUserModel *)model dicUser:(MESpreadUserModel *)dicUser{
    _model = model;
    kSDLoadImg(_imgHeader, kMeUnNilStr(model.user.header_pic));
    _lblName.text = kMeUnNilStr(model.user.nick_name);
    _lblCountPage.text =  [NSString stringWithFormat:@"%@篇",kMeUnNilStr(dicUser.browse)];
    _lblChatTime.text = [NSString stringWithFormat:@"%@/篇",kMeUnNilStr(dicUser.wait_time)];
    _lblZFNum.text = [NSString stringWithFormat:@"%@次",kMeUnNilStr(dicUser.share_total)];
    _lblInVialRead.text = [NSString stringWithFormat:@"%@篇",kMeUnNilStr(dicUser.valid)];
    _lblAddress.text = kMeUnNilStr(model.user.address);
    _lblSex.text = kMeUnNilStr(model.user.sex);
}

- (IBAction)toChatAction:(UIButton *)sender {
    MEVisterDetailVC *homeVC = [MECommonTool getVCWithClassWtihClassName:[MEVisterDetailVC class] targetResponderView:self];
    if(homeVC){
        if([kMeUnNilStr(_model.tls_id) isEqualToString:kCurrentUser.tls_data.tls_id]){
            [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:self];
        }else{
            TConversationCellData *data = [[TConversationCellData alloc] init];
            data.convId = kMeUnNilStr(_model.tls_id);
            data.convType = TConv_Type_C2C;
            data.title = kMeUnNilStr(_model.user.nick_name);;
            MERCConversationVC *chat = [[MERCConversationVC alloc] initWIthconversationData:data];
            //            chat.conversation = data;
            [homeVC.navigationController pushViewController:chat animated:YES];
        }
    }
    //        MERCConversationVC *conversationVC = [[MERCConversationVC alloc]init];
    //        conversationVC.conversationType = ConversationType_PRIVATE;
    //        conversationVC.targetId = @(_model.member_id).description ;//RONGYUNCUSTOMID;
    //        conversationVC.title = kMeUnNilStr(_model.user.nick_name);
    //        if([@((_model.member_id)).description isEqualToString:kCurrentUser.uid]){
    //            [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:self];
    //        }else{
    //            [homeVC.navigationController pushViewController:conversationVC animated:YES];
    //        }
    
}


@end

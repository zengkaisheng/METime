//
//  MEAddTbView.m
//  ME时代
//
//  Created by hank on 2019/4/30.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAddTbView.h"
#import "MERelationIdModel.h"

@interface MEAddTbView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnReload;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *viewPhone;

@end

@implementation MEAddTbView

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAction)];
    _imgAdd.userInteractionEnabled = YES;
    [_imgAdd addGestureRecognizer:ges];
    
}

- (void)addAction{
    kMeWEAKSELF
    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
    [MEPublicNetWorkTool postShareTaobaokeGetMemberRelationWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MERelationIdModel *relation_idmodel = [MERelationIdModel mj_objectWithKeyValues:responseObject.data];
        NSString *relation_id = kMeUnNilStr(relation_idmodel.relation_id);
        if(kMeUnNilStr(relation_id).length == 0 || [relation_id isEqualToString:@"0"]){
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"加入失败,请先授权"];
            [strongSelf hideWithBlock:strongSelf.finishBlock isSucess:YES];
        }else{
            kCurrentUser.relation_id = kMeUnNilStr(relation_id);
            [kCurrentUser save];
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"加入成功"];
            [strongSelf hideWithBlock:strongSelf.finishBlock isSucess:YES];
        }
    } failure:^(id error) {
        if([error isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)error;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
    }];
}

- (void)show{
    [kMeCurrentWindow addSubview:self];
    _viewPhone.alpha = 0.5;
    kMeWEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        kMeSTRONGSELF
        strongSelf->_viewPhone.alpha = 1;
    }];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self hideWithBlock:self.finishBlock isSucess:false];
}

- (IBAction)reloadAction:(UIButton *)sender {
    NSString *urlStr = kMeUnNilStr(self.url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)hideWithBlock:(kMeBOOLBlock)block isSucess:(BOOL)isSucess{
    [self removeFromSuperview];
    kMeCallBlock(block,isSucess);
}

@end

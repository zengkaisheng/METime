//
//  MEMyAccountVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEMyAccountVC.h"
#import "MEMyAccountModel.h"
#import "MEMyTopUpRecordVC.h"
#import "METopUpVC.h"

@interface MEMyAccountVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTop;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (nonatomic, strong) MEMyAccountModel *model;

@end

@implementation MEMyAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的资金";
    _consTop.constant = kMeNavBarHeight+42;
    [self requestMyAccountWithNetWork];
}

#pragma mark -- Networking
//资金明细
- (void)requestMyAccountWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetMyAccountWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MEMyAccountModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        [strongSelf reloadUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)reloadUI {
    _accountLbl.text = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(self.model.money)];
}

- (IBAction)topUpAction:(id)sender {
    //充值
    METopUpVC *vc = [[METopUpVC alloc] init];
    kMeWEAKSELF
    vc.finishBlock = ^{
        kMeSTRONGSELF
        [strongSelf requestMyAccountWithNetWork];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)recordAction:(id)sender {
    //明细
    MEMyTopUpRecordVC *vc = [[MEMyTopUpRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

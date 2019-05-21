//
//  MEMyMobileVC.m
//  ME时代
//
//  Created by hank on 2018/11/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyMobileVC.h"
#import "MEadminDistributionModel.h"

@interface MEMyMobileVC (){
    MEadminDistributionModel *_bModel;
}

@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;



@end

@implementation MEMyMobileVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    if(_isSuper){
        self.title = @"我的上级";
        _lblTitle.text = @"我的上级";
        _lblMobile.text =@"";
        [self getData];
    }else{
        self.title = @"绑定的手机号";
        _lblMobile.text = kMeUnNilStr(kCurrentUser.mobile);
        _lblTitle.text = @"您当前绑定的手机号";
    }
    _consTopMargin.constant = kMeNavBarHeight + 21;

}

- (void)getData{
    kMeWEAKSELF
    [MEPublicNetWorkTool getAdminDistributionWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_bModel = [MEadminDistributionModel mj_objectWithKeyValues:responseObject.data];
        strongSelf->_lblMobile.text = kMeUnNilStr(strongSelf->_bModel.superior);
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UITableViewDelegate
 
#pragma mark - Public
 
#pragma mark - Private
 
#pragma mark - Getter
 
#pragma mark - Setter

@end

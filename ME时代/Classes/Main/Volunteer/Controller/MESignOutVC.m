//
//  MESignOutVC.m
//  ME时代
//
//  Created by gao lei on 2019/10/31.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MESignOutVC.h"
#import "MESginUpActivityInfoModel.h"

@interface MESignOutVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageCons;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timesLbl;
@property (weak, nonatomic) IBOutlet UILabel *pointsLbl;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) MESginUpActivityInfoModel *model;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MESignOutVC

- (instancetype)initWithModel:(MESginUpActivityInfoModel *)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"签退";
    _topImageCons.constant = kMeNavBarHeight+16;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    
    _titleLbl.text = kMeUnNilStr(self.model.title);
    if (self.model.member_info.duration > 0) {
        _timesLbl.text = [NSString stringWithFormat:@"+%@",kMeUnNilStr(self.model.member_info.duration)];
    }
    if (self.model.member_info.integral > 0) {
        _pointsLbl.text = [NSString stringWithFormat:@"+%@",kMeUnNilStr(self.model.member_info.integral)];
    }
    
    _bgView.layer.shadowOffset = CGSizeMake(0, 3);
    _bgView.layer.shadowOpacity = 1;
    _bgView.layer.shadowRadius = 6;
    _bgView.layer.shadowColor = [UIColor colorWithRed:46/255.0 green:217/255.0 blue:164/255.0 alpha:0.10].CGColor;
    _bgView.layer.masksToBounds = false;
    _bgView.layer.cornerRadius = 14;
    _bgView.clipsToBounds = false;
    [self checkSignInCodeWithNetWork];
}

#pragma mark -- Networking
//验证活动编码
- (void)checkSignInCodeWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postCheckSignInCodeWithCode:kMeUnNilStr(self.model.signin_code) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            strongSelf.model = [MESginUpActivityInfoModel mj_objectWithKeyValues:responseObject.data];
        }else{
            strongSelf.model = nil;
        }
        strongSelf->_titleLbl.text = kMeUnNilStr(strongSelf.model.title);
        strongSelf->_timesLbl.text = [NSString stringWithFormat:@"+%@",kMeUnNilStr(strongSelf.model.member_info.duration)];
        strongSelf->_pointsLbl.text = [NSString stringWithFormat:@"+%@",kMeUnNilStr(strongSelf.model.member_info.integral)];
    } failure:^(id object) {
    }];
}

#pragma mark -- Action
- (void)gotoHomeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.tabBarController.selectedIndex = 0;
}


#pragma mark --- Setter&&Getter
- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 40, 40);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"icon_gotoHome"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(gotoHomeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end

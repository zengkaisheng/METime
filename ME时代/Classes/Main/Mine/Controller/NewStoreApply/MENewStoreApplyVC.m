//
//  MENewStoreApplyVC.m
//  ME时代
//
//  Created by gao lei on 2019/8/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewStoreApplyVC.h"
#import "MENewStoreApplyView.h"
#import "MEStoreApplyParModel.h"
#import "ZHMapAroundInfoViewController.h"
#import "ZHPlaceInfoModel.h"
#import "MEStoreApplyStatusVC.h"
#import "MEStoreApplyModel.h"

#define kMENavViewHeight (((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 88 : 64))

@interface MENewStoreApplyVC ()<UIScrollViewDelegate>{
    NSString *_token;
    BOOL _isError;
}
@property (nonatomic, strong) MENewStoreApplyView *cview;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIView *navBar;

@end

@implementation MENewStoreApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"门店申请";
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.cview];
    self.navBarHidden = YES;
    [self.view addSubview:self.navBar];
}

- (void)submitAction{
    if(!kMeUnNilStr(self.parModel.true_name).length){
        [MEShowViewTool showMessage:@"真实姓名不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.name).length){
        [MEShowViewTool showMessage:@"登录名不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.store_name).length){
        [MEShowViewTool showMessage:@"店铺名称不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.province).length){
        [MEShowViewTool showMessage:@"地址不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.address).length){
        [MEShowViewTool showMessage:@"详细地址不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.longitude).length || !kMeUnNilStr(self.parModel.latitude).length){
        [MEShowViewTool showMessage:@"地址解析失败，请重新选择" view:kMeCurrentWindow];
        return;
    }
    kMeWEAKSELF
    [MEPublicNetWorkTool postNewStoreApplyWithModel:self.parModel SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MEStoreApplyStatusVC *vc = [[MEStoreApplyStatusVC alloc]init];
        MEStoreApplyModel *model = [MEStoreApplyModel new];
        model.state = 1;
        model.message = @"预计10分钟以内审核完毕，审核结果会短信通知到您的注册手机上。届时请您重新登录账号！";
        vc.model = model;
        vc.finishBlock = ^{
            kMeCallBlock(strongSelf.finishBlock);
        };
        [strongSelf.navigationController pushViewController:vc animated:YES];
    } failure:^(id object) {
    }];
}

- (void)backButtonPressed {
    kMeCallBlock(self.finishBlock);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma setter&&getter
- (MEStoreApplyParModel *)parModel{
    if(!_parModel){
        _parModel = [MEStoreApplyParModel getModel];
    }
    return _parModel;
}

- (UIScrollView *)scrollerView{
    if(!_scrollerView){
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
        _scrollerView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _scrollerView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"fbfbfb"];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, kMENewStoreApplyViewHeight);
        _scrollerView.bounces = YES;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.delegate = self;
    }
    return _scrollerView;
}

- (MENewStoreApplyView *)cview{
    if(!_cview){
        _cview = [[[NSBundle mainBundle]loadNibNamed:@"MENewStoreApplyView" owner:nil options:nil] lastObject];
        _cview.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMENewStoreApplyViewHeight);
        _cview.model = self.parModel;
        kMeWEAKSELF
        _cview.locationBlock = ^{
            kMeSTRONGSELF
            ZHMapAroundInfoViewController *mapVC = [[ZHMapAroundInfoViewController alloc]init];
            mapVC.contentBlock = ^(ZHPlaceInfoModel *model) {
                kMeSTRONGSELF
                strongSelf.parModel.latitude = @(model.coordinate.latitude).description;
                strongSelf.parModel.longitude = @(model.coordinate.latitude).description;
                strongSelf.parModel.province = kMeUnNilStr(model.province);
                strongSelf.parModel.city = kMeUnNilStr(model.city);
                strongSelf.parModel.district = kMeUnNilStr(model.district);
                strongSelf.parModel.address = kMeUnNilStr(model.detailsAddress);
                
                [strongSelf.cview reloadUI];
            };
            [strongSelf.navigationController pushViewController:mapVC animated:YES];
        };
        _cview.applyBlock = ^{
            kMeSTRONGSELF
            [strongSelf submitAction];
        };
        
        [_cview reloadUI];
    }
    return _cview;
}

- (UIView *)navBar{
    if(!_navBar){
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMENavViewHeight)];
        _navBar.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, kMeStatusBarHeight, 44, 44);
        [backButton setImage:[UIImage imageNamed:@"inc-xz"] forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0);
        [backButton addTarget:self action:@selector(backButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
        [_navBar addSubview:backButton];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, kMeStatusBarHeight, 100, 44)];
        titleLbl.font = [UIFont boldSystemFontOfSize:17];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.text = @"门店申请";
        [_navBar addSubview:titleLbl];
    }
    return _navBar;
}

@end

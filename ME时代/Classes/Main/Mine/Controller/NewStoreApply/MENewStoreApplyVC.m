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

@interface MENewStoreApplyVC ()<UIScrollViewDelegate>{
    NSString *_token;
    BOOL _isError;
}
@property (nonatomic, strong) MENewStoreApplyView *cview;
@property (nonatomic, strong) UIScrollView *scrollerView;

@end

@implementation MENewStoreApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"门店申请";
    [self.view addSubview:self.scrollerView];
    [self.scrollerView addSubview:self.cview];
}

- (void)submitAction{
    if(!kMeUnNilStr(self.parModel.true_name).length){
        [MEShowViewTool showMessage:@"名字不能为空" view:kMeCurrentWindow];
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
        [MEShowViewTool showMessage:@"详情地址不能为空" view:kMeCurrentWindow];
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
        vc.model = model;
        [strongSelf.navigationController pushViewController:vc animated:YES];
    } failure:^(id object) {
    }];
}

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

@end

//
//  MEStoreHomeVC.m
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEStoreHomeVC.h"
#import "MENewStoreHomeCell.h"
#import "MEStoreSelectCityView.h"
#import "MEStoreModel.h"
#import "MELocationCLLModel.h"
#import "MENewStoreDetailsVC.h"
#import "YBPopupMenu.h"
#import "MEStoreSearchVC.h"

@interface MEStoreHomeVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate,YBPopupMenuDelegate>{
    MELocationCLLModel *_lllModel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEStoreSelectCityView *header;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIButton *btnLeft;
//@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MEStoreHomeVC


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.header];
    [[MELocationHelper sharedHander] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
    } failure:^{
    }];
//    _lllModel = [[MELocationHelper sharedHander] getLocationModel];
//    if(!_lllModel){
        _lllModel = [MELocationCLLModel new];
        _lllModel.lat = 0;
        _lllModel.lng = 0;
        _lllModel.city = @"全部";
//    }

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnLeft];
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

#pragma mark - Action

- (void)searchProduct:(UIButton *)btn{
    MEStoreSearchVC *svc = [[MEStoreSearchVC alloc]init];
    [self.navigationController pushViewController:svc animated:NO];
}

- (void)selectorAll:(UIButton *)btn{
    kMeWEAKSELF
    [YBPopupMenu showRelyOnView:btn titles:@[@"全部",@"重新定位"] icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.borderWidth = 1;
        popupMenu.borderColor = kMEblack;
        kMeSTRONGSELF
        popupMenu.delegate = strongSelf;
    }];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if(index==0){
        _lllModel = [MELocationCLLModel new];
        _lllModel.lat = 0;
        _lllModel.lng = 0;
        _lllModel.city = @"全部";
        [self.btnLeft setTitle:kMeUnNilStr(_lllModel.city) forState:UIControlStateNormal];
        [self.refresh reload];
    }else{
        [self locationAction:nil];
    }
}

- (void)locationAction:(UIButton *)btn{
    [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
//    [[MELocationTool sharedHander] startLocation];
    kMeWEAKSELF
    [[MELocationHelper sharedHander] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        kMeSTRONGSELF
        strongSelf->_lllModel = [[MELocationHelper sharedHander] getLocationModel];
        [strongSelf.btnLeft setTitle:kMeUnNilStr(strongSelf->_lllModel.city) forState:UIControlStateNormal];
        [MBProgressHUD hideHUDForView:kMeCurrentWindow];
        [strongSelf.refresh reload];
    } failure:^{
        kMeSTRONGSELF
        [strongSelf.btnLeft setTitle:@"定位失败" forState:UIControlStateNormal];
        [MBProgressHUD hideHUDForView:kMeCurrentWindow];
    }];
    
//    [[MELocationHelper sharedHander] getCurrentLocation:^(ResultLocationInfoBlock *location) {
//        kMeSTRONGSELF
//        strongSelf->_lllModel = [[MELocationHelper sharedHander] getLocationModel];
//        [strongSelf.btnLeft setTitle:kMeUnNilStr(strongSelf->_lllModel.city) forState:UIControlStateNormal];
//        [MBProgressHUD hideHUDForView:kMeCurrentWindow];
//        [strongSelf.refresh reload];
//    } failure:^{
//        kMeSTRONGSELF
//        [strongSelf.btnLeft setTitle:@"定位失败" forState:UIControlStateNormal];
//        [MBProgressHUD hideHUDForView:kMeCurrentWindow];
//    }];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"lat":@(_lllModel.lat),@"lng":@(_lllModel.lng),};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEStoreModel mj_objectArrayWithKeyValuesArray:data]];
}


#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEStoreModel *model = self.refresh.arrData[indexPath.row];
    MENewStoreHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewStoreHomeCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEStoreModel *model = self.refresh.arrData[indexPath.row];
    return [MENewStoreHomeCell getCellHeightWithmodel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEStoreModel *model = self.refresh.arrData[indexPath.row];
    MENewStoreDetailsVC *vc = [[MENewStoreDetailsVC alloc]initWithId:model.store_id];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    MEStoreSelectCitySectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEStoreSelectCitySectionView class])];
//    kMeWEAKSELF
//    headview.locationBlock = ^(id object) {
//        kMeSTRONGSELF
//        [strongSelf.refresh reload];
//    };
//    return headview;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return kMEStoreSelectCityViewHeight;
//}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewStoreHomeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewStoreHomeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonStoreStoreList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有门店";
        }];
    }
    return _refresh;
}

//- (MEStoreSelectCityView *)header{
//    if(!_header){
//        _header = [[[NSBundle mainBundle]loadNibNamed:@"MEStoreSelectCityView" owner:nil options:nil] lastObject];
//        _header.frame =CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, kMEStoreSelectCityViewHeight);
//        kMeWEAKSELF
//        _header.locationBlock = ^(id object) {
//            kMeSTRONGSELF
//            [strongSelf.refresh reload];
//        };
//    }
//    return _header;
//}

- (UIButton *)btnLeft{
    if(!_btnLeft){
        _btnLeft= [UIButton buttonWithType:UIButtonTypeCustom];
         _btnLeft.frame = CGRectMake(0, 0, 75, 25);
//        MELocationCLLModel *lllModel = [[MELocationTool sharedHander] getLocationModel];
        [_btnLeft setTitle:kMeUnNilStr(_lllModel.city) forState:UIControlStateNormal];
        [_btnLeft setImage:kMeGetAssetImage(@"icon-pgwuf") forState:UIControlStateNormal];
        [_btnLeft setTitleColor:kMEblack forState:UIControlStateNormal];
        _btnLeft.titleLabel.font = kMeFont(14);
        [_btnLeft.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_btnLeft addTarget:self action:@selector(selectorAll:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLeft;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 30, 25);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"common_nav_btn_search"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(searchProduct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

//- (UIView *)rightView{
//    if(!_rightView){
//        _rightView = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, 80, 25)];
//        UILabel *lbl = [MEView lblWithFram:CGRectMake(0, 3, 62, 18) textColor:[UIColor colorWithHexString:@"cc9e69"] bgColor:[UIColor clearColor] str:@"重新定位" font:[UIFont systemFontOfSize:15]];
//        [_rightView addSubview:lbl];
//        UIImageView *img = [[UIImageView alloc]initWithImage:kMeGetAssetImage(@"icon-tguspgwu")];
//        img.frame = CGRectMake(67, 4, 12, 14);
//        img.centerY = 12.5;
//        [_rightView addSubview:img];
//        UIButton *btn = [MEView btnWithFrame:_rightView.bounds Img:nil title:@"" target:self Action:@selector(locationAction:)];
//        [_rightView addSubview:btn];
//    }
//    return _rightView;
//}
@end

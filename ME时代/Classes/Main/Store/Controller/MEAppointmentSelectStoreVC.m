//
//  MEAppointmentSelectStoreVC.m
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEAppointmentSelectStoreVC.h"
#import "MEAppointmentStoreCell.h"
#import "MELocationCLLModel.h"
#import "MEStoreModel.h"
#import "YBPopupMenu.h"

@interface MEAppointmentSelectStoreVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate,YBPopupMenuDelegate>
{
    NSInteger _currentIndex;
    MELocationCLLModel *_lllModel;
    NSInteger _storId;
}
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MEAppointmentSelectStoreVC

- (instancetype)initWithStoreId:(NSInteger)storId{
    if(self = [super init]){
        _storId = storId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 0;
    self.title = @"选择门店";
    _lllModel = [MELocationCLLModel new];
    _lllModel.lat = 0;
    _lllModel.lng = 0;
    _lllModel.city = @"全部";
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
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
        [self.btnRight setTitle:kMeUnNilStr(_lllModel.city) forState:UIControlStateNormal];
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
        [strongSelf.btnRight setTitle:kMeUnNilStr(strongSelf->_lllModel.city) forState:UIControlStateNormal];
        [MBProgressHUD hideHUDForView:kMeCurrentWindow];
        [strongSelf.refresh reload];
    } failure:^{
        kMeSTRONGSELF
        [strongSelf.btnRight setTitle:@"定位失败" forState:UIControlStateNormal];
        [MBProgressHUD hideHUDForView:kMeCurrentWindow];
    }];
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


//- (void)toAppoint:(UIButton *)btn{
//
//}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEAppointmentStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAppointmentStoreCell class]) forIndexPath:indexPath];
    MEStoreModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWIthModel:model isSelect:model.store_id == _storId];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEAppointmentStoreCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    MEStoreModel *model = self.refresh.arrData[indexPath.row];
    _currentIndex = indexPath.row;
//    [self.tableView reloadData];
    kMeCallBlock(_stroeBlock,model);
}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAppointmentStoreCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAppointmentStoreCell class])];
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

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-20, 0, 75, 25);
        [_btnRight setTitle:kMeUnNilStr(_lllModel.city) forState:UIControlStateNormal];
        [_btnRight setImage:kMeGetAssetImage(@"icon-pgwuf") forState:UIControlStateNormal];
        _btnRight.titleLabel.font = kMeFont(14);
        _btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_btnRight.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(selectorAll:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}
@end

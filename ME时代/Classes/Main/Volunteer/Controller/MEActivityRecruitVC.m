//
//  MEActivityRecruitVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/29.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEActivityRecruitVC.h"
#import "MECustomerClassifyListModel.h"
#import "MEActivityRecruitListCell.h"
#import "MEMenuHeaderView.h"
#import "MEPullDownListView.h"
#import "MERecruitRequestModel.h"
#import "MERecruitListModel.h"
#import "MERecruitDetailVC.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MEActivityRecruitVC ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,CLLocationManagerDelegate,RefreshToolDelegate>

@property (nonatomic, assign) NSInteger showId;

@property (nonatomic, strong) MEMenuHeaderView  *headerMenuView;    //顶部菜单
@property (nonatomic, strong) MEPullDownListView *pulldownMenuView; //下拉菜单
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLRefreshTool *refresh;

@property (nonatomic, strong) NSArray *titlesArr;                  //标题栏
@property (nonatomic, assign) NSInteger selectedIndex;             //当前选择顶部菜单

@property (nonatomic, strong) NSMutableArray *areaArr;             //地区
@property (nonatomic, strong) NSMutableArray *serviceTypeArr;      //服务类型
@property (nonatomic, strong) NSMutableArray *screenTypeArr;       //智能筛选

@property (nonatomic, strong) CLLocationManager *locationManager;  //定位管理器

@property (nonatomic, strong) AMapSearchAPI *search;  //定位管理器

@property (nonatomic, strong) MERecruitRequestModel *requestModel;


@end

@implementation MEActivityRecruitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动招募";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titlesArr = @[@"全市",@"服务类型",@"智能筛选"];
    self.selectedIndex = -1;
    self.requestModel = [[MERecruitRequestModel alloc] init];

    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];

        [self.locationManager startUpdatingLocation];
        [MECommonTool showMessage:@"定位中..." view:kMeCurrentWindow];
    }
    kMeWEAKSELF
    self.headerMenuView =
    [[MEMenuHeaderView alloc] initWithTitle:self.titlesArr
                                      frame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, 51)
                                       type:MEMenuHeaderViewSimple
                              tapIndexBlock:^(NSInteger index) {
                                  //显示下拉视图
                                  [weakSelf showDropDownMenu:index];
                                  weakSelf.selectedIndex = index;
                              }];
    [self.view addSubview:self.headerMenuView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+50, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self.view addSubview:line];
    
    [self.view addSubview:self.tableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refresh addRefreshView];
        [self requestRecruitServiceTypeWithNetWork];
    });
}

#pragma RefreshToolDelegate
- (NSDictionary *)requestParameter{
    return self.requestModel.mj_keyValues;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MERecruitListModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- CLLocationManagerDelegate
/*定位失败则执行此代理方法*/
/*定位失败弹出提示窗，点击打开定位按钮 按钮，会打开系统设置，提示打开定位服务*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /*设置提示提示用户打开定位服务*/
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok =[UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /*打开定位设置*/
        NSURL * settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingsURL];
    }];
    UIAlertAction * cacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [alert addAction:cacel];
    [self presentViewController:alert animated:YES completion:nil];
}
/*定位成功后则执行此代理方法*/
#pragma mark 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    /*旧值*/
    CLLocation * currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    /*打印当前经纬度*/
    NSLog(@"%f%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    self.requestModel.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.requestModel.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    /*地理反编码 -- 可以根据地理位置（经纬度）确认位置信息 （街道、门牌）*/
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark * placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
//                currentCity = @"无法定位当前城市";
                currentCity = placeMark.administrativeArea;
            }
            /*看需求定义一个全局变量来接受赋值*/
            NSLog(@"当前国家:%@",placeMark.country);/*当前国家*/
            NSLog(@"当前城市:%@",currentCity);/*当前城市*/
            NSLog(@"当前位置:%@",placeMark.subLocality);/*当前位置*/
            NSLog(@"当前街道:%@",placeMark.thoroughfare);/*当前街道*/
            NSLog(@"具体地址:%@",placeMark.name);/*具体地址 ** 市 ** 区** 街道*/
            NSLog(@"具体行政区:%@",placeMark.areasOfInterest);
            self.requestModel.province = kMeUnNilStr(placeMark.administrativeArea);
            self.requestModel.city = kMeUnNilStr(currentCity);
            [self requestDistrictDatasWithCity:currentCity];
        }
        else if (error == nil&&placemarks.count == 0){
            NSLog(@"没有地址返回");
        }
        else if (error){
            NSLog(@"location error:%@",error);
        }
    }];
    
    [_locationManager stopUpdatingLocation];
}
#pragma mark -- AMapSearchDelegate 高德地图
- (void)requestDistrictDatasWithCity:(NSString *)city{
    //iOS 搜索功能 v4.x 版本设置 Key：
    [AMapServices sharedServices].apiKey = @"93e976b9207139b2451560e01981f984";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
//    设置行政区划查询参数
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = city;
    dist.requireExtension = YES;
    //发起行政区划查询
    [self.search AMapDistrictSearch:dist];
}

#pragma mark --
//通过 response.districts 返回该行政区划下级的区划对象
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response {
    if (self.areaArr.count > 0) {
        [self.areaArr removeAllObjects];
    }
    [self.areaArr addObject:@"全市"];
    if (response == nil) {
        return;
    }
    //解析response获取行政区划114.085947, 22.547000
    for (AMapDistrict *dist in response.districts) {
//        NSLog(@"name:%@==========adcode:%@",dist.name,dist.adcode);
        for (AMapDistrict *dis in dist.districts) {
//            NSLog(@"~~~~~name:%@",dis.name);
            [self.areaArr addObject:dis.name];
        }
    }
}
//当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //重置与隐藏筛选控件
    [self.headerMenuView reset];
    if (self.pulldownMenuView.isVisible) {
        [self.pulldownMenuView dismiss];
        self.pulldownMenuView = nil;
    }
}

- (void)showDropDownMenu:(NSInteger)index {
    kMeWEAKSELF
    switch (index) {
        case 0://地区
            [weakSelf showAreaAlertWithIndex:index];
            break;
        case 1://服务类型
            [weakSelf showServiceTypeWithIndex:index];
            break;
        case 2://智能筛选
            [weakSelf showScreenTypeWithIndex:index];
            break;
        default:
            break;
    }
}

- (void)showAreaAlertWithIndex:(NSInteger)index {
    
    kMeWEAKSELF
    BOOL isReturn = [weakSelf dismissCustomViewWithIndex:index];
    if (isReturn) {
        return;
    }
    
    NSMutableArray *tempArray = [weakSelf.areaArr mutableCopy];
    NSArray *items = [tempArray mutableCopy];
    [weakSelf.pulldownMenuView showWithItems:items
                                  isMultiple:NO
                                     originY:kMeNavBarHeight+51
                        pulldownMenuViewType:MEPulldownListViewRow
                               tapIndexBlock:^(NSArray * _Nonnull indexs) {
                                   [weakSelf.headerMenuView reset];
                                   [weakSelf.pulldownMenuView dismiss];
                                   weakSelf.pulldownMenuView = nil;
                                   if(!indexs.count) return;
                                   
                                   NSLog(@"选中了%@",items[[[indexs firstObject] intValue]]);
                                   
                                   NSString *area = items[[[indexs firstObject] intValue]];
                                   weakSelf.requestModel.area = area;
                                   
                                   if ([area isEqualToString:@"全市"]) {
                                       weakSelf.requestModel.area = @"";
                                   }
                                   [weakSelf reloadHeaderMenuViewWithIndex:index andTitleString:area];
                                   [weakSelf.refresh reload];
                               }];
}

- (void)showServiceTypeWithIndex:(NSInteger)index {
    
    kMeWEAKSELF
    BOOL isReturn = [weakSelf dismissCustomViewWithIndex:index];
    if (isReturn) {
        return;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [weakSelf.serviceTypeArr enumerateObjectsUsingBlock:^(MECustomerClassifyListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray addObject:kMeUnNilStr(model.classify_name)];
    }];
    NSArray *items = [tempArray mutableCopy];
    [weakSelf.pulldownMenuView showWithItems:items
                                  isMultiple:NO
                                     originY:kMeNavBarHeight+51
                        pulldownMenuViewType:MEPulldownListViewRow
                               tapIndexBlock:^(NSArray *indexs) {
                                   [weakSelf.headerMenuView reset];
                                   [weakSelf.pulldownMenuView dismiss];
                                   weakSelf.pulldownMenuView = nil;
                                   if(!indexs.count) return;
                                   
                                   NSLog(@"选中了%@",items[[[indexs firstObject] intValue]]);
                                   
                                   NSString *service = items[[[indexs firstObject] intValue]];
                                   MECustomerClassifyListModel *model = weakSelf.serviceTypeArr[[[indexs firstObject] intValue]];
                                   
                                   weakSelf.requestModel.classify_id = [NSString stringWithFormat:@"%@",@(model.idField)];
                                   if ([service isEqualToString:@"全部"]) {
                                       service = @"服务类型";
                                   }
                                   [weakSelf reloadHeaderMenuViewWithIndex:index andTitleString:service];
                                   [weakSelf.refresh reload];
                               }];
    
}

- (void)showScreenTypeWithIndex:(NSInteger)index {
    
    kMeWEAKSELF
    BOOL isReturn = [weakSelf dismissCustomViewWithIndex:index];
    if (isReturn) {
        return;
    }
    
    NSMutableArray *tempArray = [weakSelf.screenTypeArr mutableCopy];
    NSArray *items = [tempArray mutableCopy];
    [weakSelf.pulldownMenuView showWithItems:items
                                  isMultiple:NO
                                     originY:kMeNavBarHeight+51
                        pulldownMenuViewType:MEPulldownListViewRow
                               tapIndexBlock:^(NSArray *indexs) {
                                   [weakSelf.headerMenuView reset];
                                   [weakSelf.pulldownMenuView dismiss];
                                   weakSelf.pulldownMenuView = nil;
                                   if(!indexs.count) return;
                                   
                                   NSLog(@"选中了%@",items[[[indexs firstObject] intValue]]);
                                   
                                   NSString *screenType = items[[[indexs firstObject] intValue]];
                                   weakSelf.requestModel.screen_type = [NSString stringWithFormat:@"%d",[[indexs firstObject] intValue]];
                                   
                                   [weakSelf reloadHeaderMenuViewWithIndex:index andTitleString:screenType];
                                   [weakSelf.refresh reload];
                               }];
    
}

- (BOOL)dismissCustomViewWithIndex:(NSInteger)index {
    BOOL isReturn = NO;
    if(self.pulldownMenuView.isVisible){
        [self.pulldownMenuView dismiss];
        self.pulldownMenuView = nil;
        if (self.selectedIndex == index) {
            isReturn = YES;
        }
    }
    return isReturn;
}

- (void)reloadHeaderMenuViewWithIndex:(NSInteger)index andTitleString:(NSString *)title {
    kMeWEAKSELF
    NSMutableArray *titles = [NSMutableArray arrayWithArray:weakSelf.titlesArr];
    [titles replaceObjectAtIndex:index withObject:title];
    weakSelf.headerMenuView.resetTitles = titles.mutableCopy;
    weakSelf.titlesArr = titles.mutableCopy;
    [weakSelf.headerMenuView reset];
}

#pragma mark -- Networking
//公益秀详情
- (void)requestRecruitServiceTypeWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetRecruitServiceTypeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.serviceTypeArr = [MECustomerClassifyListModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            MECustomerClassifyListModel *model = [[MECustomerClassifyListModel alloc] init];
            model.classify_name = @"全部";
            model.idField = 0;
            [strongSelf.serviceTypeArr insertObject:model atIndex:0];
        }
    } failure:^(id object) {
    }];
}

#pragma mark - tableView deleagte and sourcedata
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEActivityRecruitListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEActivityRecruitListCell class]) forIndexPath:indexPath];
    MERecruitListModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 266;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MERecruitListModel *model = self.refresh.arrData[indexPath.row];
    MERecruitDetailVC *vc = [[MERecruitDetailVC alloc] initWithRecruitId:model.idField latitude:kMeUnNilStr(model.latitude) longitude:kMeUnNilStr(model.longitude)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma setter&&getter
- (MEPullDownListView *)pulldownMenuView {
    if(!_pulldownMenuView){
        _pulldownMenuView = [MEPullDownListView pulldownMenu];
    }
    return _pulldownMenuView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight+51, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-51) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEActivityRecruitListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEActivityRecruitListCell class])];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonRecruitGetList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"暂无相关活动";
        }];
    }
    return _refresh;
}

- (NSMutableArray *)areaArr {
    if (!_areaArr) {
        _areaArr = [[NSMutableArray alloc] init];
    }
    return _areaArr;
}

- (NSMutableArray *)serviceTypeArr {
    if (!_serviceTypeArr) {
        _serviceTypeArr = [[NSMutableArray alloc] init];
    }
    return _serviceTypeArr;
}

- (NSMutableArray *)screenTypeArr {
    if (!_screenTypeArr) {
        _screenTypeArr = @[@"智能筛选",@"最新发布",@"距离最近"].mutableCopy;
    }
    return _screenTypeArr;
}

@end

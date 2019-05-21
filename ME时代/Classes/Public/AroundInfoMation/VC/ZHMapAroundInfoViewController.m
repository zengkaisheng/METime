//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
//
//  Created by aimoke on 16/11/9.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHMapAroundInfoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZHPlaceInfoModel.h"
#import "ZHPlaceInfoTableViewCell.h"
#import <objc/runtime.h>
#import "MESearchNearAddressVC.h"
#define DEFAULTSPAN 50
#define CellIdntifier @"placeInfoCellIdentifier"

@interface ZHMapAroundInfoViewController (){
    BOOL _haveGetUserLocation;//是否获取到用户位置
    CLGeocoder *_geocoder;
    NSMutableArray *_infoArray;//周围信息
    UIImageView *_imgView;//中间位置标志视图
    BOOL _spanBool;//是否是滑动
    BOOL _pinchBool;//是否缩放
    CLLocationManager *_locationManager;
}
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation ZHMapAroundInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    self.showTableView.tableFooterView = [UIView new];
    _spanBool = NO;
    _pinchBool = NO;
    [self.showTableView registerNib:[UINib nibWithNibName:@"ZHPlaceInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdntifier];
    _geocoder=[[CLGeocoder alloc]init];
    _infoArray = [NSMutableArray array];
    _haveGetUserLocation = NO;
 
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    //打印完后我们发现有个View带有手势数组其类型为_MKMapContentView获取Span和Pinch手势
    for (UIView *view in self.mapView.subviews) {
        NSString *viewName = NSStringFromClass([view class]);
        if ([viewName isEqualToString:@"_MKMapContentView"]) {
            UIView *contentView = view;//[self.mapView valueForKey:@"_contentView"];
            for (UIGestureRecognizer *gestureRecognizer in contentView.gestureRecognizers) {
                if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewSpanGesture:)];
                }
                if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
                    [gestureRecognizer addTarget:self action:@selector(mapViewPinchGesture:)];
                }
            }

        }
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self resetTableHeadView];
}

//重新定位
- (IBAction)backUserLocationClick:(id)sender {
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021252, 0.014720);
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
    _spanBool = YES;
}

- (void)searchLoaction{
    MESearchNearAddressVC *vc = [[MESearchNearAddressVC alloc]init];
    kMeWEAKSELF
    vc.contentBlock = ^(ZHPlaceInfoModel *model) {
        kMeSTRONGSELF
        MKCoordinateSpan span = MKCoordinateSpanMake(0.021252, 0.014720);
        strongSelf->_spanBool = YES;
        [strongSelf.mapView setRegion:MKCoordinateRegionMake(model.coordinate, span) animated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
    
#pragma mark - MKMapViewDelegate

/**
 完成用户位置更新的时候 调用
 MKUserLocation : 大头针模型
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"userLocation:longitude:%f---latitude:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    if (!_haveGetUserLocation) {
        if (self.mapView.userLocationVisible) {
            _haveGetUserLocation = YES;
            [self getAddressByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            [self addCenterLocationViewWithCenterPoint:self.mapView.center];
        }
    }
}

/**
 当地图显示区域发生改变后, 会调用的方法
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    if (_imgView && (_spanBool||_pinchBool)) {
        [_infoArray removeAllObjects];
        [self.showTableView reloadData];
        [self resetTableHeadView];
        CGPoint mapCenter = self.mapView.center;
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:mapCenter toCoordinateFromView:self.mapView];
        [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
        _imgView.center = CGPointMake(mapCenter.x, mapCenter.y-15);
        kMeWEAKSELF
        [UIView animateWithDuration:0.2 animations:^{
            kMeSTRONGSELF
            strongSelf->_imgView.center = mapCenter;
        }completion:^(BOOL finished){
            kMeSTRONGSELF
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    strongSelf->_imgView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            strongSelf->_imgView.transform = CGAffineTransformIdentity;
                        }completion:^(BOOL finished){
                            if (finished) {
                                strongSelf->_spanBool = NO;
                            }
                        }];
                    }
                }];
            }
        }];
    }
   
}


#pragma mark - Private Methods
-(void)resetTableHeadView{
    if (_infoArray.count>0) {
        self.showTableView.tableHeaderView = nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0)];
        view.backgroundColor = self.showTableView.backgroundColor;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.center = view.center;
        [indicatorView startAnimating];
        [view addSubview:indicatorView];
        self.showTableView.tableHeaderView = view;
    }
}

//移动定位坐标
-(void)addCenterLocationViewWithCenterPoint:(CGPoint)point{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100, 18, 38)];
        _imgView.center = point;
        _imgView.image = [UIImage imageNamed:@"map_location"];
        _imgView.center = self.mapView.center;
        [self.view addSubview:_imgView];
    }
}

//获取附近地址信息
-(void)getAroundInfoMationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, DEFAULTSPAN, DEFAULTSPAN);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.region = region;
    request.naturalLanguageQuery = @"大厦|写字楼";
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    kMeWEAKSELF
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        kMeSTRONGSELF
        if (!error) {
            [self getAroundInfomation:response.mapItems];
        }else{
            strongSelf->_haveGetUserLocation = NO;
            NSLog(@"Quest around Error:%@",error.localizedDescription);
        }
    }];
}

// 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    kMeWEAKSELF
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        kMeSTRONGSELF
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initialData:placemarks];
                [self getAroundInfoMationWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
                [self.showTableView reloadData];
                [self resetTableHeadView];
            });
        }else{
            strongSelf->_haveGetUserLocation = NO;
            NSLog(@"error:%@",error.localizedDescription);
        }
        
    }];
}

#pragma mark - Initial Data

-(void)initialData:(NSArray *)places{
    [_infoArray removeAllObjects];
    for (CLPlacemark *placemark in places) {
        ZHPlaceInfoModel *model = [[ZHPlaceInfoModel alloc]init];
        model.name = placemark.name;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        
        model.address = [NSString stringWithFormat:@"%@ %@ %@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
        model.detailsAddress = [NSString stringWithFormat:@"%@%@",placemark.thoroughfare,placemark.name];
        model.province = placemark.administrativeArea;
        model.district = placemark.subLocality;
        [_infoArray insertObject:model atIndex:0];
    }
}

-(void)getAroundInfomation:(NSArray *)array{
    for (MKMapItem *item in array) {
        MKPlacemark * placemark = item.placemark;
        ZHPlaceInfoModel *model = [[ZHPlaceInfoModel alloc]init];
        model.name = placemark.name;
        model.thoroughfare = placemark.thoroughfare;
        model.subThoroughfare = placemark.subThoroughfare;
        model.city = placemark.locality;
        model.coordinate = placemark.location.coordinate;
        model.address = [NSString stringWithFormat:@"%@ %@ %@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
        model.province = placemark.administrativeArea;
        model.district = placemark.subLocality;
        model.detailsAddress = [NSString stringWithFormat:@"%@%@",placemark.thoroughfare,placemark.name];
        [_infoArray addObject:model];
    }
    [self.showTableView reloadData];
}


#pragma mark － TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _infoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHPlaceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdntifier forIndexPath:indexPath];
    ZHPlaceInfoModel *model = [_infoArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.name;
    cell.subTitleLabel.text = model.thoroughfare;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHPlaceInfoModel *model = [_infoArray objectAtIndex:indexPath.row];
    kMeCallBlock(_contentBlock,model);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - touchs

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"moved");
    _spanBool = YES;
}

#pragma mark - MapView Gesture
-(void)mapViewSpanGesture:(UIPanGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"SpanGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
             NSLog(@"SpanGesture Changed");
            _spanBool = YES;
        }
            break;
        case UIGestureRecognizerStateCancelled:{
             NSLog(@"SpanGesture Cancelled");
        }
            break;
        case UIGestureRecognizerStateEnded:{
             NSLog(@"SpanGesture Ended");
        }
            break;
        default:
            break;
    }
}

-(void)mapViewPinchGesture:(UIGestureRecognizer*)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"PinchGesture Began");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"PinchGesture Changed");
            _pinchBool = YES;
        }
            
            break;
        case UIGestureRecognizerStateCancelled:{
            NSLog(@"PinchGesture Cancelled");
        }
            
            break;
        case UIGestureRecognizerStateEnded:{
            _pinchBool = NO;
            NSLog(@"PinchGesture Ended");
        }
            break;
            
        default:
            break;
    }

}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-10, 0, 30, 25);
        _btnRight.contentMode = UIViewContentModeRight;
        [_btnRight setImage:[UIImage imageNamed:@"common_nav_btn_search"] forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(searchLoaction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end

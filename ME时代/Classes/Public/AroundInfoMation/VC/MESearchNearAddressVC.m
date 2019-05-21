//
//  MESearchNearAddressVC.m
//  ME时代
//
//  Created by hank on 2019/2/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MESearchNearAddressVC.h"
#import "MELocationCLLModel.h"
#import "ZHPlaceInfoModel.h"
#import "ZHPlaceInfoTableViewCell.h"

#define MESearchNearAddressVCCellIdntifier @"placeInfoCellIdentifier"

@interface MESearchNearAddressVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    MELocationCLLModel *_lllModel;
    NSMutableArray *_infoArray;//周围信息
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constopMargin;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *showTableView;

@end

@implementation MESearchNearAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArray = [NSMutableArray array];
    _constopMargin.constant = kMeNavBarHeight;
    self.title = @"搜索";
    kMeWEAKSELF
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MELocationHelper sharedHander] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        kMeSTRONGSELF
        strongSelf->_lllModel = [[MELocationHelper sharedHander] getLocationModel];
        [MBProgressHUD hideHUDForView:strongSelf.view];
        [strongSelf initSomeThing];
    } failure:^{
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideHUDForView:strongSelf.view];
    }];
}

- (void)initSomeThing{
     self.showTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
     [self.showTableView registerNib:[UINib nibWithNibName:@"ZHPlaceInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MESearchNearAddressVCCellIdntifier];
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
    ZHPlaceInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MESearchNearAddressVCCellIdntifier forIndexPath:indexPath];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(kMeUnNilStr(searchBar.text).length==0){
        [_infoArray removeAllObjects];
        return;
    }
    CLLocationCoordinate2D cl = {_lllModel.lat,_lllModel.lng};
    [self getAroundInfoMationWithCoordinate:cl search:searchBar.text];
}

-(void)getAroundInfoMationWithCoordinate:(CLLocationCoordinate2D)coordinate search:(NSString*)search{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.region = region;
    request.naturalLanguageQuery = kMeUnNilStr(search);
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    kMeWEAKSELF
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        kMeSTRONGSELF
        [MBProgressHUD hideHUDForView:strongSelf.view];
        [strongSelf->_infoArray removeAllObjects];
        if (!error) {
            [strongSelf getAroundInfomation:response.mapItems];
        }
    }];
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
        model.address = [NSString stringWithFormat:@"%@%@%@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
        model.detailsAddress = [NSString stringWithFormat:@"%@%@",placemark.thoroughfare,placemark.name];
        [_infoArray addObject:model];
    }
    [self.showTableView reloadData];
}

@end

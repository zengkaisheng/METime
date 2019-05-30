//
//  MENewFilterGoodsVC.m
//  ME时代
//
//  Created by gao lei on 2019/5/30.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MENewFilterGoodsVC.h"
#import "MENewFilterHeaderView.h"

#import "MEPinduoduoCoupleModel.h"
#import "MENewProductCell.h"
#import "MECoupleHomeMainCell.h"
#import "MECoupleHomeMainGoodGoodsCell.h"


#import "MEGoodModel.h"
#import "MECoupleModel.h"
#import "MEAdModel.h"

#import "MENewFilterPopularizeCell.h"
#import "MECoupleMailDetalVC.h"

@interface MENewFilterGoodsVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>
{
    NSArray *_productArr;
    NSArray *_mainArr;
    NSString *_top_banner_image;
    NSString *_banner_image;
    NSString *_banner_midddle_image;
}
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) MENewFilterHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *bannerArr;

@end

@implementation MENewFilterGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"efc388"];
//    self.bannerArr = [NSMutableArray array];
    _productArr = [NSArray array];
    _mainArr = [NSArray array];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.refresh addRefreshView];
}

- (void)requestNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //原优选商品
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postFetchProductsWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id data = responseObject.data[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                strongSelf->_productArr = [MEGoodModel mj_objectArrayWithKeyValuesArray:data];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
             dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postFetchYouxianBannerWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id data = responseObject.data;
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)data;
                strongSelf->_top_banner_image = dict[@"banner_top_background"][@"ad_img"];
                strongSelf->_banner_image = dict[@"banner_img"][@"ad_img"];
                strongSelf->_banner_midddle_image = dict[@"banner_middle"][@"ad_img"];
//                MEAdModel *topBackModel = [MEAdModel mj_setKeyValues:dict[@"banner_top_background"]];
//                [strongSelf->_bannerArr addObject:topBackModel];
//
//                MEAdModel *bannerModel = [MEAdModel mj_setKeyValues:dict[@"banner_img"]];
//                [strongSelf->_bannerArr addObject:bannerModel];
//
//                MEAdModel *bannerMiddleModel = [MEAdModel mj_setKeyValues:dict[@"banner_middle"]];
//                [strongSelf->_bannerArr addObject:bannerMiddleModel];
            }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    //拼多多
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool postGetPinduoduoCommondPoductWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id arrDIc = responseObject.data[@"goods_search_response"][@"goods_list"];
            if([arrDIc isKindOfClass:[NSArray class]]){
                strongSelf->_mainArr = [MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:arrDIc];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
         dispatch_semaphore_signal(semaphore);
        }];
    });
    kMeWEAKSELF
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf->_headerView setUIWithBackgroundImage:kMeUnNilStr(strongSelf->_top_banner_image) bannerImage:kMeUnNilStr(strongSelf->_banner_image)];
            [strongSelf.tableView reloadData];
        });
    });
}

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNetWork];
    }
    return @{@"sort_type":@"12"};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:data]];
}
#pragma mark -- UITableviewDelegate  && UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MENewProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewProductCell class]) forIndexPath:indexPath];
        [productCell setUIWithArr:_productArr];
        return productCell;
    }else  if (indexPath.section == 1) {
        MENewFilterPopularizeCell *maincell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewFilterPopularizeCell class]) forIndexPath:indexPath];
        [maincell setUIWithArr:_mainArr];
        [maincell setbgImageViewWithImage:_banner_midddle_image];
        return maincell;
    }
    MECoupleHomeMainGoodGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MECoupleHomeMainGoodGoodsCell class]) forIndexPath:indexPath];
    kMeWEAKSELF
    cell.selectBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        MEPinduoduoCoupleModel *model = strongSelf.refresh.arrData[index];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    [cell setPinduoduoUIWithArr:self.refresh.arrData];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [MENewProductCell getCellHeightWithArr:_productArr];
    }else if (indexPath.section == 1) {
        return _mainArr.count>0?260:0;
    }
    return [MECoupleHomeMainGoodGoodsCell getCellHeightWithArr:self.refresh.arrData];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, IS_iPhoneX?10:0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-(IS_iPhoneX?10:0)) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewProductCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewProductCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewFilterPopularizeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewFilterPopularizeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleHomeMainGoodGoodsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MECoupleHomeMainGoodGoodsCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kMEf5f4f4;
    }
    return _tableView;
}

- (MENewFilterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MENewFilterHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 223 * kMeFrameScaleX());
    }
    return _headerView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonGetRecommendGoodsLit)];
        _refresh.isPinduoduoCoupleMater = YES;
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showFailView = NO;
    }
    return _refresh;
}

@end

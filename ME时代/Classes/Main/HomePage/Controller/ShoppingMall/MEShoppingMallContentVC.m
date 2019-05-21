//
//  MEShoppingMallContentVC.m
//  ME时代
//
//  Created by hank on 2018/12/18.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEShoppingMallContentVC.h"
#import "MEFilterMainModel.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEGoodModel.h"
#import "MEAdModel.h"
#import "MEHomePageSaveModel.h"
#import "MEShoppingMallCell.h"

@interface MEShoppingMallContentVC ()<UITableViewDelegate, UITableViewDataSource,RefreshToolDelegate,SDCycleScrollViewDelegate>{
    MEFilterMainModel *_model;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong) UIView *sdView;
@property (nonatomic,strong) NSArray *arrAdModel;
@end

@implementation MEShoppingMallContentVC

- (instancetype)initWithModel:(MEFilterMainModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
}

- (void)requestSD{
    kMeWEAKSELF
    [MEPublicNetWorkTool postAdWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            NSArray *banner_headArr = responseObject.data[@"banner_head"];
            NSArray *arr = [MEAdModel mj_objectArrayWithKeyValuesArray:banner_headArr];
            [MEHomePageSaveModel saveAdsModel:arr];
            strongSelf.arrAdModel = arr;
            [strongSelf setAdUI];
        }else{
            strongSelf.arrAdModel = [MEHomePageSaveModel getAdsModel];
            [strongSelf setAdUI];
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        strongSelf.arrAdModel = [MEHomePageSaveModel getAdsModel];
        [strongSelf setAdUI];
    }];
}


- (void)setAdUI{
    __block NSMutableArray *arrImage = [NSMutableArray array];
    [_arrAdModel enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    self.cycleScrollView.imageURLStringsGroup = arrImage;
    self.tableView.tableHeaderView = self.sdView;
    [self.tableView reloadData];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MEAdModel *model = kMeUnArr(_arrAdModel)[index];
    METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (NSDictionary *)requestParameter{
    if(_model.idField == 0 && self.refresh.pageIndex == 1){
        [self requestSD];
    }
    return @{@"category_id":@(_model.idField),
             @"uid":kMeUnNilStr(kCurrentUser.uid)
             };
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEGoodModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEGoodModel *model = self.refresh.arrData[indexPath.row];
    MEShoppingMallCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEShoppingMallCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMEShoppingMallCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodModel *model = self.refresh.arrData[indexPath.row];
    METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
    [self.navigationController pushViewController:dvc animated:YES];
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeStatusBarHeight-kCategoryViewHeight-kSerachHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEShoppingMallCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEShoppingMallCell class])];
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
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommonFindGoods)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有产品";
        }];
    }
    return _refresh;
}

- (SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        CGFloat w = SCREEN_WIDTH - 20;
        CGFloat h = (w * 300)/710;
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 10, w, h) imageURLStringsGroup:nil];
        _cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.autoScrollTimeInterval = 4;
        _cycleScrollView.delegate =self;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.placeholderImage = kImgBannerPlaceholder;
        _cycleScrollView.currentPageDotColor = kMEPink;
        _cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.cornerRadius = 8;
        _cycleScrollView.clipsToBounds = YES;
    }
    return _cycleScrollView;
}

- (UIView *)sdView{
    if(!_sdView){
        CGFloat w = SCREEN_WIDTH - 20;
        CGFloat h = (w * 300)/710;
        _sdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h+24+10)];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, h+24, SCREEN_WIDTH, 10)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [_sdView addSubview:self.cycleScrollView];
        [_sdView addSubview:lineView];
    }
    return _sdView;
}



@end

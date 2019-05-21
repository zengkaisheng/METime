//
//  MEHomePageVC.m
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEHomePageVC.h"
#import "MEHomePageHeaderView.h"
#import "MEHomeMiaoDongCell.h"
#import "MEBaoQiangCell.h"
#import "MEHomeMainCell.h"
#import "MEProductListVC.h"
#import "MEHomePageSaveModel.h"
#import "MEServiceDetailsVC.h"
#import "MEProductDetailsVC.h"
#import "MEAdModel.h"
#import "MEGoodModel.h"
#import "MEHomeGoodModel.h"
#import "MEActiveVC.h"
#import "MEServiceDetailsVC.h"
#import "MEProductSearchVC.h"
#import "MEFilterVC.h"

@interface MEHomePageVC ()<UITableViewDelegate,UITableViewDataSource>{
    MEAdModel *_productAdModel;
    MEAdModel *_serviceAdModel;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic,strong) MEHomePageHeaderView *headerView;
@property (nonatomic,strong) NSArray *arrMainProductModel;
@property (nonatomic,strong) NSArray *arrMainPrjoctModel;
@property (nonatomic,strong) NSArray *arrMainTopModel;
//@property (nonatomic,strong) NSString *productImg;
//@property (nonatomic,strong) NSString *serviceImg;
@property (nonatomic, strong) UIButton *btnRight;
@end

@implementation MEHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
//    _productAdModel = [MEAdModel new];
//    _serviceAdModel = [MEAdModel new];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNetWork)];
    [self.tableView.mj_header beginRefreshing];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
}

- (void)requestNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postAdWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                NSArray *banner_headArr = responseObject.data[@"banner_head"];
                NSArray *arr = [MEAdModel mj_objectArrayWithKeyValuesArray:banner_headArr];
                [MEHomePageSaveModel saveAdsModel:arr];
                [strongSelf.headerView setArrModel:arr];
                
                NSArray *banner_goodsArr = responseObject.data[@"banner_goods"];
                if([kMeUnArr(banner_goodsArr) count]){
                    NSDictionary *dic = banner_goodsArr[0];
                    strongSelf->_productAdModel = [MEAdModel mj_objectWithKeyValues:dic];
                }
                NSArray *banner_serviceArr = responseObject.data[@"banner_service"];
                if([kMeUnArr(banner_serviceArr) count]){
                    NSDictionary *dic = banner_serviceArr[0];
                    strongSelf->_serviceAdModel = [MEAdModel mj_objectWithKeyValues:dic];
                }
                dispatch_semaphore_signal(semaphore);
            }else{
                [strongSelf.headerView setArrModel:[MEHomePageSaveModel getAdsModel]];
                dispatch_semaphore_signal(semaphore);
            }
        } failure:^(id object) {
            kMeSTRONGSELF
            [strongSelf.headerView setArrModel:[MEHomePageSaveModel getAdsModel]];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGoodsListWithType:MEGoodsTypeNetHotStyle successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            NSArray *arr = [MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            strongSelf.arrMainTopModel = arr;
            [MEHomePageSaveModel saveHotModel:arr];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.arrMainTopModel = [MEHomePageSaveModel getHotModel];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
//    dispatch_group_async(group, queue, ^{
//        [MEPublicNetWorkTool postGoodsTypeWithArticleCategoryId:19 successBlock:^(ZLRequestResponse *responseObject) {
//            kMeSTRONGSELF
//            MEHomeGoodModel *model = [MEHomeGoodModel mj_objectWithKeyValues:responseObject.data];
////            strongSelf->_productImg = kMeUnNilStr(model.mask_img);
//            dispatch_semaphore_signal(semaphore);
//        } failure:^(id object) {
//            dispatch_semaphore_signal(semaphore);
//        }];
//    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postHomeRecommendWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            NSArray *arr = [MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            strongSelf.arrMainProductModel = arr;
            [MEHomePageSaveModel saveProductModel:arr];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.arrMainProductModel = [MEHomePageSaveModel getProductModel];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGoodsTypeWithArticleCategoryId:20 successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            MEHomeGoodModel *model = [MEHomeGoodModel mj_objectWithKeyValues:responseObject.data];
//            strongSelf->_serviceImg = kMeUnNilStr(model.mask_img);
            NSArray *arr = model.goodsList;
            strongSelf.arrMainPrjoctModel = arr;
            [MEHomePageSaveModel saveServiceModel:arr];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.arrMainPrjoctModel = [MEHomePageSaveModel getServiceModel];
            dispatch_semaphore_signal(semaphore);
        }];

    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView reloadData];
        });
    });
}

#pragma mark - Acction

//- (void)searchProduct:(UIButton *)btn{
//    MEProductSearchVC *svc = [[MEProductSearchVC alloc]init];
//    [self.navigationController pushViewController:svc animated:NO];
//}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
//        MEHomeMiaoDongCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeMiaoDongCell class]) forIndexPath:indexPath];
        return [UITableViewCell new];
    }else if(indexPath.row == 1){
        MEBaoQiangCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBaoQiangCell class]) forIndexPath:indexPath];
        [cell setUIWithArr:self.arrMainTopModel];
        kMeWEAKSELF
        cell.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            MEGoodModel *model = self.arrMainTopModel[index];
            MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
            [strongSelf.navigationController pushViewController:dvc animated:YES];
        };
        return cell;
    }else if(indexPath.row == 2){
        MEHomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeMainCell class]) forIndexPath:indexPath];
        if(_productAdModel){
            kSDLoadImg(cell.imgMainPic, kMeUnNilStr(_productAdModel.ad_img));
        }
        [cell setUIWithArr:self.arrMainProductModel];
        kMeWEAKSELF
        cell.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            MEGoodModel *model = self.arrMainProductModel[index];
            MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
            [strongSelf.navigationController pushViewController:dvc animated:YES];
        };
        cell.imgTouchBlock = ^{
            kMeSTRONGSELF
            if(strongSelf->_productAdModel){
                MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:strongSelf->_productAdModel.product_id];
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }
        };
        return cell;
    }else if(indexPath.row == 3){
        MEHomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeMainCell class]) forIndexPath:indexPath];
        if(_serviceAdModel){
             kSDLoadImg(cell.imgMainPic, kMeUnNilStr(_serviceAdModel.ad_img));
        }
        kMeWEAKSELF
        cell.indexBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            MEGoodModel *model = self.arrMainPrjoctModel[index];
            MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
            [strongSelf.navigationController pushViewController:dvc animated:YES];
        };
        cell.imgTouchBlock = ^{
            kMeSTRONGSELF
            if(strongSelf->_serviceAdModel){
                MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:strongSelf->_serviceAdModel.product_id];
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            }
        };
        [cell setServiceUIWithArr:self.arrMainPrjoctModel];
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 0.1;//MEHomeMiaoDongCellHeight;
    }else if(indexPath.row == 1){
        return  [MEBaoQiangCell getCellHeightWithArr:self.arrMainTopModel];
    }else if(indexPath.row == 2){
        return [MEHomeMainCell getCellHeightWithArrModel:self.arrMainProductModel];
    }else if(indexPath.row == 3){
        return [MEHomeMainCell getServiceCellHeightWithArrModel:self.arrMainPrjoctModel];
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:{
            MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetCommendStyle];
            [self.navigationController pushViewController:productList animated:YES];
        }
            break;
        case 3:{
//            self.tabBarController.selectedIndex = 1;
            MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetServiceStyle];
            [self.navigationController pushViewController:productList animated:YES];
//            kMeWEAKSELF
//            productList.finishBlock = ^{
//                kMeSTRONGSELF
//                strongSelf.tabBarController.selectedIndex = 1;
//            };
        }
            break;
        default:
            break;
    }

}


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeMiaoDongCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEHomeMiaoDongCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBaoQiangCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBaoQiangCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEHomeMainCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEHomePageHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[MEHomePageHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMEHomePageHeaderViewHeight)];
        kMeWEAKSELF
        _headerView.searchBlock = ^{
            kMeSTRONGSELF
            MEProductSearchVC *svc = [[MEProductSearchVC alloc]init];
            [strongSelf.navigationController pushViewController:svc animated:NO];
        };
        _headerView.filetBlock = ^{
            kMeSTRONGSELF
            MEFilterVC *svc = [[MEFilterVC alloc]init];
            [strongSelf.navigationController pushViewController:svc animated:YES];
        };
    }
    return _headerView;
}


//- (UIButton *)btnRight{
//    if(!_btnRight){
//        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
//        _btnRight.frame = CGRectMake(-10, 0, 30, 25);
//        _btnRight.contentMode = UIViewContentModeRight;
//        [_btnRight setImage:[UIImage imageNamed:@"common_nav_btn_search"] forState:UIControlStateNormal];
//        [_btnRight addTarget:self action:@selector(searchProduct:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btnRight;
//}



@end

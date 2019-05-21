//
//  MENewHomePage.m
//  ME时代
//
//  Created by hank on 2018/11/5.
//  Copyright © 2018年 hank. All rights reserved.
//  已废弃

#import "MENewHomePage.h"
#import "MENewHomePageHeaderView.h"
#import "MEHomePageSaveModel.h"
#import "MEAdModel.h"
#import "MENewBaoQiangCell.h"
#import "MEGoodModel.h"
#import "MEHomeGoodModel.h"
#import "MENewActiveCell.h"
#import "MENewHomeMainCell.h"
#import "MEGoodModel.h"
#import "MEProductListVC.h"
#import "MEProductDetailsVC.h"
#import "MEActiveVC.h"
#import "MEServiceDetailsVC.h"
#import "MERushBuyView.h"
#import "MENetListModel.h"
#import "MENoticeVC.h"

#import "MEPosterListVC.h"
#import "MEArticleListVC.h"
#import "MEVisiterHomeVC.h"
#import "MESNewHomePageVC.h"

typedef enum : NSUInteger {
    KMeHomeTypeCommond = 0,
    KMeHomeTypeActive = 1,
    KMeHomeTypeProduct = 2,
    KMeHomeTypeService = 3
} KMeHomeType;

const static CGFloat kSectionViewHeight = 67;

@interface MENewHomePage ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    KMeHomeType _type;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic,strong) MENewHomePageHeaderView *headerView;
@property (nonatomic, strong) SDCycleScrollView *sdView;
@property (nonatomic,strong) NSArray *arrMainProductModel;
@property (nonatomic,strong) NSArray *arrMainPrjoctModel;
@property (nonatomic,strong) NSArray *arrMainTopModel;
@property (nonatomic,strong) NSArray *arrAdModel;
@end

@implementation MENewHomePage

- (void)dealloc{
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
    _type = KMeHomeTypeCommond;
    [self.view addSubview:self.headerView];
    NSLog(@"%@",@(self.headerView.height));
    self.tableView.tableHeaderView = self.sdView;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNetWork)];
    [self.tableView.mj_header beginRefreshing];
//    [self getRushGood];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnInfo) name:kUnNoticeMessage object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
}

//- (void)userLogout{
//    self.headerView.viewForUnread.hidden =YES;
//}
//
//- (void)userLogin{
//    [self getUnInfo];
//}

//- (void)getUnInfo{
//    if([MEUserInfoModel isLogin]){
//        kMeWEAKSELF
//        [MEPublicNetWorkTool getUserHomeUnreadNoticeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
//            if([responseObject.data isKindOfClass:[NSDictionary class]]){
//                NSNumber *notice = responseObject.data[@"notice"];
//                NSNumber *order = responseObject.data[@"order"];
//                NSNumber *versions = responseObject.data[@"versions"];
//                NSInteger unread = [notice integerValue] + [order integerValue] +[versions integerValue];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    kMeSTRONGSELF
//                    if(strongSelf->_headerView){
//                        strongSelf.headerView.viewForUnread.hidden =!unread;
//                    }
//                });
//            }
//        } failure:^(id object) {
//            
//        }];
//    }
//}

//- (void)getRushGood{
//    kMeWEAKSELF
//    [MEPublicNetWorkTool postRushGoodWithsuccessBlock:^(ZLRequestResponse *responseObject) {
//        if([responseObject.data isKindOfClass:[NSDictionary class]]){
//            MEAdModel *model = [MEAdModel mj_objectWithKeyValues:responseObject.data];
//            [MERushBuyView ShowWithModel:model tapBlock:^{
//                kMeSTRONGSELF
//                strongSelf.tabBarController.selectedIndex = 0;
//                MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
//                [strongSelf.navigationController pushViewController:dvc animated:YES];
//            } cancelBlock:^{
//
//            } superView:weakSelf.view];
//        }
//    } failure:^(id object) {
//
//    }];
//}

- (void)requestNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    kMeWEAKSELF
    //ad
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postAdWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                NSArray *banner_headArr = responseObject.data[@"banner_head"];
                NSArray *arr = [MEAdModel mj_objectArrayWithKeyValuesArray:banner_headArr];
                [MEHomePageSaveModel saveAdsModel:arr];
                strongSelf.arrAdModel = arr;
                dispatch_semaphore_signal(semaphore);
            }else{
                strongSelf.arrAdModel = [MEHomePageSaveModel getAdsModel];
                dispatch_semaphore_signal(semaphore);
            }
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.arrAdModel = [MEHomePageSaveModel getAdsModel];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    //top
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGoodsListTopWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            MENetListModel *lmode = [MENetListModel mj_objectWithKeyValues:responseObject.data];
            NSArray *arr = [MEGoodModel mj_objectArrayWithKeyValuesArray:lmode.data];
            strongSelf.arrMainTopModel = arr;
            [MEHomePageSaveModel saveHotModel:arr];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf.arrMainTopModel = [MEHomePageSaveModel getHotModel];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    //product
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postHomeRecommendWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            MENetListModel *lmode = [MENetListModel mj_objectWithKeyValues:responseObject.data];
            NSArray *arr = [MEGoodModel mj_objectArrayWithKeyValuesArray:lmode.data];
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
            strongSelf.headerView.frame = CGRectMake(0, kMeStatusBarHeight, SCREEN_WIDTH, kMENewHomePageHeaderViewHeight);
            [strongSelf setAdUI];
//            [strongSelf getUnInfo];
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView reloadData];
        });
    });
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    switch (_type) {
        case KMeHomeTypeCommond:
            return  3;
            break;
        case KMeHomeTypeActive:
            return  1;
            break;
        case KMeHomeTypeProduct:
            return  1;
            break;
        case KMeHomeTypeService:
            return  1;
            break;
        default:
            return  0;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_type) {
        case KMeHomeTypeCommond:
            switch (section) {
                case KMeHomeTypeCommond:
                    return 1;
                    break;
                case KMeHomeTypeActive:
                    return 1;
                    break;
                case KMeHomeTypeProduct:
                    return self.arrMainProductModel.count;
                    break;
//                case KMeHomeTypeService:
//                    return self.arrMainPrjoctModel.count;
//                    break;
                default:
                    return 0;
                    break;
            }
            return  4;
            break;
        case KMeHomeTypeActive:
            return  1;
            break;
        case KMeHomeTypeProduct:
            return  self.arrMainProductModel.count;
            break;
        case KMeHomeTypeService:
            return  self.arrMainPrjoctModel.count;
            break;
        default:
            return  0;
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (_type) {
        case KMeHomeTypeCommond:
            switch (indexPath.section) {
                case KMeHomeTypeCommond:{
                    MENewBaoQiangCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewBaoQiangCell class]) forIndexPath:indexPath];
                    [cell setUIWithArr:self.arrMainTopModel];
                    kMeWEAKSELF
                    cell.indexBlock = ^(NSInteger index) {
                        kMeSTRONGSELF
                        MEGoodModel *model = self.arrMainTopModel[index];
                        MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
                        [strongSelf.navigationController pushViewController:dvc animated:YES];
                    };
                    return cell;
                }
                    break;
                case KMeHomeTypeActive:
                {
                    MENewActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewActiveCell class]) forIndexPath:indexPath];
                    return cell;
                }
                    break;
                case KMeHomeTypeProduct:{
                    MENewHomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewHomeMainCell class]) forIndexPath:indexPath];
                    MEGoodModel *model = self.arrMainProductModel[indexPath.row];
                    [cell setUIWithModel:model];
                    return cell;
                }
                    break;
//                case KMeHomeTypeService:{
//                    MENewHomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewHomeMainCell class]) forIndexPath:indexPath];
//                     MEGoodModel *model = self.arrMainPrjoctModel[indexPath.row];
//                    [cell setServiceUIWithModel:model];
//                    return cell;
//                }
//                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case KMeHomeTypeActive:{
            MENewActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewActiveCell class]) forIndexPath:indexPath];
            return cell;
        }
            break;
        case KMeHomeTypeProduct:{
               MENewHomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewHomeMainCell class]) forIndexPath:indexPath];
               MEGoodModel *model = self.arrMainProductModel[indexPath.row];
               [cell setUIWithModel:model];
               return cell;
        }
            break;
        case KMeHomeTypeService:{
            MENewHomeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MENewHomeMainCell class]) forIndexPath:indexPath];
            MEGoodModel *model = self.arrMainPrjoctModel[indexPath.row];
            [cell setServiceUIWithModel:model];
            return cell;
        }
            break;
        default:
            return  [UITableViewCell new];
            break;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (_type) {
        case KMeHomeTypeCommond:
            switch (indexPath.section) {
                case KMeHomeTypeCommond:{
                    return kMENewBaoQiangCellHeight;
                }
                    break;
                case KMeHomeTypeActive:
                    return kMENewActiveCellHeight;
                    break;
                case KMeHomeTypeProduct:
                    return [MENewHomeMainCell getCellHeight];
                    break;
//                case KMeHomeTypeService:
//                    return [MENewHomeMainCell getCellHeight];
//                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case KMeHomeTypeActive:
            return kMENewActiveCellHeight;
            break;
        case KMeHomeTypeProduct:
            return [MENewHomeMainCell getCellHeight];;
            break;
        case KMeHomeTypeService:
            return  [MENewHomeMainCell getCellHeight];;
            break;
        default:
            return  1;
            break;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (_type) {
        case KMeHomeTypeCommond:
            switch (indexPath.section) {
                case KMeHomeTypeActive:{
                    [self aciveAction];
                }
                    break;
                case KMeHomeTypeProduct:{
                    MEGoodModel *model = self.arrMainProductModel[indexPath.row];
                    MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
                    [self.navigationController pushViewController:dvc animated:YES];
                }
                    
                    break;
//                case KMeHomeTypeService:{
//                    MEGoodModel *model = self.arrMainPrjoctModel[indexPath.row];
//                    MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
//                    [self.navigationController pushViewController:dvc animated:YES];
//                }
//                    break;
                default:
                    break;
            }
            break;
        case KMeHomeTypeActive:
             [self aciveAction];
            break;
        default:
            break;
    }
}

- (void)aciveAction{

//    MEArticleListVC *vc = [[MEArticleListVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if([MEUserInfoModel isLogin]){
            MEActiveVC *avc = [[MEActiveVC alloc]init];
            [self.navigationController pushViewController:avc animated:YES];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            MEActiveVC *avc = [[MEActiveVC alloc]init];
            [strongSelf.navigationController pushViewController:avc animated:YES];
        } failHandler:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (_type) {
        case KMeHomeTypeCommond:
            switch (section) {
                case KMeHomeTypeCommond:{
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
                    return view;
                }
                    break;
                case KMeHomeTypeActive:{
                        UIView *view = [self getSectionViewWithTitle:@"活动专区"];
                        return  view;
                }
                    break;
                case KMeHomeTypeProduct:{
                    UIView *view = [self getSectionViewWithTitle:@"产品选购"];
                    return  view;
                }
                    break;
//                case KMeHomeTypeService:{
//                    UIView *view = [self getSectionViewWithTitle:@"服务选购"];
//                    return  view;
//                }
//                    break;
                default:
                    return 0;
                    break;
            }
            break;
        case KMeHomeTypeActive:{
            UIView *view = [self getSectionViewWithTitle:@"活动专区"];
            return  view;
        }
        break;
        case KMeHomeTypeProduct:{
            UIView *view = [self getSectionViewWithTitle:@"产品选购"];
            return  view;
        }
            break;
        case KMeHomeTypeService:{
            UIView *view = [self getSectionViewWithTitle:@"服务选购"];
            return  view;
        }
            break;
        default:
            {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
                return view;
            }
            break;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_type == KMeHomeTypeCommond && section==KMeHomeTypeCommond){
        return 10;
    }else{
        return kSectionViewHeight;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MEAdModel *model = kMeUnArr(_arrAdModel)[index];
    MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeStatusBarHeight+kMENewHomePageHeaderViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeStatusBarHeight-kMENewHomePageHeaderViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewBaoQiangCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewBaoQiangCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewActiveCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewActiveCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewHomeMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MENewHomeMainCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _tableView;
}

- (MENewHomePageHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MENewHomePageHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, kMeStatusBarHeight, SCREEN_WIDTH, kMENewHomePageHeaderViewHeight);
        kMeWEAKSELF
        _headerView.selectMemuBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            if(index == KMeHomeTypeProduct){
                MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetCommendStyle];
                [strongSelf.navigationController pushViewController:productList animated:YES];
                 [strongSelf.headerView returnCommon];
                strongSelf->_type = KMeHomeTypeCommond;
                [strongSelf.tableView reloadData];
                
            }else if (index == KMeHomeTypeService){
                [strongSelf.headerView returnCommon];
                MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetServiceStyle];
                [strongSelf.navigationController pushViewController:productList animated:YES];
                strongSelf->_type = KMeHomeTypeCommond;
                [strongSelf.tableView reloadData];
            }else{
                strongSelf->_type = index;
                [strongSelf.tableView reloadData];
            }
        };
    }
    return _headerView;
}

- (SDCycleScrollView *)sdView{
    if(!_sdView){
        _sdView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  210*kMeFrameScaleX())];
        _sdView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _sdView.clipsToBounds = YES;
        _sdView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
        _sdView.autoScrollTimeInterval = 4;
        _sdView.delegate =self;
        _sdView.backgroundColor = [UIColor whiteColor];
        _sdView.placeholderImage = kImgBannerPlaceholder;
        _sdView.currentPageDotColor = kMEPink;
    }
    return _sdView;
}

- (void)setAdUI{
    __block NSMutableArray *arrImage = [NSMutableArray array];
    [_arrAdModel enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    self.sdView.imageURLStringsGroup = arrImage;
}

- (UIView *)getSectionViewWithTitle:(NSString *)title{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSectionViewHeight)];
    view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, kSectionViewHeight-10)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.font = kMeFont(15);
    lbl.textColor = kMEblack;
    lbl.text = title;
    [view addSubview:lbl];
    return view;
}



@end

//
//  MEGroupProductDetailVC.m
//  ME时代
//
//  Created by gao lei on 2019/7/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupProductDetailVC.h"
#import "MEGoodDetailModel.h"
#import "MEGroupUserContentModel.h"
#import "MEShoppingCartAttrModel.h"

#import "MESkuBuyView.h"
#import "MEGroupDetailHeaderView.h"
#import "MEProductDetailsBottomView.h"
#import "MENewProductDetailsSectionView.h"
#import "MEGroupCountsCell.h"
#import "MEGroupUsersCell.h"
#import "TDWebViewCell.h"
#import "METhridProductDetailsSelectSkuCell.h"

#import "MEMakeOrderVC.h"
#import "MEShowGroupUserListView.h"
#import "MEGroupOrderDetailsVC.h"

#import "MECreateGroupShareVC.h"
#import "MEGroupOrderDetailModel.h"

typedef NS_ENUM(NSUInteger, kpurchaseViewType) {
    kpurchaseSelectSkuViewType,//选择规格
    kpurchaseViewBuyType,
    kpurchaseViewShoppingType,
};

@interface MEGroupProductDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_arrTitle;
    kpurchaseViewType _selectType;
    BOOL _error;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEGroupDetailHeaderView *headerView;
@property (nonatomic, strong) UIView *tableViewBottomView;
@property (nonatomic, strong) MEProductDetailsBottomView *bottomView;
@property (nonatomic, strong) MESkuBuyView *purchaseView;
@property (nonatomic, strong) MEGoodDetailModel *model;
@property (strong, nonatomic) TDWebViewCell *webCell;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSArray *groupUsers;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, assign) BOOL isSelf;

@end

@implementation MEGroupProductDetailVC

- (instancetype)initWithProductId:(NSInteger)productId {
    if (self = [super init]) {
        _productId = productId;
    }
    return self;
}

- (void)dealloc{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if(_purchaseView){
        [_purchaseView removeFromSuperview];
        [_purchaseView.layer removeAllAnimations];
    }
    kTDWebViewCellDidFinishLoadNotificationCancel
    kNSNotificationCenterDealloc
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拼团详情";
    self.view.backgroundColor = kMEf5f4f4;
    _arrTitle = @[@"",@"商品详情"];
    _error = NO;
    _count = @"0";
    self.isSelf = YES;
    self.groupUsers = [NSArray array];
    
    [self requestNetWorkWithGroupDetail];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGroupDetailsVC:) name:kGroupOrderReload object:nil];
}

- (void)showGroupDetailsVC:(NSNotification *)notifi {
    
    NSDictionary *info = (NSDictionary *)notifi.userInfo;
    [self requestNetWorkWithGroupOrderDetailWithOrderSn:kMeUnNilStr(info[@"order_sn"])];
}

- (void)showGroupUserListView {
    kMeWEAKSELF
    [MEShowGroupUserListView showGroupUserListViewWithArray:kMeUnArr(_groupUsers) selectedBlock:^(NSInteger index) {
        kMeSTRONGSELF
        MEGroupUserContentModel *contentModel = strongSelf.groupUsers[index];
        strongSelf.model.group_id = contentModel.uid;
        strongSelf.model.group_sn = [contentModel.group_sn integerValue];
        [strongSelf showBuyViewWithTypy:kpurchaseViewBuyType];
    } cancelBlock:^{
    } superView:self.view];
}

#pragma mark -- networking
- (void)requestNetWorkWithGroupOrderDetailWithOrderSn:(NSString *)orderSn{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGroupOrderDetailWithOrderSn:kMeUnNilStr(orderSn) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            
            MEGroupOrderDetailModel *model = [MEGroupOrderDetailModel mj_objectWithKeyValues:responseObject.data];
            if (model.order_status.intValue == 10) {
                MEGroupOrderDetailsVC *vc = [[MEGroupOrderDetailsVC alloc] initWithOrderSn:orderSn];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    } failure:^(id object) {
    }];
}

- (void)requestNetWorkWithGroupDetail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    hud.label.text = @"获取详情中...";
    hud.userInteractionEnabled = YES;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGroupDetailWithProductId:[NSString stringWithFormat:@"%ld",(long)self.productId] successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_model = [MEGoodDetailModel mj_objectWithKeyValues:responseObject.data];
            strongSelf->_model.buynum = 1;
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_error = YES;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGetGroupUsersWithProductId:[NSString stringWithFormat:@"%ld",(long)self.productId] successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = (NSDictionary *)responseObject.data;
                if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *users = (NSArray *)data[@"data"];
                    strongSelf.groupUsers = [MEGroupUserContentModel mj_objectArrayWithKeyValuesArray:users];
                    strongSelf.count = [NSString stringWithFormat:@"%@",data[@"count"]];
                }
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [hud hideAnimated:YES];
            if (strongSelf->_error) {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }else {
                [strongSelf setUIWIthModel:strongSelf->_model];
            }
        });
    });
}

- (void)requestGroupUserList {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    hud.label.text = @"";
    hud.userInteractionEnabled = YES;
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetGroupUsersWithProductId:[NSString stringWithFormat:@"%ld",(long)self.productId] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [hud hideAnimated:YES];
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)responseObject.data;
            if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *users = (NSArray *)data[@"data"];
                strongSelf.groupUsers = [MEGroupUserContentModel mj_objectArrayWithKeyValuesArray:users];
                strongSelf.count = [NSString stringWithFormat:@"%@",data[@"count"]];
            }
        }
        [strongSelf showGroupUserListView];
    } failure:^(id object) {
        [hud hideAnimated:YES];
    }];
}

- (void)setUIWIthModel:(MEGoodDetailModel *)model{
    _model = model;
    _selectType = kpurchaseSelectSkuViewType;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView setUIWithModel:model];
    self.tableView.tableFooterView = self.tableViewBottomView;
    [self.view addSubview:self.bottomView];
    self.bottomView.is_clerk_share = [_model.is_clerk_share integerValue];
    self.bottomView.productId = @(_model.product_id).description;
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kMEProductDetailsBottomViewHeight));
        //        make.width.equalTo(@(self.view.width));
        make.top.equalTo(@(self.view.bottom-kMEProductDetailsBottomViewHeight));
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(_model.content)] baseURL:nil];
    kMeWEAKSELF
    self.purchaseView.confirmBlock = ^{
        kMeSTRONGSELF
        switch (strongSelf->_selectType) {
            case kpurchaseSelectSkuViewType:{
                [strongSelf.headerView setUIWithModel:strongSelf->_model];
                [strongSelf.tableView reloadData];
            }
                break;
            case kpurchaseViewBuyType:{
                //生成订单
                strongSelf->_model.isGroup = YES;
                MEMakeOrderVC *vc = [[MEMakeOrderVC alloc]initWithIsinteral:NO goodModel:strongSelf->_model];
                vc.uid = kMeUnNilStr(strongSelf.uid);
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case kpurchaseViewShoppingType:{
                //加入购物车
                MEShoppingCartAttrModel *attrModle = [[MEShoppingCartAttrModel alloc]initWithGoodmodel:strongSelf->_model];
                attrModle.uid = kMeUnNilStr(strongSelf.uid);
                [MEPublicNetWorkTool postAddGoodForShopWithAttrModel:attrModle successBlock:^(ZLRequestResponse *responseObject) {
                    kNoticeReloadShopCart
                } failure:^(id object) {
                }];
            }
                break;
            default:
                break;
        }
        
    };
    self.purchaseView.failGetStoreBlock = ^{
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    self.purchaseView.sucessGetStoreBlock = ^{
        kMeSTRONGSELF
        [strongSelf.headerView setUIWithModel:strongSelf->_model];
    };
}

#pragma mark -- UITableviewDelegate
#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!section){
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                MEGroupCountsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGroupCountsCell class]) forIndexPath:indexPath];
                [cell setUIWithModel:self.model];
                return cell;
            }
                break;
            case 1:
            {
                if (self.groupUsers.count > 0) {
                    MEGroupUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGroupUsersCell class]) forIndexPath:indexPath];
                    [cell setUIWithArray:self.groupUsers count:self.count];
                    kMeWEAKSELF
                    cell.indexBlock = ^(NSInteger index) {
                        kMeSTRONGSELF
                        MEGroupUserContentModel *contentModel = strongSelf.groupUsers[index];
                        strongSelf.model.group_id = contentModel.uid;
                        strongSelf.model.group_sn = [contentModel.group_sn integerValue];
                        [strongSelf showBuyViewWithTypy:kpurchaseViewBuyType];
//                        MECreateGroupShareVC *shareVC = [[MECreateGroupShareVC alloc] initWithModel:strongSelf->_model];
//                        [strongSelf.navigationController pushViewController:shareVC animated:YES];
                    };
                    cell.checkMoreBlock = ^{
                        kMeSTRONGSELF
                        [strongSelf requestGroupUserList];
                    };
                    return cell;
                }
            }
                break;
            case 2:
            {
                METhridProductDetailsSelectSkuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridProductDetailsSelectSkuCell class]) forIndexPath:indexPath];
                cell.lblSku.text = [NSString stringWithFormat:@"已选:数量x%@,规格:%@",@(_model.buynum),kMeUnNilStr(_model.skus)];
                return cell;
            }
                break;
            default:
                return [UITableViewCell new];
                break;
        }
    }else if (indexPath.section == 1) {
        return self.webCell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return 105;
            }
                break;
            case 1:
            {
                if (self.groupUsers.count > 0) {
                    return [MEGroupUsersCell getHeightWithArray:self.groupUsers];
                }
            }
                break;
            case 2:
            {
                return kMEThridProductDetailsSelectSkuCellHeight;
            }
                break;
            default:
                return 0.1;
                break;
        }
    }else if (indexPath.section == 1) {
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section){
        return kMENewProductDetailsSectionViewHeight;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section){
        MENewProductDetailsSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MENewProductDetailsSectionView class])];
        headview.lbltitle.text = kMeUnArr(_arrTitle)[section];
        return headview;
    }else{
        return [UIView new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row==2){
        [self showBuyViewWithTypy:kpurchaseSelectSkuViewType];
        self.model.group_id = 0;
        self.model.group_sn = 0;
    }
}

#pragma mark -- setter && getter
- (MEGroupDetailHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEGroupDetailHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEGroupDetailHeaderView getHeightWithModel:_model]);
    }
    return _headerView;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEProductDetailsBottomViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGroupCountsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGroupCountsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGroupUsersCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGroupUsersCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridProductDetailsSelectSkuCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridProductDetailsSelectSkuCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewProductDetailsSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MENewProductDetailsSectionView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetalsBuyedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEProductDetalsBuyedCell class])];
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridProductDetailsCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridProductDetailsCommentCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

- (MEProductDetailsBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MEProductDetailsBottomView" owner:nil options:nil] lastObject];
        _bottomView.btnGift.hidden = NO;
        _bottomView.isGroup = YES;
        [_bottomView.btnGift setTitle:@"立即拼团" forState:UIControlStateNormal];
        _bottomView.model = _model;
        kMeWEAKSELF
        _bottomView.buyBlock = ^{
            kMeSTRONGSELF
            strongSelf.isSelf = YES;
            strongSelf.model.group_id = 0;
            strongSelf.model.group_sn = 0;
            [strongSelf showBuyViewWithTypy:kpurchaseViewBuyType];
        };
        _bottomView.addShopcartBlock = ^{
            kMeSTRONGSELF
//            if(strongSelf.model.product_type == 15||strongSelf.model.product_type == 16){
//                [MEShowViewTool showMessage:@"该商品不支持加入购物车" view:kMeCurrentWindow];
//            }else{
//                [strongSelf showBuyViewWithTypy:kpurchaseViewShoppingType];
//            }
        };
        _bottomView.customBlock = ^{
            kMeSTRONGSELF
            if([MEUserInfoModel isLogin]){
//                [strongSelf toCustom];
            }else{
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
//                    [strongSelf toCustom];
                } failHandler:nil];
            }
        };
    }
    return _bottomView;
}

- (void)showBuyViewWithTypy:(kpurchaseViewType)type{
    if([MEUserInfoModel isLogin]){
        _selectType = type;
        [self.purchaseView show];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            strongSelf->_selectType = type;
            [strongSelf.purchaseView show];
        } failHandler:nil];
    }
}

- (UIView *)tableViewBottomView{
    if(!_tableViewBottomView){
        _tableViewBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tableViewBottomView.backgroundColor = kMEHexColor(@"eeeeee");
        UIImageView *img = [[UIImageView alloc]initWithImage:kMeGetAssetImage(@"icon-utkkyung")];
        img.frame = _tableViewBottomView.bounds;
        [_tableViewBottomView addSubview:img];
    }
    return _tableViewBottomView;
}

- (MESkuBuyView *)purchaseView{
    if(!_purchaseView){
        _purchaseView = [[MESkuBuyView alloc]initPurchaseViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) serviceModel:_model WithSuperView:self.view isInteral:NO];
    }
    return _purchaseView;
}

@end

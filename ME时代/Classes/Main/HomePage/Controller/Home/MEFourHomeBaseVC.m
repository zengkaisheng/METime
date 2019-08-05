//
//  MEFourHomeBaseVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeBaseVC.h"

#import "MEAdModel.h"
#import "MEStoreModel.h"
#import "MECoupleModel.h"
#import "METhridHomeModel.h"
#import "MERedeemgetStatusModel.h"
#import "MEHomeRecommendAndSpreebuyModel.h"

#import "MEFourHomeHeaderView.h"
#import "MEFourHomeNoticeHeaderView.h"
#import "MEFourHomeExchangeCell.h"
#import "MECoupleMailCell.h"
#import "MEFourHomeHeaderView.h"
#import "MEFourHomeTopHeaderView.h"
#import "MEFourHomeGoodGoodFilterHeaderView.h"
#import "MEFourHomeGoodGoodMainHeaderView.h"
#import "MESpecialSaleHeaderView.h"

#import "METhridProductDetailsVC.h"
#import "MEHomeAddRedeemcodeVC.h"
#import "MECoupleMailDetalVC.h"
#import "ZLWebViewVC.h"
#import "MEServiceDetailsVC.h"
#import "MECoupleMailVC.h"

#import "MEBargainDetailVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEJoinPrizeVC.h"
#import "MEHomeOptionsModel.h"
#import "MEHomeRecommendModel.h"
#import "MECommonQuestionVC.h"

#define kMEGoodsMargin ((IS_iPhoneX?8:7.5)*kMeFrameScaleX())
#define kMEThridHomeNavViewHeight (((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 129 : 107))

const static CGFloat kImgStore = 50;

@interface MEFourHomeBaseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSArray *_arrHot;
    METhridHomeModel *_homeModel;
    MEStoreModel *_stroeModel;
    MEHomeRecommendAndSpreebuyModel *_spreebugmodel;
    NSArray *_arrDicParm;
    NSArray *_arrPPTM;
    NSString *_net;
    NSArray *_optionsArray;
    NSArray *_noticeArray;
    MEAdModel *_leftBanner;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MEFourHomeHeaderView *headerView;
@property (nonatomic, strong) UIImageView *imgStore;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MEFourHomeBaseVC

- (void)dealloc {
    kNSNotificationCenterDealloc
}

- (instancetype)initWithType:(NSInteger)type  materialArray:(NSArray *)materialArray{
    if (self = [super init]) {
        _type = type;
        _arrDicParm = [materialArray copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
//    _arrDicParm = @[@{@"material_id":@"9660"},@{@"material_id":@"3756"},@{@"material_id":@"3786"},@{@"material_id":@"3767"},@{@"material_id":@"3763"},@{@"material_id":@"3760"}];
    //@[@{@"type":@"3"},@{@"material_id":@"3756"},@{@"material_id":@"3786"},@{@"material_id":@"3767"},@{@"material_id":@"3763"},@{@"material_id":@"3760"}];
    
    self.navBarHidden = YES;
    [self.view addSubview:self.collectionView];
    _arrHot = [NSArray array];
    _arrPPTM = [NSArray array];
    _optionsArray = [NSArray array];
    _noticeArray = [NSArray array];
    _homeModel = [METhridHomeModel new];
    _leftBanner = [MEAdModel new];
    _net = @"";
    
    [self.refresh addRefreshView];
    self.collectionView.mj_header.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.collectionView.mj_header;
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    self.headerView.ViewForBack.backgroundColor = [UIColor colorWithHexString:@"#E52E26"];
    
    if (_type == 0) {
        [self.view addSubview:self.imgStore];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetWork:) name:kMEGetNetStatus object:nil];
}

- (void)getNetWork:(NSNotification *)notifi {
    NSDictionary *dic = (NSDictionary *)notifi.object;
    _net = dic[@"net"];
}

- (void)setSdBackgroundColorWithIndex:(NSInteger)index{
    NSArray *arr = kMeUnArr(_homeModel.top_banner);
    if(arr.count==0 || index>arr.count){
        return;
    }
    METhridHomeAdModel *model = arr[index];
    if(kMeUnNilStr(model.color_start).length){
        UIColor *color = [UIColor colorWithHexString:kMeUnNilStr(model.color_start)];
        if(!color){
            color = [UIColor colorWithHexString:@"#E52E26"];
        }
        self.collectionView.mj_header.backgroundColor = color;
        if (self.changeColorBlock) {
            self.changeColorBlock(color);
        }
        self.view.backgroundColor = color;
        self.headerView.ViewForBack.backgroundColor = color;
    }
}

//根据返回图片类型选择展示方式
- (void)setStoreImage {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        kMeSTRONGSELF
        //获取字节，用于判断动图
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:kMeUnNilStr(strongSelf->_homeModel.right_bottom_img.ad_img)]];
        uint8_t c;
        [data getBytes:&c length:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.imgStore.frame = CGRectMake(SCREEN_WIDTH-k15Margin-kImgStore, SCREEN_HEIGHT-kMeTabBarHeight-k15Margin-kImgStore-kMEThridHomeNavViewHeight-25, kImgStore, kImgStore+15);
            if (c == 0x47) {//gif
                strongSelf.imgStore.image = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kMeUnNilStr(strongSelf->_homeModel.right_bottom_img.ad_img)]]];
            }else {
                kSDLoadImg(strongSelf.imgStore, kMeUnNilStr(strongSelf->_homeModel.right_bottom_img.ad_img));
            }
        });
    });
}

- (void)setHeaderViewUIWithModel:(METhridHomeModel *)model stroeModel:(MEStoreModel *)storemodel optionsArray:(NSArray *)options{
    [self.headerView setUIWithModel:model stroeModel:storemodel optionsArray:options];
}

- (void)reloadData {
    [self.refresh reload];
}

- (void)getNetWork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGetappHomePageDataWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                strongSelf->_stroeModel = [MEStoreModel mj_objectWithKeyValues:responseObject.data];
            }else{
                strongSelf->_stroeModel = nil;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_stroeModel = nil;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postThridHomeStyleWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_homeModel = [METhridHomeModel mj_objectWithKeyValues:responseObject.data];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_homeModel = nil;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postFetchHomeBulletinWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = (NSDictionary *)responseObject.data;
                if ([data[@"left_banner"] isKindOfClass:[NSDictionary class]]) {
                    strongSelf->_leftBanner = [MEAdModel mj_objectWithKeyValues:data[@"left_banner"]];
                }else {
                    strongSelf->_leftBanner = [MEAdModel new];
                }
                if ([data[@"bulletin"] isKindOfClass:[NSArray class]]) {
                    NSArray *bulletin = (NSArray *)data[@"bulletin"];
                    strongSelf->_noticeArray = [MEAdModel mj_objectArrayWithKeyValuesArray:bulletin];
                }else {
                    strongSelf->_noticeArray = [NSArray array];
                }
            }else {
                strongSelf->_noticeArray = [NSArray array];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_noticeArray = [NSArray array];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postFourGetHomeRecommendGoodsAndActivityWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = (NSDictionary *)responseObject.data;
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                [tempDic setObject:@[] forKey:@"activity"];
                if ([data.allKeys containsObject:@"activity"]) {
                    if ([data[@"activity"] isKindOfClass:[NSArray class]]) {
                        [tempDic setObject:[MEHomeRecommendModel mj_objectArrayWithKeyValuesArray:data[@"activity"]] forKey:@"activity"];
                    }
                }
                [tempArr addObject:[tempDic copy]];
                [tempDic removeAllObjects];
                [tempDic setObject:@[] forKey:@"goods"];
                if ([data.allKeys containsObject:@"goods"]) {
                    if ([data[@"goods"] isKindOfClass:[NSArray class]]) {
                        [tempDic setObject:[MEHomeRecommendModel mj_objectArrayWithKeyValuesArray:data[@"goods"]] forKey:@"goods"];
                    }
                }
                [tempArr addObject:[tempDic copy]];
                [tempDic removeAllObjects];
                strongSelf->_arrHot = [tempArr copy];
            }else{
                strongSelf->_arrHot = [NSArray array];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_arrHot = [NSArray array];
            dispatch_semaphore_signal(semaphore);
        }];
//        [MEPublicNetWorkTool postThridHomehomegetRecommendWithSuccessBlock:^(ZLRequestResponse *responseObject) {
//            kMeSTRONGSELF
//            if ([responseObject.data isKindOfClass:[NSArray class]]) {
//                strongSelf->_arrHot = [MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
//            }else{
//                strongSelf->_arrHot = [NSArray array];
//            }
//            dispatch_semaphore_signal(semaphore);
//        } failure:^(id object) {
//            kMeSTRONGSELF
//            strongSelf->_arrHot = [NSArray array];
//            dispatch_semaphore_signal(semaphore);
//        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postThridHomeRecommendAndSpreebuyWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf->_spreebugmodel = [MEHomeRecommendAndSpreebuyModel mj_objectWithKeyValues:responseObject.data];
            }else{
                strongSelf->_spreebugmodel = nil;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_spreebugmodel = nil;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postFourHomeOptionsWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSArray class]]) {
                strongSelf->_optionsArray = [MEHomeOptionsModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            }else{
                strongSelf->_optionsArray = [NSArray array];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_optionsArray = [NSArray array];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postFetchSpecialSalesBannerWithsuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            id data = responseObject.data;
            if ([data isKindOfClass:[NSArray class]]) {
                strongSelf->_arrPPTM = [MEAdModel mj_objectArrayWithKeyValuesArray:data];
            }else {
                strongSelf->_arrPPTM = [NSArray array];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            //            [strongSelf->_headerView setUIWithModel:strongSelf->_homeModel stroeModel:strongSelf->_stroeModel];
            //            if(strongSelf->_headerView.sdView){
            //                [strongSelf->_headerView.sdView makeScrollViewScrollToIndex:0];
            //            }
            [strongSelf setSdBackgroundColorWithIndex:0];
            //            if(strongSelf->_stroeModel){
            //                 kSDLoadImg(strongSelf->_imgStore, kMeUnNilStr(strongSelf->_stroeModel.mask_img));
            //            }else{
            //                strongSelf->_imgStore.image = [UIImage imageNamed:@"icon-wgvilogo"];
            //            }
            
            if (kMeUnNilStr(strongSelf->_homeModel.right_bottom_img.ad_img).length > 0) {
                strongSelf.imgStore.hidden = NO;
                [strongSelf setStoreImage];
            }else {
                strongSelf.imgStore.hidden = YES;
            }
            
            [strongSelf.collectionView reloadData];
        });
    });
}

- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        if (_type == 0) {
            [self getNetWork];
        }
    }
//    if (_type == 2) {
//        return @{@"os":@"ios",
//                 @"ip":[NSString stringWithFormat:@"%s",[[MECommonTool getIpAddresses] UTF8String]],
//                 @"ua":@"Safari/525.13",
//                 @"net":@"wifi"
//                 };
//    }
    NSDictionary *dic = _arrDicParm[_type];
//    NSLog(@"---------%@",dic);
    return dic;
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MECoupleModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark -- Action
- (void)toReDeemVC{
    kMeWEAKSELF
    [MEPublicNetWorkTool postcommonredeemgetStatusWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MERedeemgetStatusModel *model = [MERedeemgetStatusModel mj_objectWithKeyValues:responseObject.data];
        if(model.status == 1){
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.goods_id];
            [strongSelf.navigationController pushViewController:details animated:YES];
        }else{
            MEHomeAddRedeemcodeVC *vc = [[MEHomeAddRedeemcodeVC alloc]init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(id object) {
        
    }];
}

- (void)toStore{
    //    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    kMeWEAKSELF
    if([MEUserInfoModel isLogin]){
        [weakSelf checkRelationIdWithUrl:nil];
    }else {
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf toStore];
        } failHandler:nil];
    }
}

//banner图点击跳转
- (void)cycleScrollViewDidSelectItemWithModel:(MEAdModel *)model {
    
    if (model.is_need_login == 1) {
        if(![MEUserInfoModel isLogin]){
            kMeWEAKSELF
            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                kMeSTRONGSELF
                [strongSelf cycleScrollViewDidSelectItemWithModel:model];
            } failHandler:^(id object) {
                return;
            }];
            return;
        }
    }
    
    NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork)};
    [self saveClickRecordsWithType:@"1" params:params];
    
    switch (model.show_type) {//0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
        case 1:
        {
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 2:
        {
            MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 3:
        {
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = kMeUnNilStr(model.ad_name);
            [webVC loadURL:[NSURL URLWithString:kMeUnNilStr(model.ad_url)]];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 4:
        {
            NSURL *URL = [NSURL URLWithString:kMeUnNilStr(model.ad_url)];
            [[UIApplication sharedApplication] openURL:URL];
        }
            break;
        case 5:
        {
            MEBaseVC *vc = [[MEBaseVC alloc] init];
            vc.title = @"详情";
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
            [webView loadHTMLString:model.content baseURL:nil];
            [vc.view addSubview:webView];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            
        }
            break;
        case 8:
        {
            [self toTaoBaoActivityWithUrl:kMeUnNilStr(model.ad_url)];
        }
            break;
        case 12://秒杀商品
        {
            METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 13:
        {//跳拼多多推荐商品列表
            MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:@""];
            vc.recordType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {//跳砍价活动详情
            if([MEUserInfoModel isLogin]){
                MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                [self.navigationController pushViewController:bargainVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
                    [strongSelf.navigationController pushViewController:bargainVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 15:
        {//跳拼团活动详情
            if([MEUserInfoModel isLogin]){
                MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                [self.navigationController pushViewController:groupVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
                    [strongSelf.navigationController pushViewController:groupVC animated:YES];
                } failHandler:^(id object) {
                    
                }];
            }
        }
            break;
        case 16:
        {//跳签到活动详情
            if([MEUserInfoModel isLogin]){
                MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.activity_id]];
                [self.navigationController pushViewController:prizeVC animated:YES];
            }else {
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.activity_id]];
                    [strongSelf.navigationController pushViewController:prizeVC animated:YES];
                } failHandler:^(id object) {

                }];
            }
        }
            break;
        case 17:
        {//跳常见问题
            MECommonQuestionVC *questionVC = [[MECommonQuestionVC alloc] init];
            [self.navigationController pushViewController:questionVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//618活动
- (void)toTaoBaoActivityWithUrl:(NSString *)url{
    kMeWEAKSELF
    if([MEUserInfoModel isLogin]){
        [weakSelf checkRelationIdWithUrl:url];
    }else {
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf toTaoBaoActivityWithUrl:url];
        } failHandler:nil];
    }
}

- (void)checkRelationIdWithUrl:(NSString *)url {
    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
        [self obtainTaoBaoAuthorizeWithUrl:url];
    }else{
        NSString *str;
        if (url.length > 0) {
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            str = [url stringByAppendingString:rid];
        }else {
            if (kMeUnNilStr(_homeModel.right_bottom_img.ad_url).length > 0) {
                NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
                str = [kMeUnNilStr(_homeModel.right_bottom_img.ad_url) stringByAppendingString:rid];
            }
        }
        
        ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
        webVC.showProgress = YES;
        webVC.title = @"活动主会场";
        [webVC loadURL:[NSURL URLWithString:str]];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

//获取淘宝授权
- (void)obtainTaoBaoAuthorizeWithUrl:(NSString *)url {
    NSString *str = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25425439&redirect_uri=http://test.meshidai.com/src/taobaoauthorization.html&view=wap";
    ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
    webVC.showProgress = YES;
    webVC.title = @"获取淘宝授权";
    [webVC loadURL:[NSURL URLWithString:str]];
    kMeWEAKSELF
    webVC.authorizeBlock = ^{
        [weakSelf checkRelationIdWithUrl:url];
    };
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark- CollectionView Delegate And DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_type == 0) {
        return 7;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_type == 0) {
        if (section == 0 || section == 2 || section == 3 || section == 4 || section == 5) {
            return 0;
        }else if (section == 1) {
            return 1;
        }
    }
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 0) {
        if (indexPath.section == 1) {
            MEFourHomeExchangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEFourHomeExchangeCell class]) forIndexPath:indexPath];
            if(_homeModel && kMeUnNilStr(_homeModel.member_of_the_ritual_image).length){
                kSDLoadImg(cell.imgPic, kMeUnNilStr(_homeModel.member_of_the_ritual_image));
            }
            return cell;
        }
    }
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    MECoupleModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
//    webVC.showProgress = YES;
//    [webVC loadURL:[NSURL URLWithString:@"http://test.meshidai.com/jump/index.html?activity_id=34"]];
//    [self.navigationController pushViewController:webVC animated:YES];
    if (_type == 0) {
        if (indexPath.section == 1) {
            if(_homeModel && kMeUnNilStr(_homeModel.member_of_the_ritual_image).length){
                if([MEUserInfoModel isLogin]){
                    [self toReDeemVC];
                }else{
                    [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    } failHandler:nil];
                }
            }
        }
        if (indexPath.section == 6) {
            MECoupleModel *model = self.refresh.arrData[indexPath.row];

            NSDictionary *params = @{@"num_iid":kMeUnNilStr(model.num_iid),@"item_title":kMeUnNilStr(model.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
            [self saveClickRecordsWithType:@"3" params:params];

            if(kMeUnNilStr(model.coupon_id).length){
                MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc] initWithProductrId:kMeUnNilStr(model.num_iid) couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
                dvc.recordType = 1;
                [self.navigationController pushViewController:dvc animated:YES];
            }else{
                model.coupon_click_url = [NSString stringWithFormat:@"https:%@",kMeUnNilStr(model.coupon_share_url)];//;
                MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:model];
                vc.recordType = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else {
        MECoupleModel *model = self.refresh.arrData[indexPath.row];

        NSDictionary *params = @{@"num_iid":kMeUnNilStr(model.num_iid),@"item_title":kMeUnNilStr(model.title),@"uid":kMeUnNilStr(kCurrentUser.uid)};
        [self saveClickRecordsWithType:@"3" params:params];

        if(kMeUnNilStr(model.coupon_id).length){
            MECoupleMailDetalVC *dvc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
            dvc.recordType = 1;
            [self.navigationController pushViewController:dvc animated:YES];
        }else{
            model.coupon_click_url = [NSString stringWithFormat:@"https:%@",kMeUnNilStr(model.coupon_share_url)];//;
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithModel:model];
            vc.recordType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 0) {
        if (indexPath.section == 1) {
            if(_homeModel && kMeUnNilStr(_homeModel.member_of_the_ritual_image).length){
                return CGSizeMake(SCREEN_WIDTH, kMEFourHomeExchangeCellheight);
            }else{
                return CGSizeMake(SCREEN_WIDTH, 0.1);
            }
        }
    }
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (_type == 0) {
        if (section == 0) {
            return CGSizeMake(SCREEN_WIDTH, [MEFourHomeHeaderView getViewHeightWithOptionsArray:_optionsArray]);
        }else if (section == 1) {
            if (_noticeArray.count > 0) {
                return CGSizeMake(SCREEN_WIDTH, 70);
            }else {
                return CGSizeMake(0, 0);
            }
        }else if (section == 2) {
            if (_arrPPTM.count > 0) {
                return CGSizeMake(SCREEN_WIDTH, 100*kMeFrameScaleY());
            }else {
                return CGSizeMake(0, 0);
            }
        }else if (section == 3) {
            if(_spreebugmodel.recommend_left && _spreebugmodel.recommend_right){
                return CGSizeMake(SCREEN_WIDTH, kMEFourHomeTopHeaderViewHeight);
            }else{
                return CGSizeMake(0, 0.1);;
            }
        }else if (section == 4) {
//            return CGSizeMake(SCREEN_WIDTH, [MEFourHomeGoodGoodFilterHeaderView getCellHeight]);
            return CGSizeZero;
        }else if (section == 5) {
            CGFloat height = 51;
            if (_arrHot.count > 0) {
                for (int i = 0; i < _arrHot.count; i++) {
                    NSDictionary *data = _arrHot[i];
                    if ([data.allKeys containsObject:@"activity"]) {
                        if ([data[@"activity"] isKindOfClass:[NSArray class]]) {
                            NSArray *activity = data[@"activity"];
                            if (activity.count > 0) {
                                height += 35;
                                height += activity.count*115;
                            }
                        }
                    }
                    if ([data.allKeys containsObject:@"goods"]) {
                        if ([data[@"goods"] isKindOfClass:[NSArray class]]) {
                            NSArray *goods = data[@"goods"];
                            if (goods.count > 0) {
                                height += 42;
                                height += goods.count * 135;
                            }
                        }
                    }
                }
            }
            return CGSizeMake(SCREEN_WIDTH, height);
        }
    }
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (_type == 0) {
            if (indexPath.section == 0) {
                MEFourHomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeHeaderView class]) forIndexPath:indexPath];
                [header setUIWithModel:_homeModel stroeModel:_stroeModel optionsArray:_optionsArray];
                if(header.sdView){
                    [header.sdView makeScrollViewScrollToIndex:0];
                }
                self.headerView = header;
                kMeWEAKSELF
                header.scrollToIndexBlock = ^(NSInteger index) {
                    kMeSTRONGSELF
                    [strongSelf setSdBackgroundColorWithIndex:index];
                };
                header.reloadBlock = ^{
                    [weakSelf.refresh reload];
                };
                
                headerView = header;
            }else if (indexPath.section == 1) {
                MEFourHomeNoticeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeNoticeHeaderView class]) forIndexPath:indexPath];
                [header setUIWithArray:_noticeArray leftBanner:_leftBanner];
                kMeWEAKSELF
                header.selectedIndexBlock = ^(NSInteger index) {
                    kMeSTRONGSELF
                    MEAdModel *model = strongSelf->_noticeArray[index];
                    [strongSelf cycleScrollViewDidSelectItemWithModel:model];
                };
                headerView = header;
            }else if (indexPath.section == 2) {
                MESpecialSaleHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MESpecialSaleHeaderView class]) forIndexPath:indexPath];
                [header setUIWithBannerImage:_arrPPTM];
                kMeWEAKSELF
                header.selectedIndexBlock = ^(NSInteger index) {
                    kMeSTRONGSELF
                    MEAdModel *model = strongSelf->_arrPPTM[index];
                    [strongSelf cycleScrollViewDidSelectItemWithModel:model];
                };
                headerView = header;
            }else if (indexPath.section == 3) {
                MEFourHomeTopHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeTopHeaderView class]) forIndexPath:indexPath];
                if(_spreebugmodel.recommend_left && _spreebugmodel.recommend_right){
                    [header setUiWithModel:_spreebugmodel];
                    kMeWEAKSELF
                    header.leftBlock = ^{
                        kMeSTRONGSELF
                        MEAdModel *model = strongSelf->_spreebugmodel.recommend_left;
                        [strongSelf cycleScrollViewDidSelectItemWithModel:model];
                    };
                    header.rightBlock = ^{
                        kMeSTRONGSELF
                        MEAdModel *model = strongSelf->_spreebugmodel.recommend_right;
                        [strongSelf cycleScrollViewDidSelectItemWithModel:model];
                    };
                }
                headerView = header;
            }else if (indexPath.section == 4) {
                MEFourHomeGoodGoodFilterHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeGoodGoodFilterHeaderView class]) forIndexPath:indexPath];
                headerView = header;
            }else if (indexPath.section == 5) {
                MEFourHomeGoodGoodMainHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeGoodGoodMainHeaderView class]) forIndexPath:indexPath];
                [header setupUIWithArray:_arrHot];
                headerView = header;
            }
        }
    }
    return headerView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (_type == 0) {
        if (section != 6) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin+2, kMEGoodsMargin, kMEGoodsMargin+2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEGoodsMargin;
}
#pragma setter && getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEThridHomeNavViewHeight) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeExchangeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEFourHomeExchangeCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeNoticeHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeNoticeHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeTopHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeTopHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeGoodGoodFilterHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeGoodGoodFilterHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeGoodGoodMainHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeGoodGoodMainHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MESpecialSaleHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MESpecialSaleHeaderView class])];
        
        _collectionView.backgroundColor = kMEf5f4f4;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        NSString *str = MEIPcommonTaobaokeGetDgMaterialOptional;
//        if(_type == 2){
//            str = MEIPcommonTaobaokeGetGuessLike;
//        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(str)];
        _refresh.delegate = self;
        _refresh.isCoupleMater = YES;
        _refresh.isPinduoduoCoupleMater = NO;
        _refresh.isDataInside = YES;
        _refresh.showFailView = NO;
        //        _refresh.showMaskView = YES;
    }
    return _refresh;
}

- (UIImageView *)imgStore{
    if(!_imgStore){
        _imgStore = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-k15Margin-kImgStore, SCREEN_HEIGHT-kMeTabBarHeight-k15Margin-kImgStore-kMEThridHomeNavViewHeight, kImgStore, kImgStore)];
        //        _imgStore.cornerRadius = kImgStore/2;
        _imgStore.clipsToBounds = YES;
        _imgStore.hidden = YES;
        _imgStore.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toStore)];
        [_imgStore addGestureRecognizer:ges];
    }
    return _imgStore;
}

@end

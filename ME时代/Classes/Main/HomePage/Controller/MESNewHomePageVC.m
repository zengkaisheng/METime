//
//  MESNewHomePageVC.m
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESNewHomePageVC.h"
#import "MESNewHomePageView.h"
#import "MENoticeTypeVC.h"
#import "MERCConversationListVC.h"
#import "MEVisiterHomeVC.h"
#import "MEFilterVC.h"
#import "MEProductListVC.h"
#import "MEPosterListVC.h"
#import "MEArticelVC.h"
#import "MEProductDetailsVC.h"
#import "MEAdModel.h"
#import "MERushBuyView.h"
//#import "MENewHomePage.h"
#import "MEShoppingMallVC.h"
#import "MESNewHomeActiveVC.h"
#import "MESActivityModel.h"
#import "ZLWebVC.h"
#import "MEProductDetailsVC.h"
#import "MECountArticleModel.h"
#import "MESNewHomeStyle.h"
#import "MEAdvModel.h"
#import "MEArticleDetailVC.h"
#import "MEArticelModel.h"
#import "MECoupleMailVC.h"
#import "MEGiftVC.h"
#pragma mark - 2.0.5
#import "MECoupleHomeVC.h"
//#import "MECoupleFilterVC.h"

@interface MESNewHomePageVC ()<UIScrollViewDelegate,MESNewHomePageViewDelegate>{
    CGFloat _allHeight;
    NSString *_noticeStr;//通知数
}
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) MESNewHomePageView *sContenView;;
@property (nonatomic, strong) MESActivityModel *activeModel;//banner 和 背景
@property (nonatomic, strong) MECountArticleModel *countArticelModel;//统计
@property (nonatomic, strong) MESNewHomeStyle *styleModel;//5个小背景图
@property (nonatomic, strong) NSArray *arrAdv;
@end

@implementation MESNewHomePageVC

- (void)dealloc{
    kNSNotificationCenterDealloc
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeStr = @"0";
    self.navBarHidden = YES;
    _allHeight = [MESNewHomePageView getViewHeight];
    [self.scrollview addSubview:self.sContenView];
    [self.view addSubview:self.scrollview];
    self.scrollview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNetwork)];
    [self.scrollview.mj_header beginRefreshing];
    [self getRushGood];
    [[NSNotificationCenter defaultCenter] addObserver:self.scrollview.mj_header selector:@selector(beginRefreshing) name:kUnNoticeMessage object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogout) name:kUserLogout object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogin) name:kUserLogin object:nil];
}


- (void)userLogout{
    self.sContenView.lblNotice.text = @"0";
    self.sContenView.lblPoster.text = @"";
    self.sContenView.lblVistor.text = @"0";
    self.sContenView.lblArticle.text = @"";
    _countArticelModel = nil;
    _noticeStr = @"0";
}

- (void)requestNetwork{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [MBProgressHUD showMessage:@"" toView:self.view];
    

    kMeWEAKSELF
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postGetMessageWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSArray class]]){
                strongSelf.arrAdv = [MEAdvModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postActivityWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf.activeModel = [MESActivityModel mj_objectWithKeyValues:responseObject.data];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postCountArticleWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf.countArticelModel = [MECountArticleModel mj_objectWithKeyValues:responseObject.data];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool getUserHomeUnreadNoticeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                NSNumber *notice = responseObject.data[@"notice"];
                NSNumber *order = responseObject.data[@"order"];
                NSNumber *versions = responseObject.data[@"versions"];
                NSInteger unread = [notice integerValue] + [order integerValue] +[versions integerValue];
                strongSelf->_noticeStr =  @(unread).description;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postMystyleWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                strongSelf.styleModel = [MESNewHomeStyle mj_objectWithKeyValues:responseObject.data];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
//            [strongSelf getUnInfo];
            [strongSelf setUI];
            [MBProgressHUD hideHUDForView:strongSelf.view];
            [strongSelf.scrollview.mj_header endRefreshing];
        });
    });
}

- (void)setUI{
    if(_sContenView){
        [_sContenView setSdViewWithArr:self.activeModel.banner];
        [_sContenView setAdWithArr:self.arrAdv];
        _sContenView.lblNotice.text = _noticeStr;
        _sContenView.lblArticle.text = [NSString stringWithFormat:@"分享:%@ 阅读:%@",kMeUnNilStr(self.countArticelModel.share),kMeUnNilStr(self.countArticelModel.read)];
        _sContenView.lblPoster.text = [NSString stringWithFormat:@"分享:%@",kMeUnNilStr(self.countArticelModel.share_posters)];
        _sContenView.lblVistor.text = kMeUnNilStr(self.countArticelModel.share_article);
        [_sContenView.imgBackground sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.activeModel.background.img)] placeholderImage: [UIImage imageNamed:@"homeb"]];
        [_sContenView.imgTop sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.top_style.img)] placeholderImage: [UIImage imageNamed:@"talt"]];
//        [_sContenView.imgAdv sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.top_style.img)] placeholderImage: [UIImage imageNamed:@"talt"]];
        [_sContenView.imgShop sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.shop_style.img)] placeholderImage:[UIImage imageNamed:@"umkkumfd"]];
        [_sContenView.imgStore sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.store_style.img)] placeholderImage:[UIImage imageNamed:@"uyyhebtl"]];
        [_sContenView.imgPoster sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.posters_style.img)] placeholderImage:[UIImage imageNamed:@"tgdmitrb"]];
        [_sContenView.imgArticle sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.article_style.img)] placeholderImage:[UIImage imageNamed:@"MEyyuj"]];
        [_sContenView.imgCouple sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.taobao_coupon_style.img)] placeholderImage:[UIImage imageNamed:@"couplehome"]];
        [_sContenView.imgGift sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(self.styleModel.gift_style.img)] placeholderImage:[UIImage imageNamed:@"gifthome"]];
    }
}

- (void)userLogin{
    [self.scrollview.mj_header beginRefreshing];
}

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
//                    if(strongSelf->_sContenView){
//                        strongSelf->_sContenView.lblNotice.text = @(unread).description;
//                    }
////                    [strongSelf.scrollview.mj_header endRefreshing];
//                });
//            }
//        } failure:^(id object) {
////            kMeSTRONGSELF
////            [strongSelf.scrollview.mj_header endRefreshing];
//        }];
//    }else{
////        [self.scrollview.mj_header endRefreshing];
//    }
//}

- (void)getRushGood{
    kMeWEAKSELF
    [MEPublicNetWorkTool postRushGoodWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        if([responseObject.data isKindOfClass:[NSDictionary class]]){
            MEAdModel *model = [MEAdModel mj_objectWithKeyValues:responseObject.data];
            [MERushBuyView ShowWithModel:model tapBlock:^{
                kMeSTRONGSELF
                strongSelf.tabBarController.selectedIndex = 0;
                MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
                [strongSelf.navigationController pushViewController:dvc animated:YES];
            } cancelBlock:^{
                
            } superView:weakSelf.view];
        }
    } failure:^(id object) {
        
    }];
}

#pragma mark -MESNewHomePageViewDelegate

- (void)toNoticeVC{
    if([MEUserInfoModel isLogin]){
        [self toNotice];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf toNotice];
        } failHandler:nil];
    }
}

- (void)toNotice{
    if([kCurrentUser.mobile isEqualToString:AppstorePhone]){
        MERCConversationListVC *svc = [[MERCConversationListVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        MENoticeTypeVC *svc = [[MENoticeTypeVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (void)toVisterVC{
    if([MEUserInfoModel isLogin]){
        MEVisiterHomeVC *svc = [[MEVisiterHomeVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            MEVisiterHomeVC *svc = [[MEVisiterHomeVC alloc]init];
            [strongSelf.navigationController pushViewController:svc animated:YES];
        } failHandler:nil];
    }
}

- (void)toProdectVC{
    MEShoppingMallVC *svc = [[MEShoppingMallVC alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)toServiceVC{
    MEProductListVC *productList = [[MEProductListVC alloc]initWithType:MEGoodsTypeNetServiceStyle];
    [self.navigationController pushViewController:productList animated:YES];
}

- (void)toCoupleVC{
    MECoupleHomeVC *coupleVC = [[MECoupleHomeVC alloc]init];
    [self.navigationController pushViewController:coupleVC animated:YES];
}

- (void)toGiftVC{
    MEGiftVC *coupleVC = [[MEGiftVC alloc]init];
    [self.navigationController pushViewController:coupleVC animated:YES];
}

- (void)toPosterVC{
    if([MEUserInfoModel isLogin]){
        MEPosterListVC *svc = [[MEPosterListVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            MEPosterListVC *svc = [[MEPosterListVC alloc]init];
            [strongSelf.navigationController pushViewController:svc animated:YES];
        } failHandler:nil];
    }
}

- (void)toArticelVC{
    if([MEUserInfoModel isLogin]){
        MEArticelVC *svc = [[MEArticelVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            MEArticelVC *svc = [[MEArticelVC alloc]init];
            [strongSelf.navigationController pushViewController:svc animated:YES];
        } failHandler:nil];
    }
}

- (void)didSdSelectItemAtIndex:(NSInteger)index{
    if(index> _activeModel.banner.count){
        return;
    }
    MESActivityContentModel *bModel = _activeModel.banner[index];
    [self tobanerVCWithModel:bModel];
}

- (void)didAdvdSelectItemAtIndex:(NSInteger)index{
    if(index> self.arrAdv.count){
        return;
    }
    //1链接到产品2链接到文章3链接到版本更新4显示内容
    MEAdvModel *model = self.arrAdv[index];
    switch (model.message_type) {
        case 1:{
            MEProductDetailsVC *vc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            MEArticelModel *modela = [MEArticelModel new];
            modela.article_id = model.article_id;
            MEArticleDetailVC *vc = [[MEArticleDetailVC alloc]initWithModel:modela];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",kMEAppId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
            break;
        case 4:{
            ZLWebVC *vc = [[ZLWebVC alloc]init];
            vc.title = kMeUnNilStr(model.title);
            [vc loadWebHTMLSring:kMeUnNilStr(model.content)];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)tapBackGround{
    if(_activeModel){
        [self tobanerVCWithModel:_activeModel.background];
    }
}

- (void)tobanerVCWithModel:(MESActivityContentModel *)model{
    if(model){
        switch (model.show_type) {
            case MESActivityContentModelProductType:{
                MEProductDetailsVC *vc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case MESActivityContentModelHtmlType:{
                MESNewHomeActiveVC *vc = [[MESNewHomeActiveVC alloc]initWithContent:model.content];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case MESActivityContentModelUrlType:{
                ZLWebVC *vc = [[ZLWebVC alloc]initWithUrl:kMeUnNilStr(model.url)];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (UIScrollView *)scrollview{
    if(!_scrollview){
        _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight)];
        _scrollview.backgroundColor = [UIColor colorWithHexString:@"F1F2F6"];
        _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, _allHeight);
        _scrollview.bounces = YES;
        _scrollview.showsVerticalScrollIndicator =NO;
        _scrollview.delegate = self;
    }
    return _scrollview;
}

- (MESNewHomePageView *)sContenView{
    if(!_sContenView){
        _sContenView = [[[NSBundle mainBundle]loadNibNamed:@"MESNewHomePageView" owner:nil options:nil] lastObject];
        _sContenView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _allHeight);
        _sContenView.deleate = self;
    }
    return _sContenView;
}

- (MESActivityModel *)activeModel{
    if(!_activeModel){
        _activeModel = [MESActivityModel new];
    }
    return _activeModel;
}

- (MECountArticleModel *)countArticelModel{
    if(!_countArticelModel){
        _countArticelModel = [MECountArticleModel new];
        _countArticelModel.share = @"0";
        _countArticelModel.read = @"0";
        _countArticelModel.share_article = @"0";
        _countArticelModel.share_posters = @"0";
    }
    return _countArticelModel;
}

- (MESNewHomeStyle *)styleModel{
    if(!_styleModel){
        _styleModel = [MESNewHomeStyle new];
    }
    return _styleModel;
}

- (NSArray *)arrAdv{
    if(!_arrAdv){
        _arrAdv = [NSArray array];
    }
    return _arrAdv;
}

@end

//
//  MEMineExchangeDetailVC.m
//  ME时代
//
//  Created by hank on 2018/9/12.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineExchangeDetailVC.h"
#import "TDWebViewCell.h"
#import "MEProductDetailsHeaderView.h"
#import "MEProductDetailsSectionView.h"
#import "MEProductDetalsBuyedCell.h"
#import "MEMineExchangeRudeCell.h"
#import "MEMineExchangeRudeSectionView.h"
#import "MESkuBuyView.h"
#import "MEMakeOrderVC.h"
#import "MEGoodModel.h"
#import "MEGoodDetailModel.h"
#import "MEExchangDetailsBottomView.h"
#import "MERCConversationVC.h"

@interface MEMineExchangeDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrTitle;
    BOOL _isExpand;
    NSString *_str;
    NSInteger _detailsId;
    MEGoodDetailModel *_model;
    NSString *_customId;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) MEProductDetailsHeaderView *headerView;;
@property (nonatomic, strong) MEExchangDetailsBottomView *bottomView;;
@property (strong, nonatomic) TDWebViewCell                  *webCell;
@property (nonatomic, strong) UIView *tableViewBottomView;
@property (nonatomic, strong) MESkuBuyView *purchaseView;
@property (nonatomic, strong) NSArray *arrCommendModel;
@end

@implementation MEMineExchangeDetailVC

- (void)dealloc{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if(_purchaseView){
        [_purchaseView removeFromSuperview];
        [_purchaseView.layer removeAllAnimations];
    }
    kTDWebViewCellDidFinishLoadNotificationCancel
}

- (instancetype)initWithId:(NSInteger)detailsId{
    if(self = [super init]){
        _detailsId = detailsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换详情";
    _str=@"1、注册、分享、邀请好友，产生都获得不同的美豆\n2、使用美豆可以在兑换区兑换产品\n3、不同产品的美豆兑换比不一样\n4、兑换流程为：进入我的美豆，点击兑换商品，开始兑换";
    _arrTitle = @[@"详情",@"买了这件商品的人也买了",@"兑换规则"];
    _isExpand = NO;
    [self initWithSomeThing];
    kTDWebViewCellDidFinishLoadNotification
    // Do any additional setup after loading the view.
}

- (void)initWithSomeThing{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGoodsDetailWithGoodsId:_detailsId successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        MEGoodDetailModel *model = [MEGoodDetailModel mj_objectWithKeyValues:responseObject.data];
        model.buynum = 1;
        [strongSelf setUIWIthModel:model];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setUIWIthModel:(MEGoodDetailModel *)model{
    _model = model;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kMEExchangDetailsBottomViewHeight));
        make.width.equalTo(@(self.view.width));
        make.top.equalTo(@(self.view.bottom-kMEExchangDetailsBottomViewHeight));
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.tableViewBottomView;
    [self.headerView setIntergalUIWithModel:_model];

    kMeWEAKSELF
    self.purchaseView.confirmBlock = ^{
        kMeSTRONGSELF
        MEMakeOrderVC *vc = [[MEMakeOrderVC alloc]initWithIsinteral:YES goodModel:strongSelf->_model];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    self.purchaseView.failGetStoreBlock = ^{
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
    [self.webCell.webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(_model.content)] baseURL:nil];
    
    [MBProgressHUD showMessage:@"获取详情中" toView:self.view];

    [MEPublicNetWorkTool postGoodsListWithType:MEGoodsTypeNetCommendStyle successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSArray *arr = [MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        strongSelf.arrCommendModel = arr;
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id object) {

    }];
}


kTDWebViewCellDidFinishLoadNotificationMethod
- (void)toExchange:(UIButton *)btn{
    [self.purchaseView show];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 2?(_isExpand?1:0):1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return self.webCell;
    }else if(indexPath.section == 1){
        MEProductDetalsBuyedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEProductDetalsBuyedCell class]) forIndexPath:indexPath];
        [cell setUIWithArr:kMeUnArr(self.arrCommendModel)];
        return cell;
    } else if(indexPath.section == 2){
        MEMineExchangeRudeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEMineExchangeRudeCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:_str];
        return cell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }else if(indexPath.section == 1){
        return kMeUnArr(self.arrCommendModel).count?kMEProductDetalsBuyedCellHeight:1;
    }else if(indexPath.section == 2){
        return _isExpand?[MEMineExchangeRudeCell getCellHeight:_str]:0;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.section);

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section!=2?kMEProductDetailsSectionViewHeight:kMEMineExchangeRudeSectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section!=2){
        MEProductDetailsSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEProductDetailsSectionView class])];
        headview.lblTitle.text = kMeUnArr(_arrTitle)[section];
        return headview;
    }else{
        MEMineExchangeRudeSectionView *headview=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MEMineExchangeRudeSectionView class])];
        kMeWEAKSELF
        [headview setUIWihtStr:kMeUnArr(_arrTitle)[section] isExpand:_isExpand ExpandBlock:^(BOOL isExpand) {
            kMeSTRONGSELF
            strongSelf->_isExpand = isExpand;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:2];
            [strongSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        return headview;
    }
}

- (void)toCustom{
//    if(kMeUnNilStr(_customId).length){
//        MERCConversationVC *conversationVC = [[MERCConversationVC alloc]init];
//        conversationVC.conversationType = ConversationType_PRIVATE;
//        conversationVC.targetId =  kMeUnNilStr(_customId);//RONGYUNCUSTOMID;
//        conversationVC.title = @"客服";
//        if([kMeUnNilStr(_customId) isEqualToString:kCurrentUser.uid]){
//            [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:self.view];
//        }else{
//            [self.navigationController pushViewController:conversationVC animated:YES];
//        }
//    }else{
//        kMeWEAKSELF
//        [MEPublicNetWorkTool postGetCustomIdWithsuccessBlock:^(ZLRequestResponse *responseObject) {
//            kMeSTRONGSELF
//            NSNumber *custom =kMeUnNilNumber(responseObject.data);
//            strongSelf->_customId = kMeUnNilStr(custom.description);
//            MERCConversationVC *conversationVC = [[MERCConversationVC alloc]init];
//            conversationVC.conversationType = ConversationType_PRIVATE;
//            conversationVC.targetId = strongSelf->_customId ;//RONGYUNCUSTOMID;
//            conversationVC.title = @"客服";
//            if([kMeUnNilStr(strongSelf->_customId) isEqualToString:kCurrentUser.uid]){
//                [MEShowViewTool showMessage:@"暂不支持和自己聊天" view:self.view];
//            }else{
//                [self.navigationController pushViewController:conversationVC animated:YES];
//            }
//        } failure:^(id object) {
//
//        }];
//    }
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEExchangDetailsBottomViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetalsBuyedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEProductDetalsBuyedCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetailsSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEProductDetailsSectionView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMineExchangeRudeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEMineExchangeRudeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMineExchangeRudeSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MEMineExchangeRudeSectionView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEProductDetailsHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"MEProductDetailsHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MEProductDetailsHeaderView getViewHeight]);
    }
    return _headerView;
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

- (MEExchangDetailsBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MEExchangDetailsBottomView" owner:nil options:nil] lastObject];
        kMeWEAKSELF
        _bottomView.exchangeBlock  = ^{
            //            kMeSTRONGSELF
            //            [MECommonTool showWithTellPhone:kMeUnNilStr(strongSelf->_storeDetailModel.cellphone) inView:strongSelf.view];
            if([MEUserInfoModel isLogin]){
                kMeSTRONGSELF
                [strongSelf.purchaseView show];
            }else{
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    [strongSelf.purchaseView show];
                } failHandler:nil];
            }
        };
        _bottomView.customBlock = ^{
            kMeSTRONGSELF
            if([MEUserInfoModel isLogin]){
                [strongSelf toCustom];
            }else{
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    [strongSelf toCustom];
                } failHandler:nil];
            }
        };
    }
    return _bottomView;
}

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}

- (MESkuBuyView *)purchaseView{
    if(!_purchaseView){
        _purchaseView = [[MESkuBuyView alloc]initPurchaseViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) serviceModel:_model WithSuperView:self.view isInteral:YES];
    }
    return _purchaseView;
}

@end

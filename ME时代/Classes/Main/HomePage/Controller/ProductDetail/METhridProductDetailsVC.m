//
//  METhridProductDetailsVC.m
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridProductDetailsVC.h"
#import "METhridProductDetailsHeaderView.h"
#import "METhridNoticeProductDetailsHeaderView.h"
#import "METhridProductDetailsRushCell.h"
#import "METhridProductDetailsTipCell.h"
#import "METhridProductDetailsCommentCell.h"
#import "METhridProductDetailsSelectSkuCell.h"
#import "MEProductDetailsBottomView.h"
#import "TDWebViewCell.h"
#import "MESkuBuyView.h"
#import "MEGoodDetailModel.h"
#import "MEMakeOrderVC.h"
#import "MEShoppingCartAttrModel.h"
#import "MEGiftVC.h"
#import "MEGoodModel.h"
#import "MEProductDetalsBuyedCell.h"
#import "MENewProductDetailsSectionView.h"
#import "MERCConversationVC.h"
#import "MEProductDetailCommentVC.h"

typedef NS_ENUM(NSUInteger, kpurchaseViewType) {
    kpurchaseSelectSkuViewType,
    kpurchaseViewBuyType,
    kpurchaseViewShoppingType,
};

@interface METhridProductDetailsVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _detailsId;
    NSArray *_arrTitle;
    kpurchaseViewType _selectType;
    NSString *_customId;
    METhridProductDetailsVCType _type;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) MEProductDetailsBottomView *bottomView;
@property (nonatomic, strong) METhridProductDetailsHeaderView *headerView;
@property (nonatomic, strong) METhridNoticeProductDetailsHeaderView *normalheaderView;;
@property (strong, nonatomic) TDWebViewCell                  *webCell;
@property (nonatomic, strong) UIView *tableViewBottomView;
@property (nonatomic, strong) MESkuBuyView *purchaseView;
@property (nonatomic, strong) MEGoodDetailModel *model;
@property (nonatomic, strong) NSArray *arrCommendModel;//推荐
//@property (nonatomic, strong) NSArray *arrCommentModel;//评论
@end




@implementation METhridProductDetailsVC

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
    self.title = @"产品详情";
    _arrTitle = @[@"",@"商品详情",@"买了这件商品的人也买了"];
    [self initWithSomeThing];
    kTDWebViewCellDidFinishLoadNotification
    // Do any additional setup after loading the view.
}

kTDWebViewCellDidFinishLoadNotificationMethod

- (void)initWithSomeThing{
    kMeWEAKSELF
    [MEPublicNetWorkTool postGoodsDetailWithGoodsId:_detailsId seckillTime:kMeUnNilStr(self.time) successBlock:^(ZLRequestResponse *responseObject) {
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
    _selectType = kpurchaseSelectSkuViewType;
    _type = model.is_seckill;
    [self.view addSubview:self.tableView];
    switch (_type) {
        case METhridProductDetailsVCRudeType:{
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView setUIWithModel:model];
            [self.headerView downSecondHandle:model.seckill_end_time];
            self.bottomView.seckilltime = self.time;
            }
            break;
        case METhridProductDetailsVCNoticeType:{
            self.tableView.tableHeaderView = self.normalheaderView;
            [self.normalheaderView setUINoticeWithModel:model];
            self.bottomView.seckilltime = self.time;
            [self.normalheaderView downSecondHandle:model.seckill_start_time];
        }
            break;
        case METhridProductDetailsVCNormalType:{
            self.tableView.tableHeaderView = self.normalheaderView;
            [self.normalheaderView setNormalUIWithModel:model];
        }
            break;
        default:
            break;
    }
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
                switch (strongSelf->_type) {
                    case METhridProductDetailsVCRudeType:{
                         [strongSelf.headerView setUIWithModel:strongSelf->_model];
                    }
                        break;
                    case METhridProductDetailsVCNoticeType:{
                      
                        [strongSelf.normalheaderView setUINoticeWithModel:strongSelf->_model];
                    }
                        break;
                    case METhridProductDetailsVCNormalType:{
                   
                        [strongSelf.normalheaderView setNormalUIWithModel:strongSelf->_model];
                    }
                        break;
                    default:
                        break;
                }
               [strongSelf.tableView reloadData];
            }
                break;
            case kpurchaseViewBuyType:{
                //生成订单
                MEMakeOrderVC *vc = [[MEMakeOrderVC alloc]initWithIsinteral:NO goodModel:strongSelf->_model];
                vc.uid = kMeUnNilStr(strongSelf.uid);
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case kpurchaseViewShoppingType:{
                //加入购物车
                MEShoppingCartAttrModel *attrModle = [[MEShoppingCartAttrModel alloc]initWithGoodmodel:strongSelf->_model];
                if(strongSelf.isGift){
                    attrModle.type = 6;
                }
                attrModle.uid = kMeUnNilStr(strongSelf.uid);
                [MEPublicNetWorkTool postAddGoodForShopWithAttrModel:attrModle successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    kNoticeReloadShopCart
                    if(strongSelf.isGift){
                        MEGiftVC *vc = (MEGiftVC *)[MECommonTool getClassWtihClassName:[MEGiftVC class] targetVC:strongSelf];
                        [strongSelf.navigationController popToViewController:vc animated:YES];
                    }
                    
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
        switch (strongSelf->_type) {
            case METhridProductDetailsVCRudeType:{
                [strongSelf.headerView setUIWithModel:strongSelf->_model];
            }
                break;
            case METhridProductDetailsVCNoticeType:{
                [strongSelf.normalheaderView setUINoticeWithModel:strongSelf->_model];
            }
                break;
            case METhridProductDetailsVCNormalType:{
                
                [strongSelf.normalheaderView setNormalUIWithModel:strongSelf->_model];
            }
                break;
            default:
                break;
        }
    };
    [MBProgressHUD showMessage:@"获取详情中" toView:self.view];
    [MEPublicNetWorkTool postGoodsListWithType:MEGoodsTypeNetCommendStyle successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSArray *arr = [MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
        strongSelf.arrCommendModel = arr;
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(id object) {
        
    }];
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!section){
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0: {
                if(kMeUnNilStr(_model.rudeTip).length &&  _type != METhridProductDetailsVCNormalType){
                    METhridProductDetailsRushCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridProductDetailsRushCell class]) forIndexPath:indexPath];
                    cell.lblTitle.text = kMeUnNilStr(_model.rudeTip);
                    return cell;
                }
            }
                break;
            case 1: {
                if(kMeUnNilStr(_model.tips).length){
                    METhridProductDetailsTipCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridProductDetailsTipCell class]) forIndexPath:indexPath];
                    cell.lblTip.text = @"提示";
                    [cell setUiWithStr:_model.tips];
                    return cell;
                }
            }
                break;
            case 2: {
                if(kMeUnNilStr(_model.message).length){
                    METhridProductDetailsTipCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridProductDetailsTipCell class]) forIndexPath:indexPath];
                    cell.lblTip.text = @"通知";
                    [cell setUiWithStr:_model.message];
                    return cell;
                }
            }
                break;
            case 3: {
                if(kMeUnArr(_model.product_comment).count){
                    METhridProductDetailsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridProductDetailsCommentCell class]) forIndexPath:indexPath];
                    [cell setUIWithArr:kMeUnArr(_model.product_comment) commentNum:kMeUnNilStr(_model.comment_count) goodNUm:kMeUnNilStr(_model.equities)];
                    return cell;
                }
            }
                break;
            case 4: {
                METhridProductDetailsSelectSkuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([METhridProductDetailsSelectSkuCell class]) forIndexPath:indexPath];
                cell.lblSku.text = [NSString stringWithFormat:@"已选:数量x%@,规格:%@",@(_model.buynum),kMeUnNilStr(_model.skus)];
                return cell;
            }
                break;
            default:{
                return [UITableViewCell new];
            }
                break;
        }
    }else if(indexPath.section == 1){
        return self.webCell;
    }else if(indexPath.section == 2){
        MEProductDetalsBuyedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEProductDetalsBuyedCell class]) forIndexPath:indexPath];
        [cell setUIWithArr:kMeUnArr(self.arrCommendModel)];
        return cell;
    }else{
        return [UITableViewCell new];
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        switch (indexPath.row) {
            case 0: {
                if(kMeUnNilStr(_model.rudeTip).length && _type != METhridProductDetailsVCNormalType){
                    return kMEThridProductDetailsRushCellHeight;
                }
            }
                break;
            case 1: {
                if(kMeUnNilStr(_model.tips).length){
                   return [METhridProductDetailsTipCell getCellHeightWithStr:_model.tips];
                }
            }
                break;
            case 2: {
                if(kMeUnNilStr(_model.message).length){
                     return [METhridProductDetailsTipCell getCellHeightWithStr:_model.message];
                }
            }
                break;
            case 3: {
                if(kMeUnArr(_model.product_comment).count){
                    return kMEThridProductDetailsCommentCellHeight;
                }
            }
                break;
            case 4: {
                return kMEThridProductDetailsSelectSkuCellHeight;
            }
                break;
            default:{
                return 0.1;
            }
                break;
        }
    }else if(indexPath.section==1){
        if(!_webCell){
            return 0;
        }else{
            return [[self.webCell.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
        }
    }else if(indexPath.section == 2){
        return kMeUnArr(self.arrCommendModel).count?kMEProductDetalsBuyedNewCellHeight:1;
    }else{
        return 0.1;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row==4){
        [self showBuyViewWithTypy:kpurchaseSelectSkuViewType];
    }
    if(indexPath.section == 0 && indexPath.row==3 && _model){
        MEProductDetailCommentVC *vc = [[MEProductDetailCommentVC alloc]initWithModel:_model];
        [self.navigationController pushViewController:vc animated:YES];
    }
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


#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEProductDetailsBottomViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TDWebViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TDWebViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductDetalsBuyedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEProductDetalsBuyedCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridProductDetailsRushCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridProductDetailsRushCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridProductDetailsTipCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridProductDetailsTipCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridProductDetailsCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridProductDetailsCommentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([METhridProductDetailsSelectSkuCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([METhridProductDetailsSelectSkuCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MENewProductDetailsSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MENewProductDetailsSectionView class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (MEProductDetailsBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [[[NSBundle mainBundle]loadNibNamed:@"MEProductDetailsBottomView" owner:nil options:nil] lastObject];
        _bottomView.btnGift.hidden = _type==METhridProductDetailsVCNormalType;//!self.isGift;
        _bottomView.model = _model;
        kMeWEAKSELF
        _bottomView.buyBlock = ^{
            kMeSTRONGSELF
            [strongSelf showBuyViewWithTypy:kpurchaseViewBuyType];
        };
        _bottomView.addShopcartBlock = ^{
            kMeSTRONGSELF
            if(strongSelf.model.product_type == 15){
                [MEShowViewTool showMessage:@"该商品不支持加入购物车" view:kMeCurrentWindow];
            }else{
                [strongSelf showBuyViewWithTypy:kpurchaseViewShoppingType];
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

- (METhridProductDetailsHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[[NSBundle mainBundle]loadNibNamed:@"METhridProductDetailsHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [METhridProductDetailsHeaderView getHeightWithModel:_model]);
    }
    return _headerView;
}

- (METhridNoticeProductDetailsHeaderView *)normalheaderView{
    if(!_normalheaderView){
        _normalheaderView = [[[NSBundle mainBundle]loadNibNamed:@"METhridNoticeProductDetailsHeaderView" owner:nil options:nil] lastObject];
        if(_type == METhridProductDetailsVCNormalType){
            _normalheaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [METhridNoticeProductDetailsHeaderView getNormalHeightWithModel:_model]);
        }
        else if(_type == METhridProductDetailsVCNoticeType){
            _normalheaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [METhridNoticeProductDetailsHeaderView getNoticeHeightWithModel:_model]);
        }
    }
    return _normalheaderView;
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

- (TDWebViewCell *)webCell{
    if(!_webCell){
        _webCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TDWebViewCell class])];
    }
    return _webCell;
}


@end

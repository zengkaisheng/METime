//
//  METhridHomeHeaderView.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeHeaderView.h"
#import "METhridHomeModel.h"
#import "METhridHomeVC.h"
#import "METhridProductDetailsVC.h"
#import "MEServiceDetailsVC.h"
#import "MEMidelButton.h"
#import "MEProductListVC.h"
#import "MECoupleHomeVC.h"
#import "METhridRushSpikeVC.h"
#import "MEFilterVC.h"
#import "MEJDCoupleHomeVC.h"
#import "MEStoreModel.h"
#import "MEStoreDetailModel.h"
#import "MENewStoreDetailsVC.h"
#import "MEFilterVC.h"
#import "MECoupleMailVC.h"
#import "MERCConversationListVC.h"
#import "MERCConversationVC.h"
#import "ZLWebViewVC.h"
#import "MEAddTbView.h"

typedef NS_ENUM(NSUInteger, METhridHomeHeaderViewActiveType) {
//    METhridHomeHeaderViewActiveNewType = 0,
//    METhridHomeHeaderViewActiveRudeType =1,
    METhridHomeHeaderViewActiveTb99couponType = 0,
    METhridHomeHeaderViewActiveTbcouponType = 1,
    METhridHomeHeaderViewActivePinduoduoCouponType = 2,
    METhridHomeHeaderViewActiveJDType =3,
    METhridHomeHeaderViewActiveBigJuanType =4
    
};

@interface METhridHomeHeaderView ()<SDCycleScrollViewDelegate>{
    METhridHomeModel *_model;
    MEStoreModel *_storeModel;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSdHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imgStore;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) MEAddTbView *addTbVIew;

@end

@implementation METhridHomeHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    _btnShare.hidden = ![WXApi isWXAppInstalled];
    _sdView.delegate = self;
    _consSdHeight.constant = kSdHeight*kMeFrameScaleX();
    self.userInteractionEnabled = YES;
}

- (IBAction)shareAction:(UIButton *)sender {
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@&inviteCode=%@",MEIPShare,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];;
    NSLog(@"%@",MEIPShare);
    shareTool.shareTitle = @"一款自买省钱分享赚钱的购物神器！";
    shareTool.shareDescriptionBody = @"包含淘宝、京东、拼多多等平台大额隐藏优惠劵！赶快试一试！";
    shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
    
    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession success:^(id data) {
        NSLog(@"分享成功%@",data);
        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
    } failure:^(NSError *error) {
        NSLog(@"分享失败%@",error);
        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
    }];
}

- (IBAction)toStoreAction:(UIButton *)sender {

}

- (IBAction)chatAction:(UIButton *)sender {
    if([MEUserInfoModel isLogin]){
        [self toChat];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
//            [strongSelf toChat];
        } failHandler:nil];
    }
}

- (void)toChat{
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(_storeModel){
        if([kMeUnNilStr(_storeModel.tls_id) isEqualToString:kMeUnNilStr(kCurrentUser.tls_data.tls_id)]){
            MERCConversationListVC *cvc = [[MERCConversationListVC alloc]init];
            [homeVC.navigationController pushViewController:cvc animated:YES];
        }else{
            TConversationCellData *data = [[TConversationCellData alloc] init];
            data.convId =kMeUnNilStr(_storeModel.tls_id);
            data.convType = TConv_Type_C2C;
            data.title = kMeUnNilStr(_storeModel.store_name);;
            MERCConversationVC *chat = [[MERCConversationVC alloc] initWIthconversationData:data];
            [homeVC.navigationController pushViewController:chat animated:YES];
        }
    }else{
        MERCConversationListVC *cvc = [[MERCConversationListVC alloc]init];
        [homeVC.navigationController pushViewController:cvc animated:YES];
    }
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    kMeCallBlock(_scrollToIndexBlock,index);
}

- (void)saveClickRecordsWithType:(NSString *)type params:(NSDictionary *)params {
    NSDate *date = [[NSDate alloc] init];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [tempDic setObject:[date getNowDateFormatterString] forKey:@"created_at"];
    NSString *paramsStr = [NSString convertToJsonData:tempDic];
    
    NSMutableArray *records = [[NSMutableArray alloc] init];
    if ([kMeUserDefaults objectForKey:kMEGetClickRecord]) {
        [records addObjectsFromArray:(NSArray *)[kMeUserDefaults objectForKey:kMEGetClickRecord]];
    }
    
    [records addObject:@{@"type":type,@"parameter":paramsStr}];
    [kMeUserDefaults setObject:records forKey:kMEGetClickRecord];
    [kMeUserDefaults synchronize];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    METhridHomeAdModel *model = kMeUnArr(_model.top_banner)[index];
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    
    if (model.is_need_login == 1) {
        if(![MEUserInfoModel isLogin]){
            kMeWEAKSELF
            [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                kMeSTRONGSELF
                if (strongSelf.reloadBlock) {
                    strongSelf.reloadBlock();
                }
            } failHandler:nil];
            return;
        }
    }
    
    NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork)};
    [self saveClickRecordsWithType:@"1" params:params];
    
    switch (model.show_type) {//0无操作,1跳商品祥情,2跳服务祥情,3跳内链接,4跳外链接,5跳H5（富文本）,6跳文章,7跳海报，8跳淘宝活动需添加渠道,9首页右下角图标
        case 1:
        {
            if(homeVC){
                METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [homeVC.navigationController pushViewController:dvc animated:YES];
            }
        }
            break;
        case 2:
        {
            if(homeVC){
                MEServiceDetailsVC *dvc = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
                [homeVC.navigationController pushViewController:dvc animated:YES];
            }
        }
            break;
        case 3:
        {
            if(homeVC){
                ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
                webVC.showProgress = YES;
                [webVC loadURL:[NSURL URLWithString:kMeUnNilStr(model.ad_url)]];
                [homeVC.navigationController pushViewController:webVC animated:YES];
            }
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
            if(homeVC){
                MEBaseVC *vc = [[MEBaseVC alloc] init];
                vc.title = @"详情";
                
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
                [webView loadHTMLString:model.content baseURL:nil];
                [vc.view addSubview:webView];
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
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
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if (homeVC) {
        [homeVC.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)checkRelationIdWithUrl:(NSString *)url {
    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
//        [self openAddTbView];
        [self obtainTaoBaoAuthorizeWithUrl:url];
    }else{
        if (url.length > 0) {
            METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            NSString *str = [url stringByAppendingString:rid];
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = @"活动主会场";
            [webVC loadURL:[NSURL URLWithString:str]];
            [homeVC.navigationController pushViewController:webVC animated:YES];
        }
    }
}

- (void)openAddTbView{
    kMeWEAKSELF
    [MEPublicNetWorkTool postShareTaobaokeGetInviterUrlWithsuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSString *strApi = kMeUnNilStr(responseObject.data[@"url"]);
        NSURL *url = [NSURL URLWithString:strApi];
        [[UIApplication sharedApplication] openURL:url];
        strongSelf.addTbVIew.url = strApi;
        [strongSelf.addTbVIew show];
    } failure:^(id object) {
    }];
}

- (void)setUIWithModel:(METhridHomeModel *)model stroeModel:(MEStoreModel *)storemodel{
    _model = model;
    _storeModel = storemodel;
    __block NSMutableArray *arrImage = [NSMutableArray array];
    [kMeUnArr(model.top_banner) enumerateObjectsUsingBlock:^(METhridHomeAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.imageURLStringsGroup = arrImage;
    _sdView.autoScrollTimeInterval = 4;
    
    //店铺
    if(storemodel){
        kSDLoadImg(_imgStore,kMeUnNilStr(storemodel.mask_img));
        _lblStoreName.text = kMeUnNilStr(storemodel.store_name);
        _lblStoreDesc.text = kMeUnNilStr(storemodel.cellphone);
    }else{
        _imgStore.image = [UIImage imageNamed:@"icon-wgvilogo"];
        _lblStoreName.text = @"ME时代旗舰店";
        _lblStoreDesc.text = @"33302156";
    }
    
}

- (IBAction)activeAction:(MEMidelMiddelImageButton *)sender {
    NSInteger index = sender.tag-kMeViewBaseTag;
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homeVC){
        switch (index) {

            case METhridHomeHeaderViewActiveTb99couponType:
            {//9.9包邮改为超值特惠
//                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearch99BuyType];
//                [homeVC.navigationController pushViewController:vc animated:YES];
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTeHuiType];
                vc.titleStr = @"超值特惠专场";
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case METhridHomeHeaderViewActiveTbcouponType:
            {
                MECoupleHomeVC *vc= [[MECoupleHomeVC alloc]initWithIsTbK:YES];
                [homeVC.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case METhridHomeHeaderViewActivePinduoduoCouponType:
            {
                MECoupleHomeVC *vc= [[MECoupleHomeVC alloc]initWithIsTbK:NO];
                [homeVC.navigationController pushViewController:vc animated:YES];

            }
                break;

            case METhridHomeHeaderViewActiveJDType:
            {
                MEJDCoupleHomeVC *vc = [[MEJDCoupleHomeVC alloc]init];
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
            case METhridHomeHeaderViewActiveBigJuanType:
            {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchGoodGoodsType];
                [homeVC.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (MEAddTbView *)addTbVIew{
    if(!_addTbVIew){
        _addTbVIew = [[[NSBundle mainBundle]loadNibNamed:@"MEAddTbView" owner:nil options:nil] lastObject];
        _addTbVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //        kMeWEAKSELF
        _addTbVIew.finishBlock = ^(BOOL sucess) {
            //            kMeSTRONGSELF
            if(sucess){
                
            }
        };
    }
    return _addTbVIew;
}


+ (CGFloat)getViewHeight{
    CGFloat height = kMEThridHomeHeaderViewHeight - kSdHeight;
    height+=(kSdHeight*kMeFrameScaleX());
    return height;
}

@end

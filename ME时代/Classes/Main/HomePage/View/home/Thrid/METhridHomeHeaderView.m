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
    shareTool.sharWebpageUrl = MEIPShare;
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

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    METhridHomeAdModel *model = kMeUnArr(_model.top_banner)[index];
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homeVC){
        METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
        [homeVC.navigationController pushViewController:dvc animated:YES];
    }
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




+ (CGFloat)getViewHeight{
    CGFloat height = kMEThridHomeHeaderViewHeight - kSdHeight;
    height+=(kSdHeight*kMeFrameScaleX());
    return height;
}

@end

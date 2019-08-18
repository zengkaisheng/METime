//
//  MEBaseDynamicVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseDynamicVC.h"
#import "MEBynamicMainCell.h"
#import "CLInputToolbar.h"
#import "MEBynamicHomeModel.h"
#import "METhridProductDetailsVC.h"
#import "IQKeyboardManager.h"
#import "MEBynamicPublishVC.h"
//#import "ALAssetsLibrary+MECategory.h"
#import "MECoupleMailDetalVC.h"

#import "MEPinduoduoCoupleModel.h"
#import "MEPinduoduoCoupleInfoModel.h"
#import "MECoupleModel.h"
#import "MEJDCoupleModel.h"
#import "MEJDCoupleMailDetalVC.h"
#import "MECoupleMailVC.h"
#import "ZLWebViewVC.h"
#import "MEBargainDetailVC.h"
#import "MEGroupProductDetailVC.h"
#import "MEJoinPrizeVC.h"

#import "MEShareCouponVC.h"
#import "MECouponInfo.h"
#import "MEGoodDetailModel.h"

@interface MEBaseDynamicVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>
{
    NSInteger _comentIndex;
    //1 动态 2 每日爆款 3宣传素材
    NSInteger _type;
    NSString *_imgUrl;
    NSString *_shareText;
    
    NSString *_Tpwd;
    MEPinduoduoCoupleInfoModel *_pinduoduoDetailmodel;
    MEGoodDetailModel *_productModel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation MEBaseDynamicVC

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.refresh addRefreshView];
    [self setTextViewToolbar];
    kOrderReload
    
    kMeWEAKSELF
    [MEPublicNetWorkTool getUserGetCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_imgUrl = kMeUnNilStr(responseObject.data);
    } failure:^(id object) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"token":kMeUnNilStr(kCurrentUser.token),@"tool":@"1",@"show_type":@(_type)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEBynamicHomeModel mj_objectArrayWithKeyValuesArray:data]];
}

- (void)reloadData {
    [self.refresh reload];
}

//- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
//    NSInteger currentindex = index+1;
//    if(currentindex == _type){
//        return;
//    }
//    _type = currentindex;
//    [self.refresh reload];
//}
#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBynamicHomeModel *model = self.refresh.arrData[indexPath.row];
    MEBynamicMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEBynamicMainCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:model];
    kMeWEAKSELF
    cell.shareBlock = ^{
//        kMeSTRONGSELF
//        [strongSelf shareAction];
    };
    cell.LikeBlock = ^{
        kMeSTRONGSELF
        [strongSelf likeAction:indexPath.row];
    };
    cell.CommentBlock = ^{
        kMeSTRONGSELF
        [strongSelf commentAction:indexPath.row];
    };
    cell.delBlock = ^{
        MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除动态吗?"];
        [aler addButtonWithTitle:@"确定" block:^{
            kMeSTRONGSELF
            [strongSelf delDyWithModel:model index:indexPath.row];
        }];
        [aler addButtonWithTitle:@"取消"];
        [aler show];
    };
    cell.saveBlock = ^{
        kMeSTRONGSELF
        [strongSelf saveAllPhotoWithIndex:indexPath.row];
    };
    return cell;
}

- (void)delDyWithModel:(MEBynamicHomeModel *)model index:(NSInteger)index{
    kMeWEAKSELF
    [MEPublicNetWorkTool postdynamicDelDynamicWithdynamicId:kMeUnNilStr(model.idField) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf.refresh.arrData removeObjectAtIndex:index];
        [strongSelf.tableView reloadData];
    } failure:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBynamicHomeModel *model = self.refresh.arrData[indexPath.row];
    return [MEBynamicMainCell getCellHeightithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MEBynamicHomeModel *model = self.refresh.arrData[indexPath.row];
    switch (model.skip_type) {
        case 1:
        {//详情
            if(model.product_id){
                METhridProductDetailsVC *dvc = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
                [self.navigationController pushViewController:dvc animated:YES];
            }
        }
            break;
        case 2:
        {//淘宝
            MECoupleModel *TBmodel = [[MECoupleModel alloc] init];
            TBmodel.min_ratio = model.min_ratio;
            
            NSDictionary *params = @{@"num_iid":kMeUnNilStr(TBmodel.num_iid),@"item_title":kMeUnNilStr(TBmodel.title)};
            [self saveClickRecordsWithType:@"25" params:params];
            
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.tbk_num_iids couponId:kMeUnNilStr(model.tbk_coupon_id) couponurl:kMeUnNilStr(model.tbk_coupon_share_url) Model:TBmodel];
            vc.recordType = 3;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {//拼多多
            MEPinduoduoCoupleModel *PDDModel = [[MEPinduoduoCoupleModel alloc] init];
            PDDModel.goods_id = model.ddk_goods_id;
            PDDModel.min_ratio = model.min_ratio;
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:PDDModel];
            vc.isDynamic = YES;
            vc.recordType = 3;
            NSDictionary *params = @{@"goods_id":kMeUnNilStr(PDDModel.goods_id),@"goods_name":kMeUnNilStr(PDDModel.goods_name),@"uid":kMeUnNilStr(kCurrentUser.uid)};
            [self saveClickRecordsWithType:@"29" params:params];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {//京东
            
            MEJDCoupleModel *JDModel = [[MEJDCoupleModel alloc] init];
            JDModel.materialUrl = model.jd_material_url;
            
            CouponContentInfo *couponInfoModel = [CouponContentInfo new];
            couponInfoModel.link = model.jd_link;
            couponInfoModel.discount = model.discount;
            couponInfoModel.useStartTime = model.useStartTime;
            couponInfoModel.useEndTime = model.useEndTime;
            
            CouponInfo *couponInfo = [CouponInfo new];
            couponInfo.couponList = @[couponInfoModel];
            
            JDModel.couponInfo = couponInfo;
            
            ImageInfo *imgInfo = [ImageInfo new];
            imgInfo.imageList = model.imageList;
            JDModel.imageInfo = imgInfo;
            
            JDModel.skuName = model.skuName;
            
            PriceInfo *priceInfo = [PriceInfo new];
            priceInfo.price = model.price;
            JDModel.priceInfo = priceInfo;
            JDModel.min_ratio = model.min_ratio;
            
            NSDictionary *params = @{@"skuId":kMeUnNilStr(JDModel.skuId),@"skuName":kMeUnNilStr(JDModel.skuName),@"uid":kMeUnNilStr(kCurrentUser.uid)};
            [self saveClickRecordsWithType:@"33" params:params];
            
            MEJDCoupleMailDetalVC *vc = [[MEJDCoupleMailDetalVC alloc]initWithModel:JDModel];
            vc.isDynamic = YES;
            vc.recordType = 3;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {//活动外链
            if (model.ad_url) {
                ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
                webVC.showProgress = YES;
                [webVC loadURL:[NSURL URLWithString:kMeUnNilStr(model.ad_url)]];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 6:
        {//拼多多列表
            if (model.ad_id) {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:model.ad_id];
                vc.recordType = 3;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 7:
        {//砍价活动
            MEBargainDetailVC *bargainVC = [[MEBargainDetailVC alloc] initWithBargainId:model.bargain_id myList:NO];
            [self.navigationController pushViewController:bargainVC animated:YES];
        }
            break;
        case 8:
        {//拼团活动
            MEGroupProductDetailVC *groupVC = [[MEGroupProductDetailVC alloc] initWithProductId:model.product_id];
            [self.navigationController pushViewController:groupVC animated:YES];
        }
            break;
        case 9:
        {//签到活动
            MEJoinPrizeVC *prizeVC = [[MEJoinPrizeVC alloc] initWithActivityId:[NSString stringWithFormat:@"%ld",(long)model.activity_id]];
            [self.navigationController pushViewController:prizeVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)saveAllPhotoWithIndex:(NSInteger)index{
    
    MEBynamicHomeModel *model = self.refresh.arrData[index];
    
    if (model.skip_type == 1) {
        kMeWEAKSELF
        [MEPublicNetWorkTool postGoodsEncodeWithProductrId:[NSString stringWithFormat:@"%ld",(long)model.product_id] successBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_shareText = kMeUnNilStr(responseObject.data[@"share_text"]);
            [strongSelf showShareViewWithModel:model];
        } failure:^(id object) {
        }];
    }else {
        _shareText = model.goods_title;
        [self showShareViewWithModel:model];
    }
    NSString *typeStr;
    switch (_type) {
        case 1:
            typeStr = @"12";
            break;
        case 2:
            typeStr = @"14";
            break;
        case 3:
            typeStr = @"16";
            break;
        default:
            break;
    }
    NSDictionary *params = @{@"uid":kMeUnNilStr(kCurrentUser.uid)};
    [self saveClickRecordsWithType:typeStr params:params];
    /*
     MEBynamicHomeModel *model = self.refresh.arrData[index];
     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
     pasteboard.string = kMeUnNilStr(model.content);
     SDWebImageManager *manager = [SDWebImageManager sharedManager];
     MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     dispatch_group_t group = dispatch_group_create();
     dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
     __block BOOL isError = NO;
     dispatch_group_async(group, queue, ^{
     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
     ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
     [kMeUnArr(model.images) enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL * _Nonnull stop) {
     NSURL *url = [NSURL URLWithString: urlString];
     [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
     UIImage *img;
     if(isInCache){
     img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
     }else{
     NSData *data = [NSData dataWithContentsOfURL:url];
     img = [UIImage imageWithData:data];
     }
     HUD.label.text = [NSString stringWithFormat:@"正在保存第%@张",@(idx+1)];
     if(img){
     [library saveImage:img toAlbum:kMEAppName withCompletionBlock:^(NSError *error) {
     NSLog(@"%@",[error description]);
     if (!error) {
     dispatch_semaphore_signal(semaphore);
     }else{
     isError = YES;
     dispatch_semaphore_signal(semaphore);
     *stop = YES;
     }
     }];
     }else{
     [MEShowViewTool showMessage:@"图片出错" view:kMeCurrentWindow];
     dispatch_semaphore_signal(semaphore);
     }
     }];
     dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
     }];
     });
     
     dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     dispatch_async(dispatch_get_main_queue(), ^{
     [HUD hideAnimated:YES];
     if(isError){
     [[[UIAlertView alloc]initWithTitle:@"无法保存" message:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的照片" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
     }else{
     [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"图片已保存至您的手机相册并复制描述" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
     }
     });
     });
     */
}

//获取淘宝授权
- (void)obtainTaoBaoAuthorizeWithModel:(MEBynamicHomeModel*)model {
    NSString *str = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25425439&redirect_uri=http://test.meshidai.com/src/taobaoauthorization.html&view=wap";
    ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
    webVC.showProgress = YES;
    webVC.title = @"获取淘宝授权";
    [webVC loadURL:[NSURL URLWithString:str]];
    kMeWEAKSELF
    webVC.authorizeBlock = ^{
        kMeSTRONGSELF
        [strongSelf showShareViewWithModel:model];
    };
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark ---- 判断优惠券是否有效方法
- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}

-(BOOL)downSecondHandle:(NSString *)aTimeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *endTimeStr = [self getTimeFromTimestamp:aTimeString];
    NSDate *endDate = [self timeWithTimeIntervalString:kMeUnNilStr(endTimeStr)]; //结束时间
    
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    NSDate *startDate = [NSDate date];
    NSString* dateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"现在的时间 === %@",dateString);
    NSTimeInterval timeInterval = [endDate_tomorrow timeIntervalSinceDate:startDate];
    int timeout = timeInterval;
    return timeout>0?YES:NO;
}
//淘宝优惠券有效期判断方法
- (BOOL)compareWithendTime:(NSString *)endTime {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [dateFormatter dateFromString:kMeUnNilStr(endTime)];//结束时间
    
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    NSDate *startDate = [NSDate date];
    NSString* dateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"现在的时间 === %@",dateString);
    NSTimeInterval timeInterval = [endDate_tomorrow timeIntervalSinceDate:startDate];
    int timeout = timeInterval;
    return timeout>0?YES:NO;
}
#pragma mark ---- 将时间戳转换成时间
- (NSString *)getTimeFromTimestamp:(NSString *)time{
    //将对象类型的时间转换为NSDate类型
    //    double time =1504667976;
    NSDate * myDate= [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    
    return timeStr;
}
//获取拼多多优惠券详情
- (void)requestPinduoduoNetWorkWithPinduoudoModel:(MEPinduoduoCoupleModel*)model{
    kMeWEAKSELF
    [MEPublicNetWorkTool postPinDuoduoGoodsDetailWithGoodsId:kMeUnNilStr(model.goods_id) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSArray *arr =  responseObject.data[@"goods_detail_response"][@"goods_details"];
        if(kMeUnArr(arr).count){
            strongSelf->_pinduoduoDetailmodel = [MEPinduoduoCoupleInfoModel mj_objectWithKeyValues:arr[0]];
            if (kMeUnNilStr(strongSelf->_pinduoduoDetailmodel.coupon_end_time).length<=0||![strongSelf downSecondHandle:strongSelf->_pinduoduoDetailmodel.coupon_end_time]) {
                [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:strongSelf.view];
            }else {
                strongSelf->_pinduoduoDetailmodel.min_ratio = model.min_ratio;
                [strongSelf sharePDDCouponWithPinduoudoModel:model];
            }
        }else{
            [MECommonTool showMessage:@"很抱歉，暂无优惠券" view:strongSelf.view];
        }
    } failure:^(id object) {
    }];
}
//拼多多分享
- (void)sharePDDCouponWithPinduoudoModel:(MEPinduoduoCoupleModel*)model{
    //拼多多
    NSString *goodId = [NSString stringWithFormat:@"[%@]",kMeUnNilStr(model.goods_id)];
    kMeWEAKSELF
    [MEPublicNetWorkTool postPromotionUrlGenerateWithUid:kMeUnNilStr(kCurrentUser.uid) goods_id_list:goodId SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        NSArray *arr = responseObject.data[@"goods_promotion_url_generate_response"][@"goods_promotion_url_list"];
        if(arr && arr.count){
            NSDictionary *dict = arr[0];
            MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithPDDModel:strongSelf->_pinduoduoDetailmodel codeword:dict[@"we_app_web_view_short_url"]];
            [strongSelf.navigationController pushViewController:shareVC animated:YES];
        }
    } failure:^(id object) {
        
    }];
}
//获取淘宝优惠券详情
- (void)requestNetWorkWithDetailId:(NSString *)detailId couponId:(NSString *)couponId TBmodel:(MECoupleModel *)TBmodel complationBlock:(kMeObjBlock)complationBlock{

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [MBProgressHUD showMessage:@"获取详情中" toView:self.view];
    kMeWEAKSELF
    __block MECoupleModel *tbModel = TBmodel;
    __block MECouponInfo *couponInfoModel = [[MECouponInfo alloc] init];
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postCoupleDetailWithProductrId:detailId successBlock:^(ZLRequestResponse *responseObject) {
            if([responseObject.data isKindOfClass:[NSDictionary class]]){
                NSArray *arr= responseObject.data[@"tbk_item_info_get_response"][@"results"][@"n_tbk_item"];
                if([arr isKindOfClass:[NSArray class]] && arr.count){
                    tbModel = [MECoupleModel mj_objectWithKeyValues:arr[0]];
                }else{
                    tbModel = [MECoupleModel new];
                }
                dispatch_semaphore_signal(semaphore);
            }
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postCoupleTbkCouponGetWithActivity_id:kMeUnNilStr(couponId) item_id:kMeUnNilStr(detailId) successBlock:^(ZLRequestResponse *responseObject) {
            couponInfoModel = [MECouponInfo mj_objectWithKeyValues:responseObject.data[@"tbk_coupon_get_response"][@"data"]];
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
            [MBProgressHUD hideHUDForView:strongSelf.view];
            if (couponInfoModel) {
                [tbModel resetModelWithModel:couponInfoModel];
                if (complationBlock) {
                    complationBlock(tbModel);
                }
            }else {
                [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:strongSelf.view];
            }
        });
    });
}
//自营商品分享
- (void)sharActionWithOurProductsWithModel:(MEBynamicHomeModel*)model{
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
    baseUrl = [@"http" stringByAppendingString:baseUrl];
    if(_productModel.is_clerk_share){
        if(kCurrentUser.client_type == MEClientTypeClerkStyle){
            [self getShareEncodeWithModel:model];
        }else{
            
            //https://msd.meshidai.com/meAuth.html?entrance=productShare&uid=%@&goodsid=%@&seckilltime=%@&command=%@
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@productShare/newAuth.html?uid=%@&goodsid=%@&seckilltime=%@&command=%@&inviteCode=%@",baseUrl,kMeUnNilStr(kCurrentUser.uid),[NSString stringWithFormat:@"%@",@(model.product_id)],@"",@"",[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            //http://test.meshidai.com/productShare/newAuth.html？uid=1&goodsid=2&seckilltime=&command=&inviteCode=A6F96C
            shareTool.shareTitle = kMeUnNilStr(_productModel.title); //@"睁着眼洗的洁面慕斯,你见过吗?";
            shareTool.shareDescriptionBody = kMeUnNilStr(_productModel.desc).length?kMeUnNilStr(_productModel.desc):kMeUnNilStr(_productModel.title);//@"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
            shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            }];
        }
    }else{
        
        //https://msd.meshidai.com/meAuth.html?entrance=productShare&uid=%@&goodsid=%@&seckilltime=%@&command=%@
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@productShare/newAuth.html?uid=%@&goodsid=%@&seckilltime=%@&command=%@&inviteCode=%@",baseUrl,kMeUnNilStr(kCurrentUser.uid),[NSString stringWithFormat:@"%@",@(model.product_id)],@"",@"",[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
        NSLog(@":%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = kMeUnNilStr(_productModel.title); //@"睁着眼洗的洁面慕斯,你见过吗?";
        shareTool.shareDescriptionBody = kMeUnNilStr(_productModel.desc).length?kMeUnNilStr(_productModel.desc):kMeUnNilStr(_productModel.title);//@"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
        shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
        [shareTool showShareView:kShareWebPageContentType success:^(id data) {
            [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
            [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
        } failure:^(NSError *error) {
            [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
        }];
    }
}

- (void)getShareEncodeWithModel:(MEBynamicHomeModel*)model {
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    kMeWEAKSELF
    __block NSString *paoductIdEndoceStr = @"";
    [MEPublicNetWorkTool postGoodsEncodeWithProductrId:[NSString stringWithFormat:@"%@",@(model.product_id)] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        paoductIdEndoceStr = kMeUnNilStr(responseObject.data[@"share_text"]);
        
        NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
        baseUrl = [@"http" stringByAppendingString:baseUrl];
        
        //https://msd.meshidai.com/meAuth.html?entrance=productShare&uid=%@&goodsid=%@&seckilltime=%@&command=%@
        shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@productShare/newAuth.html?uid=%@&goodsid=%@&seckilltime=%@&command=%@&inviteCode=%@",baseUrl,kMeUnNilStr(kCurrentUser.uid),[NSString stringWithFormat:@"%@",@(model.product_id)],@"",paoductIdEndoceStr,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
        NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        
        shareTool.shareTitle = kMeUnNilStr(strongSelf->_productModel.title); //@"睁着眼洗的洁面慕斯,你见过吗?";
        shareTool.shareDescriptionBody = kMeUnNilStr(strongSelf->_productModel.desc).length?kMeUnNilStr(strongSelf->_productModel.desc):kMeUnNilStr(strongSelf->_productModel.title);//@"你敢买我就敢送,ME时代氨基酸洁面慕斯(邮费10元)";
        shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
        [shareTool showShareView:kShareWebPageContentType success:^(id data) {
            [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
            [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
        } failure:^(NSError *error) {
            [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
        }];
    } failure:^(id object) {
    }];
}

- (void)showShareViewWithModel:(MEBynamicHomeModel*)model {
    switch (model.skip_type) {
        case 1:
        {//自营商品
            if(model.product_id){
                kMeWEAKSELF
                [MEPublicNetWorkTool postGoodsDetailWithGoodsId:model.product_id seckillTime:@"" successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    strongSelf->_productModel = [MEGoodDetailModel mj_objectWithKeyValues:responseObject.data];
                    [strongSelf sharActionWithOurProductsWithModel:model];
                } failure:^(id object) {
                }];
            }
        }
            break;
        case 2:
        {//淘宝
            if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
                [self obtainTaoBaoAuthorizeWithModel:model];
            }else{
                //淘宝
                MECoupleModel *TBmodel = [[MECoupleModel alloc] init];
                TBmodel.min_ratio = model.min_ratio;
                
                [self requestNetWorkWithDetailId:kMeUnNilStr(model.tbk_num_iids) couponId:kMeUnNilStr(kMeUnNilStr(model.tbk_coupon_id)) TBmodel:TBmodel complationBlock:^(id object) {
                    kMeWEAKSELF
                    if ([object isKindOfClass:[MECoupleModel class]]) {
                        MECoupleModel *tbModel = (MECoupleModel *)object;
                        NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
                        NSString *str = [[NSString stringWithFormat:@"https:%@",kMeUnNilStr(model.tbk_coupon_share_url)] stringByAppendingString:rid];
                        [MEPublicNetWorkTool postTaobaokeGetTpwdWithTitle:kMeUnNilStr(tbModel.title) url:str logo:kMeUnNilStr(tbModel.pict_url) successBlock:^(ZLRequestResponse *responseObject) {
                            kMeSTRONGSELF
                            strongSelf->_Tpwd = kMeUnNilStr(responseObject.data[@"tbk_tpwd_create_response"][@"data"][@"model"]);
                            MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithTBModel:tbModel codeword:strongSelf->_Tpwd];
                            [strongSelf.navigationController pushViewController:shareVC animated:YES];
                            strongSelf->_Tpwd = @"";
                        } failure:^(id object) {
                        }];
                    }
                }];
            }
        }
            break;
        case 3:
        {//拼多多
            MEPinduoduoCoupleModel *PDDModel = [[MEPinduoduoCoupleModel alloc] init];
            PDDModel.goods_id = model.ddk_goods_id;
            PDDModel.min_ratio = model.min_ratio;
            
            [self requestPinduoduoNetWorkWithPinduoudoModel:PDDModel];
        }
            break;
        case 4:
        {//京东
            
            MEJDCoupleModel *JDModel = [[MEJDCoupleModel alloc] init];
            JDModel.materialUrl = model.jd_material_url;
            
            CouponContentInfo *couponInfoModel = [CouponContentInfo new];
            couponInfoModel.link = model.jd_link;
            couponInfoModel.discount = model.discount;
            couponInfoModel.useStartTime = model.useStartTime;
            couponInfoModel.useEndTime = model.useEndTime;
            
            CouponInfo *couponInfo = [CouponInfo new];
            couponInfo.couponList = @[couponInfoModel];
            
            JDModel.couponInfo = couponInfo;
            
            ImageInfo *imgInfo = [ImageInfo new];
            imgInfo.imageList = model.imageList;
            JDModel.imageInfo = imgInfo;
            
            JDModel.skuName = model.skuName;
            
            PriceInfo *priceInfo = [PriceInfo new];
            priceInfo.price = model.price;
            JDModel.priceInfo = priceInfo;
            JDModel.min_ratio = model.min_ratio;
            
            if (kMeUnNilStr(couponInfoModel.useEndTime).length<=0||![self downSecondHandle:[NSString stringWithFormat:@"%@",@([couponInfoModel.useEndTime doubleValue]/1000)]]) {
                [MECommonTool showMessage:@"很抱歉，该优惠券已过期" view:self.view];
            }else {
                kMeWEAKSELF
                [MEPublicNetWorkTool postJDPromotionUrlGenerateWithUid:kCurrentUser.uid materialUrl:kMeUnNilStr(JDModel.materialUrl) couponUrl:kMeUnNilStr(couponInfoModel.link) successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    strongSelf->_Tpwd = responseObject.data[@"shortURL"];
                    MEShareCouponVC *shareVC = [[MEShareCouponVC alloc] initWithJDModel:JDModel codeword:kMeUnNilStr(strongSelf->_Tpwd)];
                    [strongSelf.navigationController pushViewController:shareVC animated:YES];
                    strongSelf->_Tpwd = @"";
                } failure:^(id object) {
                }];
            }
        }
            break;
        case 5:
        {//活动外链
            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@article.html?id=%@&img=%@&text=%@&inviteCode=%@",baseUrl,model.idField,_imgUrl,_shareText,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            //    NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = model.title;
            shareTool.shareDescriptionBody = model.content;
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
            break;
        case 6:
        {//拼多多列表
            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            //http://test.meshidai.com/api/article.html?id=%@&img=%@&text=%@&inviteCode=%@
            //http://test.meshidai.com/dynamic/home.html?id=40&inviteCode=233 新
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@dynamic/home.html?id=%@&img=%@&text=%@&inviteCode=%@",baseUrl,model.idField,_imgUrl,_shareText,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            //    NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
        

            shareTool.shareTitle = model.title;
            shareTool.shareDescriptionBody = model.content;
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
            break;
        case 7:
        {//砍价活动
            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            
            //https://test.meshidai.com/bargaindist/newAuth.html?id=7&uid=xxx
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@bargaindist/newAuth.html?id=%ld&uid=%@&inviteCode=%@",baseUrl,(long)model.bargain_id,kMeUnNilStr(kCurrentUser.uid),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = model.title;
            shareTool.shareDescriptionBody = @"好友邀请您免费拿！";
            shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.goods_images]]];
            
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            }];
        }
            break;
        case 8:
        {//拼团活动
            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            
            //https://test.meshidai.com/dist/newAuth.html?id=7&uid=xxx
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@collage/newAuth.html?id=%ld&uid=%@&inviteCode=%@",baseUrl,(long)model.product_id,kMeUnNilStr(kCurrentUser.uid),[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = model.title;
            shareTool.shareDescriptionBody = model.title;
            shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.goods_images]]];
            
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            }];
        }
            break;
        case 9:
        {//签到活动
            MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
            NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
            baseUrl = [@"http" stringByAppendingString:baseUrl];
            
            //https://test.meshidai.com/cjsrc/newAuth.html?id=21&fid=88086&img=xxx.jpg
            shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@cjsrc/newAuth.html?id=%@&fid=%@&img=%@&inviteCode=%@",baseUrl,[NSString stringWithFormat:@"%ld",(long)model.activity_id],kMeUnNilStr(kCurrentUser.uid),_imgUrl,[kMeUnNilStr(kCurrentUser.invite_code) length]>0?kMeUnNilStr(kCurrentUser.invite_code):@" "];
            NSLog(@"sharWebpageUrl:%@",shareTool.sharWebpageUrl);
            
            shareTool.shareTitle = model.title;
            shareTool.shareDescriptionBody = @"好友邀请您免费抽奖！";
            shareTool.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.goods_images]]];
            
            [shareTool showShareView:kShareWebPageContentType success:^(id data) {
                [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
                [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
            } failure:^(NSError *error) {
                [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
            }];
        }
            break;
        default:
            break;
    }
}

//- (void)shareAction{
//    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
//    shareTool.sharWebpageUrl = MEIPShare;
//    NSLog(@"%@",MEIPShare);
//    shareTool.shareTitle = @"一款自买省钱分享赚钱的购物神器！";
//    shareTool.shareDescriptionBody = @"包含淘宝、京东、拼多多等平台大额隐藏优惠劵！赶快试一试！";
//    shareTool.shareImage = kMeGetAssetImage(@"icon-wgvilogo");
//
//    [shareTool shareWebPageToPlatformType:UMSocialPlatformType_WechatSession success:^(id data) {
//        NSLog(@"分享成功%@",data);
//        [MEPublicNetWorkTool postAddShareWithSuccessBlock:nil failure:nil];
//        [MEShowViewTool showMessage:@"分享成功" view:kMeCurrentWindow];
//    } failure:^(NSError *error) {
//        NSLog(@"分享失败%@",error);
//        [MEShowViewTool showMessage:@"分享失败" view:kMeCurrentWindow];
//    }];
//}

- (void)commentAction:(NSInteger)index{
    if(index>self.refresh.arrData.count){
        return;
    }
    _comentIndex = index;
    [self didTouchBtn];
}

//- (void)pushlishAction:(UIButton *)btn{
//    MEBynamicPublishVC *vc = [[MEBynamicPublishVC alloc]init];
//    kMeWEAKSELF
//    vc.publishSucessBlock = ^{
//        kMeSTRONGSELF
//        strongSelf->_type = 1;
//        [strongSelf.categoryView selectItemAtIndex:0];
//        [strongSelf.refresh reload];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)likeAction:(NSInteger)index{
    if(index>self.refresh.arrData.count){
        return;
    }
    MEBynamicHomeModel *model = self.refresh.arrData[index];
    kMeWEAKSELF
    [MEPublicNetWorkTool postdynamicPraiselWithdynamicId:kMeUnNilStr(model.idField) successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            model.praise_over = YES;
            NSMutableArray *arrPar = [NSMutableArray array];
            MEBynamicHomepraiseModel *modelp = [[MEBynamicHomepraiseModel alloc]init];
            modelp.nick_name = kMeUnNilStr(kCurrentUser.name);
            [arrPar addObjectsFromArray:kMeUnArr(model.praise)];
            [arrPar addObject:modelp];
            model.praise = [NSArray arrayWithArray:arrPar];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    } failure:^(id object) {
        
    }];
}

-(void)didTouchBtn {
    self.maskView.hidden = NO;
    [self.inputToolbar popToolbar];
}
-(void)tapActions:(UITapGestureRecognizer *)tap {
    [self.inputToolbar bounceToolbar];
    self.maskView.hidden = YES;
}

-(void)setTextViewToolbar {
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
    
    UISwipeGestureRecognizer *recognizeru =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
    [recognizeru setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    UISwipeGestureRecognizer *recognizerd =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
    [recognizerd setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [self.maskView addGestureRecognizer:tap];
    [self.maskView addGestureRecognizer:recognizeru];
    [self.maskView addGestureRecognizer:recognizerd];
    
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    self.inputToolbar = [[CLInputToolbar alloc] init];
    self.inputToolbar.textViewMaxLine = 3;
    self.inputToolbar.fontSize = 15;
    self.inputToolbar.placeholder = @"请输入...";
    kMeWEAKSELF
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        kMeSTRONGSELF
        NSLog(@"%@",text);
        MEBynamicHomeModel *model = strongSelf.refresh.arrData[strongSelf->_comentIndex];
        [MEPublicNetWorkTool postdynamicCommentdynamicId:kMeUnNilStr(model.idField) content:kMeUnNilStr(text) successBlock:^(ZLRequestResponse *responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MEBynamicHomecommentModel *modelc = [MEBynamicHomecommentModel new];
                modelc.nick_name = kMeUnNilStr(kCurrentUser.name);
                modelc.content = kMeUnNilStr(text);
                NSMutableArray *arrPar = [NSMutableArray array];
                [arrPar addObjectsFromArray:kMeUnArr(model.comment)];
                [arrPar addObject:modelc];
                model.comment = [NSArray arrayWithArray:arrPar];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:strongSelf->_comentIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf->_comentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
                [strongSelf.inputToolbar bounceToolbar];
                strongSelf.maskView.hidden = YES;
            });
            
        } failure:^(id object) {
            
        }];
    }];
    [self.maskView addSubview:self.inputToolbar];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMeTabBarHeight-kCategoryViewHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEBynamicMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEBynamicMainCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = kMEededed;
        _tableView.tableFooterView = [UIView new];//view;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.tableView url:kGetApiWithUrl(MEIPcommongetDynamicList)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        _refresh.showMaskView = YES;
        
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有动态";
        }];
    }
    return _refresh;
}


@end

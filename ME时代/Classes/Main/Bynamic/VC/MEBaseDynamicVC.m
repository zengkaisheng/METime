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
#import "MECoupleModel.h"
#import "MEJDCoupleModel.h"
#import "MEJDCoupleMailDetalVC.h"
#import "MECoupleMailVC.h"
#import "ZLWebViewVC.h"

@interface MEBaseDynamicVC ()<UITableViewDelegate,UITableViewDataSource,RefreshToolDelegate>
{
    NSInteger _comentIndex;
    //1 动态 2 每日爆款 3宣传素材
    NSInteger _type;
    NSString *_imgUrl;
    NSString *_shareText;
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
        kMeSTRONGSELF
        [strongSelf shareAction];
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
        {
            if (model.ad_url) {
                ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
                webVC.showProgress = YES;
                [webVC loadURL:[NSURL URLWithString:kMeUnNilStr(model.ad_url)]];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 6:
        {
            if (model.ad_id) {
                MECoupleMailVC *vc = [[MECoupleMailVC alloc] initWithAdId:model.ad_id];
                vc.recordType = 3;
                [self.navigationController pushViewController:vc animated:YES];
            }
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

- (void)showShareViewWithModel:(MEBynamicHomeModel*)model {
    MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
    NSString *baseUrl = [BASEIP substringWithRange:NSMakeRange(5, BASEIP.length - 9)];
    baseUrl = [@"http" stringByAppendingString:baseUrl];
    
    shareTool.sharWebpageUrl = [NSString stringWithFormat:@"%@article.html?id=%@&img=%@&text=%@",baseUrl,model.idField,_imgUrl,_shareText];
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

- (void)shareAction{
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

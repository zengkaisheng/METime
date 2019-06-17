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
#import "MEFourHomeExchangeCell.h"
#import "MECoupleMailCell.h"
#import "MEFourHomeHeaderView.h"
#import "MEFourHomeTopHeaderView.h"
#import "MEFourHomeGoodGoodFilterHeaderView.h"
#import "MEFourHomeGoodGoodMainHeaderView.h"

#import "METhridProductDetailsVC.h"
#import "MEHomeAddRedeemcodeVC.h"
#import "MECoupleMailDetalVC.h"
#import "ZLWebViewVC.h"

#define kMEGoodsMargin ((IS_iPhoneX?10:7.5)*kMeFrameScaleX())
#define kMEThridHomeNavViewHeight (((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 129 : 107))

const static CGFloat kImgStore = 50;

@interface MEFourHomeBaseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSInteger _type;
    NSArray *_arrHot;
    METhridHomeModel *_homeModel;
    MEStoreModel *_stroeModel;
    MEHomeRecommendAndSpreebuyModel *_spreebugmodel;
    NSArray *_arrDicParm;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MEFourHomeHeaderView *headerView;
@property (nonatomic, strong) UIImageView *imgStore;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MEFourHomeBaseVC

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    _arrDicParm = @[@{@"type":@"3"},@{@"material_id":@"3756"},@{@"material_id":@"3786"},@{@"material_id":@"3767"},@{@"material_id":@"3763"},@{@"material_id":@"3760"}];
    
    self.navBarHidden = YES;
    [self.view addSubview:self.collectionView];
    _arrHot = [NSArray array];
    _homeModel = [METhridHomeModel new];
    
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

- (void)setHeaderViewUIWithModel:(METhridHomeModel *)model stroeModel:(MEStoreModel *)storemodel {
    [self.headerView setUIWithModel:model stroeModel:storemodel];
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
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    
    dispatch_group_async(group, queue, ^{
        [MEPublicNetWorkTool postThridHomehomegetRecommendWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            if ([responseObject.data isKindOfClass:[NSArray class]]) {
                strongSelf->_arrHot =[MEGoodModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            }else{
                strongSelf->_arrHot = [NSArray array];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            kMeSTRONGSELF
            strongSelf->_arrHot = [NSArray array];
            dispatch_semaphore_signal(semaphore);
        }];
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
    
    
    dispatch_group_notify(group, queue, ^{
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
        [weakSelf checkRelationId];
    }else {
        [MELoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf toStore];
        } failHandler:nil];
    }
}

- (void)checkRelationId {
    if(kMeUnNilStr(kCurrentUser.relation_id).length == 0 || [kCurrentUser.relation_id isEqualToString:@"0"]){
        [self obtainTaoBaoAuthorize];
    }else{
        if (kMeUnNilStr(_homeModel.right_bottom_img.ad_url).length > 0) {
            NSString *rid = [NSString stringWithFormat:@"&relationId=%@",kCurrentUser.relation_id];
            NSString *str = [kMeUnNilStr(_homeModel.right_bottom_img.ad_url) stringByAppendingString:rid];
            ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
            webVC.showProgress = YES;
            webVC.title = @"618狂欢主会场";
            [webVC loadURL:[NSURL URLWithString:str]];
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

//获取淘宝授权
- (void)obtainTaoBaoAuthorize {
    NSString *str = @"https://oauth.taobao.com/authorize?response_type=code&client_id=25425439&redirect_uri=http://test.meshidai.com/src/taobaoauthorization.html&view=wap";
    ZLWebViewVC *webVC = [[ZLWebViewVC alloc] init];
    webVC.showProgress = YES;
    webVC.title = @"获取淘宝授权";
    [webVC loadURL:[NSURL URLWithString:str]];
    kMeWEAKSELF
    webVC.authorizeBlock = ^{
        [weakSelf checkRelationId];
    };
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark- CollectionView Delegate And DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_type == 0) {
        return 6;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_type == 0) {
        if (section == 0 || section == 2 || section == 3 || section == 4) {
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
        if (indexPath.section == 5) {
            MECoupleModel *model = self.refresh.arrData[indexPath.row];
            MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        MECoupleModel *model = self.refresh.arrData[indexPath.row];
        MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithProductrId:model.num_iid couponId:kMeUnNilStr(model.coupon_id) couponurl:kMeUnNilStr(model.coupon_share_url) Model:model];
        [self.navigationController pushViewController:vc animated:YES];
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
            return CGSizeMake(SCREEN_WIDTH, [MEFourHomeHeaderView getViewHeight]);
        }else if (section == 2) {
            if(_spreebugmodel){
                return CGSizeMake(SCREEN_WIDTH, kMEFourHomeTopHeaderViewHeight);
            }else{
                return CGSizeMake(0, 0.1);;
            }
        }else if (section == 3) {
            return CGSizeMake(SCREEN_WIDTH, [MEFourHomeGoodGoodFilterHeaderView getCellHeight]);
        }else if (section == 4) {
            CGFloat height = 51;
            if (_arrHot.count > 0) {
                height += 135 * _arrHot.count;
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
                [header setUIWithModel:_homeModel stroeModel:_stroeModel];
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
            }else if (indexPath.section == 2) {
                MEFourHomeTopHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeTopHeaderView class]) forIndexPath:indexPath];
                if(_spreebugmodel){
                    [header setUiWithModel:_spreebugmodel];
                }
                headerView = header;
            }else if (indexPath.section == 3) {
                MEFourHomeGoodGoodFilterHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeGoodGoodFilterHeaderView class]) forIndexPath:indexPath];
                headerView = header;
            }else if (indexPath.section == 4) {
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
        if (section != 5) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    return UIEdgeInsetsMake(kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin, kMEGoodsMargin);
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
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeTopHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeTopHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeGoodGoodFilterHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeGoodGoodFilterHeaderView class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEFourHomeGoodGoodMainHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEFourHomeGoodGoodMainHeaderView class])];
        
        _collectionView.backgroundColor = kMEf5f4f4;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonTaobaokeGetDgMaterialOptional)];
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

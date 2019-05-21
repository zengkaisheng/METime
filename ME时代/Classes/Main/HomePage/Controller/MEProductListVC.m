//
//  MEProductListVC.m
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEProductListVC.h"
#import "MEProductCell.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEGoodModel.h"
#import "MEServiceDetailsVC.h"

#define kMEProductListHeaderViewHeight (115 * kMeFrameScaleY())

@interface MEProductListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    MEGoodsTypeNetStyle _type;
}

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIImageView         *imgMain;

@end

@implementation MEProductListVC

- (instancetype)initWithType:(MEGoodsTypeNetStyle)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品列表";
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    if(_type == MEGoodsTypeNetCommendStyle){
        return @{@"pageSize":@(100),@"uid":kMeUnNilStr(kCurrentUser.uid)};
    }
    return @{@"type":@(_type),@"pageSize":@(100),@"uid":kMeUnNilStr(kCurrentUser.uid)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *arr = [MEGoodModel mj_objectArrayWithKeyValuesArray:data];
    NSMutableArray *arrNeed = [MEGoodModel mj_objectArrayWithKeyValuesArray:data];
    for (NSInteger i=0; i<arr.count; i++) {
        MEGoodModel *model = arr[i];
        if(model.product_id == 74){
            [arrNeed removeObjectAtIndex:i];
            break;
        }
    }
    [self.refresh.arrData addObjectsFromArray:arrNeed];
}


#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_type == MEGoodsTypeNetServiceStyle){
        MEGoodModel *model = self.refresh.arrData [indexPath.row];
        MEServiceDetailsVC *details = [[MEServiceDetailsVC alloc]initWithId:model.product_id];
        [self.navigationController pushViewController:details animated:YES];
    }else{
        MEGoodModel *model = self.refresh.arrData [indexPath.row];
        METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
        [self.navigationController pushViewController:details animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEProductCell class]) forIndexPath:indexPath];
    MEGoodModel *model = self.refresh.arrData[indexPath.row];
    if(_type == MEGoodsTypeNetServiceStyle){
        [cell setServiceUIWithModel:model];
    }else{
        [cell setUIWithModel:model];
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMEProductCellWdith, kMEProductCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEMargin*2, kMEMargin*2, kMEMargin*2, kMEMargin*2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (kind == UICollectionElementKindSectionHeader){//处理头视图
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMBannerView" forIndexPath:indexPath];
//        [headerView addSubview:self.imgMain];
//        return headerView;
//    }
//    else{
//        return nil;
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(SCREEN_WIDTH, kMEProductListHeaderViewHeight);
//}

#pragma mark - Getting And Setting

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEProductCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"WMBannerView"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;

    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonGoodsGetGoodsList)];
        _refresh.delegate = self;
        _refresh.numOfsize = @(100);
        kMeWEAKSELF
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            kMeSTRONGSELF
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = strongSelf->_type == MEGoodsTypeNetServiceStyle?@"没有服务":@"没有产品";
        }];
    }
    return _refresh;
}

- (UIImageView *)imgMain{
    if(!_imgMain){
        _imgMain = [[UIImageView alloc]init];
        _imgMain.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEProductListHeaderViewHeight);
        _imgMain.contentMode = UIViewContentModeScaleAspectFill;
        _imgMain.clipsToBounds = YES;
        [_imgMain sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kImgPlaceholder];
    }
    return _imgMain;
}

@end

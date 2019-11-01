//
//  MELianTongListVC.m
//  志愿星
//
//  Created by gao lei on 2019/9/2.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MELianTongListVC.h"
#import "MELianTongListCell.h"
#import "MEGoodModel.h"
#import "METhridProductDetailsVC.h"

#import "MEFiveHomeNavView.h"
#import "MEFiveCategoryView.h"

@interface MELianTongListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;

@end

@implementation MELianTongListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联通话费兑换区";
    self.view.backgroundColor = kMEf5f4f4;
    self.navBarHidden = self.isHome;
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
}

- (NSDictionary *)requestParameter{
    return @{@"type":@"17",@"uid":kMeUnNilStr(kCurrentUser.uid)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEGoodModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark- CollectionView Delegate And DataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodModel *model = self.refresh.arrData [indexPath.row];
    METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
    details.isLianTong = YES;
    [self.navigationController pushViewController:details animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MELianTongListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MELianTongListCell class]) forIndexPath:indexPath];
    MEGoodModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMELianTongListCellWdith, kMELianTongListCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEMargin, kMEMargin+2, kMEMargin, kMEMargin+2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMEMargin;
}

#pragma mark - Getting And Setting
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGRect frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight);
        if (self.isHome) {
            frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeTabBarHeight-kMEFiveHomeNavViewHeight-kMEFiveCategoryViewHeight);
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"kMEf5f4f4"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MELianTongListCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MELianTongListCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonFindGoods)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有商品";
        }];
    }
    return _refresh;
}

@end

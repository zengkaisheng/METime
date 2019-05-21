//
//  MEProductGitfListVC.m
//  ME时代
//
//  Created by hank on 2018/12/20.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEProductGitfListVC.h"
#import "MEProductCell.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEGoodModel.h"
#import "MEServiceDetailsVC.h"

#define kMEProductListHeaderViewHeight (115 * kMeFrameScaleY())

@interface MEProductGitfListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
 
}

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;


@end

@implementation MEProductGitfListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼物列表";
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"product_type":@"6",@"uid":kMeUnNilStr(kCurrentUser.uid)};
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
    details.isGift = YES;
    [self.navigationController pushViewController:details animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEProductCell class]) forIndexPath:indexPath];
    MEGoodModel *model = self.refresh.arrData[indexPath.row];
    [cell setUIWithModel:model];
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


#pragma mark - Getting And Setting

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEProductCell class])];
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
            failView.lblOfNodata.text = @"没有礼物";
        }];
    }
    return _refresh;
}


@end

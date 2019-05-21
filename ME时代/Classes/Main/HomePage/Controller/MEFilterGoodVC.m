//
//  MEFilterGoodVC.m
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEFilterGoodVC.h"
#import "MEProductCell.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MEGoodModel.h"
#import "MEFilterGoodView.h"

@interface MEFilterGoodVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate,FilterSelectViewDelegate>{
    NSString *_category_id;
    NSString *_other;
    NSString *_goods_price;
    NSString *_title;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MEFilterGoodView *filterView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEFilterGoodVC

- (instancetype)initWithcategory_id:(NSString *)category_id title:(NSString *)title{
    if(self = [super init]){
        _category_id = category_id;
        _title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title;
    _other = @"";
    _goods_price = @"";
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.filterView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"category_id":kMeUnNilStr(_category_id),
             @"other":kMeUnNilStr(_other),
             @"goods_price":kMeUnNilStr(_goods_price)
             ,@"uid":kMeUnNilStr(kCurrentUser.uid)
             };
}

- (void)handleResponse:(id)data{
//    _filterView.canSelect = YES;
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
//    [self.refresh.arrData addObjectsFromArray:[MEGoodModel mj_objectArrayWithKeyValuesArray:data]];
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

- (void)failureResponse:(NSError *)error{
//    _filterView.canSelect = YES;
}

#pragma mark - FilterSelectViewDelegate

- (void)selectTopButton:(MEFilterGoodView *)selectView withIndex:(NSInteger)index withButtonType:(ButtonClickType )type{
//    selectView.canSelect = NO;
    switch (index) {
        case 0:{
            NSLog(@"全部");
            _goods_price = @"";
            _other = @"";
            [self.refresh reload];
        }
            break;
        case 1:{
            NSLog(@"推荐");
            _goods_price = @"";
            _other = @"is_recommend";
            [self.refresh reload];
        }
            break;
        case 2:{
            NSLog(@"新品");
            _goods_price = @"";
            _other = @"is_new";
            [self.refresh reload];
        }
            break;
        case 3:{
            _other = @"";
            switch (type) {
                case ButtonClickTypeNormal:{
                    _goods_price = @"";
                    NSLog(@"正常价格");
                }
                    break;
                case ButtonClickTypeUp:{
                    NSLog(@"上价格升序排列");
                    _goods_price = @"ASC";
                }
                    break;
                case ButtonClickTypeDown:{
                    NSLog(@"下价格降序排列");
                    _goods_price = @"DESC";
                }
                    break;
                default:
                    break;
            }
            [self.refresh reload];
        }
            break;
        default:
            break;
    }
}

#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEGoodModel *model = self.refresh.arrData [indexPath.row];
    METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:model.product_id];
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kMEFilterGoodViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEFilterGoodViewHeight-(self.isHome?kMeTabBarHeight:0)) collectionViewLayout:layout];
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
        _refresh.showMaskView = YES;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有产品";
        }];
    }
    return _refresh;
}

- (MEFilterGoodView *)filterView{
    if(!_filterView){
        _filterView = [[MEFilterGoodView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, kMEFilterGoodViewHeight)];
        _filterView.delegate = self;
    }
    return _filterView;
}

@end

//
//  MEPinduoduoCouponSearchDataVC.m
//  ME时代
//
//  Created by hank on 2019/1/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEPinduoduoCouponSearchDataVC.h"
#import "MECoupleMailCell.h"
#import "MEPinduoduoCoupleModel.h"
#import "MECoupleMailDetalVC.h"

@interface MEPinduoduoCouponSearchDataVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    NSString *_queryStr;
}

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;

@end

@implementation MEPinduoduoCouponSearchDataVC

- (instancetype)initWithQuery:(NSString *)query{
    if(self = [super init]){
        _queryStr = query;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithHexString:@"eeeeee"];
    self.title = _queryStr;
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
    // Do any additional setup after loading the view.
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"keyword":kMeUnNilStr(_queryStr)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEPinduoduoCoupleModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
    MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECoupleMailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class]) forIndexPath:indexPath];
    MEPinduoduoCoupleModel *model = self.refresh.arrData[indexPath.row];
    [cell setpinduoduoUIWithModel:model];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECoupleMailCellWdith, kMECoupleMailCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMEMargin, 0, kMEMargin, 0);
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, kMeNavBarHeight, SCREEN_WIDTH-20, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECoupleMailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECoupleMailCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonduoduokeGetgetGoodsList)];
        _refresh.isPinduoduoCoupleMater = YES;
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有优惠产品";
        }];
    }
    return _refresh;
}



@end

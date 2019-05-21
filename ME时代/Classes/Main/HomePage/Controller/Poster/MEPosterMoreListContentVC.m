//
//  MEPosterMoreListContentVC.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEPosterMoreListContentVC.h"
#import "MEMyPosterContentCell.h"
#import "MEPosterModel.h"
#import "MEPosterMoreListVC.h"
#import "MECreatePosterVC.h"

@interface MEPosterMoreListContentVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    MEPosterModel *_model;
    CGFloat _cellHeight;
    BOOL _isNew;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIView         *headerView;
@end


@implementation MEPosterMoreListContentVC

- (instancetype)initWithModel:(MEPosterModel *)Model isNew:(BOOL)isNew{
    if(self = [super init]){
        _model = Model;
        _isNew = isNew;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellHeight = [MEMyPosterContentCell getCellHeight];
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
}

- (NSDictionary *)requestParameter{
    if(_isNew){
        return @{@"class_id":@(_model.idField),@"is_new":@(1)};
    }else{
        return @{@"class_id":@(_model.idField),@"is_share":@(1)};
    }
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEPosterChildrenModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEPosterChildrenModel *model = self.refresh.arrData[indexPath.row];
    MECreatePosterVC *vc = [[MECreatePosterVC alloc]initWithModel:model];
    MEPosterMoreListVC *homeVC = [MECommonTool getVCWithClassWtihClassName:[MEPosterMoreListVC class] targetResponderView:self];
    if(homeVC){
        [homeVC.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEMyPosterContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEMyPosterContentCell class]) forIndexPath:indexPath];
    MEPosterChildrenModel *model = self.refresh.arrData[indexPath.row];
    [cell setiWitMorehModel:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMEMyPosterContentCellWdith, _cellHeight);
}

//section的上下左右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(34*kMeFrameScaleX(), k10Margin, 0, k10Margin);
}

//cell上下之间
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 35 *kMeFrameScaleX();
}

//cell左右之间
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return k10Margin-2;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){//处理头视图
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WMBannerView" forIndexPath:indexPath];
        [headerView addSubview:self.headerView];
        return headerView;
    }
    else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 92);
}

#pragma mark - Getting And Setting

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kCategoryViewHeight)  collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEMyPosterContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEMyPosterContentCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"WMBannerView"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonFindPostersClass)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.backgroundColor = [UIColor whiteColor];
            failView.lblOfNodata.text = @"没有海报";
        }];
    }
    return _refresh;
}

- (UIView *)headerView{
    if(!_headerView){
        CGFloat vHeight = 92;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, vHeight)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 81)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, SCREEN_WIDTH-20, 22)];
        lbl.font = [UIFont systemFontOfSize:18];
        lbl.textColor = [UIColor colorWithHexString:@"333333"];
        lbl.text = kMeUnNilStr(_model.classify_name);
        [view addSubview:lbl];
        
        UILabel *lbls = [[UILabel alloc]initWithFrame:CGRectMake(10, lbl.bottom, SCREEN_WIDTH-20, 15)];
        lbls.font = [UIFont systemFontOfSize:12];
        lbls.textColor = [UIColor colorWithHexString:@"999999"];
        lbls.text = kMeUnNilStr(_model.desc);
        [view addSubview:lbl];
        [view addSubview:lbls];
        [_headerView addSubview:view];
    }
    return _headerView;
}

@end

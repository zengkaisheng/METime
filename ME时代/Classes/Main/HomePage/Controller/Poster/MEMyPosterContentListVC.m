//
//  MEMyPosterContentListVC.m
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMyPosterContentListVC.h"
#import "MEMyPosterContentCell.h"
#import "MEPosterModel.h"
#import "MECreatePosterVC.h"
#import "MEPosterActiveVC.h"
#import "MEActivePosterModel.h"

@interface MEMyPosterContentListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,RefreshToolDelegate>{
    CGFloat _cellHeight;
    BOOL _isActive;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool         *refresh;
@property (nonatomic, strong) UIView         *headerView;
@end

@implementation MEMyPosterContentListVC

- (instancetype)initWithActice{
    if(self = [super init]){
        _isActive = YES;
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
    if(_isActive){
        return @{@"token":kMeUnNilStr(kCurrentUser.token)};
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    if(_isActive){
        [self.refresh.arrData addObjectsFromArray:[MEActivePosterModel mj_objectArrayWithKeyValuesArray:data]];
    }else{
        [self.refresh.arrData addObjectsFromArray:[MEPosterChildrenModel mj_objectArrayWithKeyValuesArray:data]];
    }
}

#pragma mark- CollectionView Delegate And DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_isActive){
        MEActivePosterModel *model = self.refresh.arrData[indexPath.row];
        MEPosterActiveVC *vc = [[MEPosterActiveVC alloc]initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MEPosterChildrenModel *model = self.refresh.arrData[indexPath.row];
        MECreatePosterVC *vc = [[MECreatePosterVC alloc]initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEMyPosterContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEMyPosterContentCell class]) forIndexPath:indexPath];
    if(!_isActive){
         MEPosterChildrenModel *model = self.refresh.arrData[indexPath.row];
        kMeWEAKSELF
        cell.delBlock = ^{
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除吗?"];
            [aler addButtonWithTitle:@"确定" block:^{
                NSString *strId = @(model.idField).description;
                [MEPublicNetWorkTool postDelSharePosterWithId:kMeUnNilStr(strId) SuccessBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    [strongSelf.refresh reload];
                } failure:nil];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
            
        };
        [cell setiWithModel:model];
    }else{
        MEActivePosterModel *model = self.refresh.arrData[indexPath.row];
        [cell setiActiveWithModel:model];
    }
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
    return k10Margin*5 *kMeFrameScaleX();
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
    return CGSizeMake(SCREEN_WIDTH, 64);
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
        NSString *str = MEIPcommonGetSharePoster;
        if(_isActive){
            str = MEIPadminGetActivePoster;
        }
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(str)];
        _refresh.delegate = self;
        _refresh.isDataInside = YES;
        kMeWEAKSELF
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            kMeSTRONGSELF
            failView.backgroundColor = [UIColor whiteColor];
            if(strongSelf->_isActive){
                failView.lblOfNodata.text = @"没有活动";
            }else{
               failView.lblOfNodata.text = @"没有分享";
            }
        }];
    }
    return _refresh;
}

- (UIView *)headerView{
    if(!_headerView){
        CGFloat vHeight = 64;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, vHeight)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH-24, vHeight-20)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lbls = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-24-20, vHeight-20)];
        lbls.font = [UIFont systemFontOfSize:12];
        lbls.textColor = [UIColor colorWithHexString:@"5b5b5b"];
        if(_isActive){
            lbls.text = @"这里是活动海报,每一份海报都带着一份惊喜";
        }else{
            lbls.text = @"这里有您生成过的所有问候海报,可以重复分享哦";
        }
        [view addSubview:lbls];
        [_headerView addSubview:view];
    }
    return _headerView;
}

@end

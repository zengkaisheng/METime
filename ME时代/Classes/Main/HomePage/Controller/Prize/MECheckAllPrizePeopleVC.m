//
//  MECheckAllPrizePeopleVC.m
//  ME时代
//
//  Created by gao lei on 2019/6/20.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECheckAllPrizePeopleVC.h"
#import "MEPrizeDetailsModel.h"

@interface MECheckAllPrizePeopleVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RefreshToolDelegate>{
    NSInteger _type;
    NSInteger _count;
    NSInteger _activityId;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLRefreshTool    *refresh;
@property (nonatomic, strong) UILabel *countLbl;

@end

@implementation MECheckAllPrizePeopleVC

- (instancetype)initWithType:(NSInteger)type count:(NSInteger)count activityId:(NSInteger)activityId{
    if (self = [super init]) {
        _type = type;
        _count = count;
        _activityId = activityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMEf5f4f4;
    self.title = @"签到活动";
    
    [self.view addSubview:self.countLbl];
    switch (_type) {
        case 1://多少人参与
            self.countLbl.text = [NSString stringWithFormat:@"共有%ld人参与",(long)_count];
            break;
        case 2://多少人中奖
            self.countLbl.text = [NSString stringWithFormat:@"共有%ld位幸运儿",(long)_count];
            break;
        case 3://多少人被邀请
            self.countLbl.text = [NSString stringWithFormat:@"共邀请%ld好友参与",(long)_count];
            break;
        default:
            break;
    }
    [self.view addSubview:self.collectionView];
    [self.refresh addRefreshView];
}

- (void)requestNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postPrizeJoinUserCountWithActivityId:[NSString stringWithFormat:@"%ld",(long)_activityId] lookType:[NSString stringWithFormat:@"%ld",(long)_type] successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_count = [responseObject.data integerValue];
        strongSelf->_countLbl.text = [NSString stringWithFormat:@"共有%ld人参与",(long)strongSelf->_count];
//        if (strongSelf.reloadBlock) {
//            strongSelf.reloadBlock();
//        }
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - RefreshToolDelegate
- (NSDictionary *)requestParameter{
    if(self.refresh.pageIndex == 1){
        [self requestNetWork];
    }
    return @{@"token":kMeUnNilStr(kCurrentUser.token),@"activity_id":@(_activityId),@"look_type":@(_type)};
}

- (void)handleResponse:(id)data{
    if(![data isKindOfClass:[NSArray class]]){
        return;
    }
    [self.refresh.arrData addObjectsFromArray:[MEPrizeLogModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark- CollectionView Delegate And DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.refresh.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = kMEf5f4f4;
    MEPrizeLogModel *model = self.refresh.arrData[indexPath.row];
    for (id obj in cell.contentView.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *headerImg = (UIImageView *)obj;
            if (headerImg.tag == 888) {
                [headerImg removeFromSuperview];
            }
        }
    }
    
    UIImageView *headerPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    kSDLoadImg(headerPic, model.header_pic);
    headerPic.backgroundColor = [UIColor colorWithHexString:@"#818181"];
    headerPic.layer.cornerRadius = 29/2.0;;
    headerPic.layer.masksToBounds = YES;
    headerPic.tag = 888;
    [cell.contentView addSubview:headerPic];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(29, 29);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(4.5, 2.5, 4.5, 2.5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.5;
}

#pragma mark - Getting And Setting
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(18, kMeNavBarHeight+74, SCREEN_WIDTH-36, SCREEN_HEIGHT-kMeNavBarHeight-74) collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = kMEf5f4f4;
    }
    return _collectionView;
}

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPCommonPrizeJoinUserList)];
        _refresh.delegate = self;
        _refresh.showMaskView = YES;
        _refresh.isDataInside = YES;
        _refresh.numOfsize = @(50);
    }
    return _refresh;
}

- (UILabel *)countLbl {
    if (!_countLbl) {
        _countLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+31, SCREEN_WIDTH, 17)];
        _countLbl.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
        _countLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _countLbl;
}

@end

//
//  MECommondCouponCell.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MECommondCouponCell.h"
#import "MECommondCouponContentCell.h"
#import "MEPinduoduoCoupleModel.h"
#import "MECoupleMailDetalVC.h"
#import "METhridHomeVC.h"

const static CGFloat kMargin = 10;
@interface MECommondCouponCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrModel;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cosnCollectionHeight;

@end

@implementation MECommondCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSomeThing];
    // Initialization code
}

- (void)initSomeThing{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _cosnCollectionHeight.constant = 135 * kMeFrameScaleX();
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MECommondCouponContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MECommondCouponContentCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEPinduoduoCoupleModel *model = self.arrModel[indexPath.row];
    MECoupleMailDetalVC *vc = [[MECoupleMailDetalVC alloc]initWithPinduoudoModel:model];
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homeVC){
        [homeVC.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MECommondCouponContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MECommondCouponContentCell class]) forIndexPath:indexPath];
    MEPinduoduoCoupleModel *model = self.arrModel[indexPath.row];
    [cell setUIWithModel:model];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMECommondCouponContentCellWdith* kMeFrameScaleX(), kMECommondCouponContentCellHeight* kMeFrameScaleX());
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kMargin, 0, kMargin);
}


- (void)setUIWithArr:(NSArray *)arrModel imgUrl:(NSString *)imgUrl{
    kSDLoadImg(_imgPic, kMeUnNilStr(imgUrl));
    _arrModel = arrModel;
    [self.collectionView reloadData];
}

+ (CGFloat)getCellHeight{
    return 255 * kMeFrameScaleX();
}

@end

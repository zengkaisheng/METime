//
//  MEAiCustomerTagVC.m
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAiCustomerTagVC.h"
#import "MEAiTagCell.h"
#import "MEAiCustomerTagModel.h"
#import "MEAiTagCollectionReusableView.h"

@interface MEAiCustomerTagVC()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSString *_uid;
    NSMutableArray *_arrdata;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrSelectId;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MEAiCustomerTagVC

- (instancetype)initWithArrId:(NSArray *)arrId uid:(NSString*)uid{
    if(self = [super init]){
        _uid = uid;
        [self.arrSelectId addObjectsFromArray:arrId];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标签";
    _arrdata = [NSMutableArray array];
    kMeWEAKSELF
    [MEPublicNetWorkTool postgetCustomerGetLabelWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if([responseObject.data isKindOfClass:[NSArray class]]){
            [strongSelf->_arrdata addObjectsFromArray:[MEAiCustomerTagModel mj_objectArrayWithKeyValuesArray:responseObject.data]];
        }
        [strongSelf->_arrdata enumerateObjectsUsingBlock:^(MEAiCustomerTagModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [kMeUnArr(obj.children) enumerateObjectsUsingBlock:^(MEAiCustomerTagchildrenModel *sModel, NSUInteger idx, BOOL * _Nonnull stop) {
                for (NSInteger i = 0; i<kMeUnArr(strongSelf->_arrSelectId).count; i++) {
                    NSInteger num = [strongSelf->_arrSelectId[i] integerValue];
                    if(sModel.idField == num){
                        sModel.isSelect = YES;
                    }
                }
//                [kMeUnArr(strongSelf->_arrSelectId) enumerateObjectsUsingBlock:^(NSNumber sModelId, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if([sModel.idField isEqualToString:kMeUnNilStr(sModelId)]){
//                        sModel.isSelect = YES;
//                    }
//                }];
            }];
        }];
        [strongSelf.view addSubview:strongSelf.collectionView];
        [strongSelf.collectionView reloadData];
        strongSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:strongSelf.btnRight];

    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)saveAction{
    __block NSMutableArray *_arrid = [NSMutableArray array];
    [_arrdata enumerateObjectsUsingBlock:^(MEAiCustomerTagModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [kMeUnArr(obj.children) enumerateObjectsUsingBlock:^(MEAiCustomerTagchildrenModel *sModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if(sModel.isSelect){
                [_arrid addObject:@(sModel.idField)];
            }
        }];
    }];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_arrid
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    kMeWEAKSELF
    [MEPublicNetWorkTool postgetCustomerGetLabelWithLabel:jsonString uid:_uid SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.finishBlock);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id object) {
        
    }];
}

#pragma mark- CollectionView Delegate And DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _arrdata.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MEAiCustomerTagModel *model = _arrdata[indexPath.section];
    MEAiCustomerTagchildrenModel *childModel = model.children[indexPath.row];
    childModel.isSelect = !childModel.isSelect;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    MEAiCustomerTagModel *model = _arrdata[section];
    return model.children.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MEAiCustomerTagModel *model = _arrdata[indexPath.section];
    MEAiCustomerTagchildrenModel *childModel = model.children[indexPath.row];
    MEAiTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEAiTagCell class]) forIndexPath:indexPath];
    [cell setUIWithModel:childModel];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MEAiCustomerTagModel *model = _arrdata[indexPath.section];
        MEAiTagCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEAiTagCollectionReusableView class]) forIndexPath:indexPath];
        reusableView.lblTitle.text = kMeUnNilStr(model.title);
        return reusableView;
    }else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kMEAiTagCellW, kMEAiTagCellH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, k15Margin, k15Margin, k15Margin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return k15Margin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return k15Margin;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, kMEAiTagCollectionReusableViewHeight);
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight,SCREEN_WIDTH , SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAiTagCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEAiTagCell class])];
        [_collectionView  registerNib:[UINib nibWithNibName:NSStringFromClass([MEAiTagCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MEAiTagCollectionReusableView class])];
        _collectionView.delegate =self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)arrSelectId{
    if(!_arrSelectId){
        _arrSelectId = [NSMutableArray array];
    }
    return _arrSelectId;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setTitle:@"保存" forState:UIControlStateNormal];
        [_btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
        _btnRight.frame = CGRectMake(-20, 0, 30, 25);
        _btnRight.titleLabel.font = kMeFont(14);
        [_btnRight addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end

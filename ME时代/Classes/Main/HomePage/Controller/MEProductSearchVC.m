//
//  MEProductSearchVC.m
//  ME时代
//
//  Created by hank on 2018/10/24.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEProductSearchVC.h"
#import "MEProductCell.h"
#import "MEGoodModel.h"
//#import "MEProductDetailsVC.h"
#import "METhridProductDetailsVC.h"
#import "MESearchHistoryView.h"
#import "MESearchHistoryModel.h"

@interface MEProductSearchVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,RefreshToolDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *tfSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong , nonatomic) ZLRefreshTool *refresh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (strong , nonatomic) MESearchHistoryView *historyView;

@end


#define kMeSearchHistory @"kMeSearchHistory"

@implementation MEProductSearchVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSomeThing];
}

- (void)initSomeThing {
    self.navBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    _consTopMargin.constant = kMeStatusBarHeight;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEProductCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEProductCell class])];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"WMBannerView"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    self.refresh.delegate = self;
    if([MESearchHistoryView hasHIstory]){
        [self.historyView reloadData];
    }
    [self.tfSearch becomeFirstResponder];
}

#pragma mark - Action

- (IBAction)cancelAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - RefreshToolDelegate

- (NSDictionary *)requestParameter{
    return @{@"keyword":kMeUnNilStr(_tfSearch.text),@"type":@"0",@"other":@"",@"uid":kMeUnNilStr(kCurrentUser.uid)};
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
//    [self.refresh.arrData addObjectsFromArray:[MEGoodModel mj_objectArrayWithKeyValuesArray:data]];
}

#pragma mark - UITextViewDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.collectionView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(!kMeUnNilStr(textField.text).length){
        kMeAlter(@"", @"请输入搜索关键字");
        return NO;
    }
    
    [self.view endEditing:YES];
    NSArray *arr = [MESearchHistoryModel arrSearchHistory];
    NSMutableArray *arrMutable = [NSMutableArray arrayWithArray:arr];
    [arrMutable insertObject:kMeUnNilStr(textField.text) atIndex:0];
    if(arrMutable.count >3){
        [arrMutable removeLastObject];
    }
    [MESearchHistoryModel saveSearchHistory:arrMutable];
    [_collectionView addSubview:self.historyView];
    [self.refresh reload];
    CGFloat vHeight = [MESearchHistoryView getViewHeight];
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(vHeight, 0, 0, 0);
    _collectionView.contentInset = UIEdgeInsetsMake(vHeight, 0, 0, 0);
    [self.historyView reloadData];
    
    return YES;
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
    [cell setUIWithModel:model WithKey:_tfSearch.text];
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
 
#pragma mark - Setter

- (ZLRefreshTool *)refresh{
    if(!_refresh){
        _refresh = [[ZLRefreshTool alloc]initWithContentView:self.collectionView url:kGetApiWithUrl(MEIPcommonFindGoods)];
        _refresh.isDataInside = YES;
        _refresh.showFailView = NO;
        [_refresh addRefreshView];
        [_refresh setBlockEditFailVIew:^(ZLFailLoadView *failView) {
            failView.lblOfNodata.text = @"未搜索到您需要的产品";
        }];
    }
    return _refresh;
}

- (MESearchHistoryView *)historyView{
    if(!_historyView){
        CGFloat vHeight = [MESearchHistoryView getViewHeight];
        _historyView = [[MESearchHistoryView alloc]initWithFrame:CGRectMake(0, - vHeight, SCREEN_WIDTH, vHeight)];
        kMeWEAKSELF
        _historyView.delBlock = ^{
            kMeSTRONGSELF
            [MESearchHistoryModel saveSearchHistory:@[]];
            [strongSelf.historyView removeFromSuperview];
            strongSelf.historyView =nil;
            strongSelf->_collectionView.scrollIndicatorInsets = UIEdgeInsetsZero;
            strongSelf->_collectionView.contentInset = UIEdgeInsetsZero;
        };
        _historyView.selectBlock = ^(NSString *str) {
            kMeSTRONGSELF
            strongSelf->_tfSearch.text = str;
            [strongSelf.view endEditing:YES];
            [strongSelf.refresh reload];
        };
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(vHeight, 0, 0, 0);
        _collectionView.contentInset = UIEdgeInsetsMake(vHeight, 0, 0, 0);
        [_collectionView addSubview:self.historyView];
    }
    return _historyView;
}


@end

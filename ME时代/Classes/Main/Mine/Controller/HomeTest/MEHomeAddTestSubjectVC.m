//
//  MEHomeAddTestSubjectVC.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeAddTestSubjectVC.h"
#import "MEHomeAddTestDecModel.h"
#import "MEHomeAddTestSubjectImageCell.h"
#import "MEHomeAddTestResultVC.h"
#import "MENavigationVC.h"
#import "MEHomeTestAddContentVC.h"
#import "MEHomeAddTestSubjectContentCell.h"
#import <TZImagePickerController.h>

@interface MEHomeAddTestSubjectVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic, strong) MEHomeAddTestDecModel *model;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MEHomeAddTestSubjectVC

- (instancetype)initWithModel:(MEHomeAddTestDecModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MENavigationVC *nav = (MENavigationVC *)self.navigationController;
    nav.canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    MENavigationVC *nav = (MENavigationVC *)self.navigationController;
    nav.canDragBack = YES;;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第1题";
    [self.view addSubview:self.collectionView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
}

- (void)pushAction{
    //题目类型 1图片 2文本
    if(_model.type == 1){
        kMeWEAKSELF
        __block BOOL isReturn = NO;
        [_model.questions enumerateObjectsUsingBlock:^(MEHomeAddTestDecContentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            kMeSTRONGSELF
            if(!kMeUnNilStr(obj.image).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先上传图片",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_a).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择A答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_b).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择B答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_c).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择C答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_d).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择D答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
        }];
        if(isReturn){
            return;
        }
    }else if(_model.type == 2){
        kMeWEAKSELF
        __block BOOL isReturn = NO;
        [_model.questions enumerateObjectsUsingBlock:^(MEHomeAddTestDecContentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            kMeSTRONGSELF
            if(!kMeUnNilStr(obj.content).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先填写题目",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.option1).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先填写问题一",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.option2).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先填写问题二",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.option3).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先填写问题三",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.option4).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先填写问题四",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_a).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择A答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_b).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择B答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_c).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择C答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
            if(!kMeUnNilStr(obj.score_d).length){
                [MEShowViewTool showMessage:[NSString stringWithFormat:@"第%@题请先选择D答案的分数",@(idx + 1)] view:strongSelf.view];
                isReturn = YES;
                *stop = YES;
            }
        }];
        if(isReturn){
            return;
        }
    }
    if(_type == MEHomeAddTestDecTypeeditVC || _type == MEHomeAddTestDecTypelplatVC){
        MEHomeAddTestResultVC *vc = [[MEHomeAddTestResultVC alloc]initWithModel:_model];
        vc.token = self.token;
        vc.type = _type;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [_model.answers removeAllObjects];
        CGFloat min = 0;
        CGFloat max = 0;
        if(_model.type == 1){
            for (MEHomeAddTestDecContentModel *imagMolde  in _model.questions) {
                NSArray *numbers = @[@([kMeUnNilStr(imagMolde.score_a) floatValue]),@([imagMolde.score_b floatValue]),@([imagMolde.score_c floatValue]),@([imagMolde.score_d floatValue])];
                numbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
                
                min+= [numbers[0] floatValue];
                max+= [[numbers lastObject] floatValue];
            }
            
        }else{
            for (MEHomeAddTestDecContentModel *contentMolde  in _model.questions) {
                NSArray *numbers = @[@([kMeUnNilStr(contentMolde.score_a) floatValue]),@([contentMolde.score_b floatValue]),@([contentMolde.score_c floatValue]),@([contentMolde.score_d floatValue])];
                numbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
                
                min+= [numbers[0] floatValue];
                max+= [[numbers lastObject] floatValue];
            }
        }
        
        CGFloat av = (max - min)/2;
        
        MEHomeAddTestDecResultModel *resultOne = [MEHomeAddTestDecResultModel new];
        resultOne.min = min;
        resultOne.max = min +av;
        [_model.answers addObject:resultOne];
        MEHomeAddTestDecResultModel *resultTwo = [MEHomeAddTestDecResultModel new];
        resultTwo.min = min +av+1;
        resultTwo.max = max;
        [_model.answers addObject:resultTwo];
        
        MEHomeAddTestResultVC *vc = [[MEHomeAddTestResultVC alloc]initWithModel:_model];
        vc.token = self.token;
        vc.type = _type;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return kMeUnArr(_model.questions).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_model.type == 1){
        MEHomeAddTestSubjectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEHomeAddTestSubjectImageCell class]) forIndexPath:indexPath];
        kMeWEAKSELF
        cell.forBlock = ^{
            kMeSTRONGSELF
            [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            strongSelf.title = [NSString stringWithFormat:@"第%@题",@(indexPath.item)];
        };
        cell.nextBlock = ^{
            kMeSTRONGSELF
            if(indexPath.item == strongSelf.model.questions.count-1){
                if(strongSelf->_type == MEHomeAddTestDecTypelplatVC){
                    [MEShowViewTool showMessage:@"没有下一题了" view:strongSelf.view];
                }else{
                    MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定添加一题?"];
                    [aler addButtonWithTitle:@"确定" block:^{
                        MEHomeAddTestDecContentModel *imagMolde = [MEHomeAddTestDecContentModel new];
                        imagMolde.type = 1;
                        [strongSelf.model.questions addObject:imagMolde];
                        [strongSelf.collectionView reloadData];
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                                strongSelf.title = [NSString stringWithFormat:@"第%@题",@(indexPath.item+2)];
                            });
                        });
                    }];
                    [aler addButtonWithTitle:@"取消"];
                    [aler show];
       
                }
   
            }else{
                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                strongSelf.title = [NSString stringWithFormat:@"第%@题",@(indexPath.item+2)];
            }
        };
        cell.addPhotoBlock = ^{
            kMeSTRONGSELF
            [strongSelf addPhotoWithIndex:indexPath.item];
        };
        MEHomeAddTestDecContentModel *imagMolde = _model.questions[indexPath.row];
        [cell setUIWithModel:imagMolde index:indexPath.item type:_type];
        return cell;
    }else{
        MEHomeAddTestSubjectContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MEHomeAddTestSubjectContentCell class]) forIndexPath:indexPath];
        kMeWEAKSELF
        cell.forBlock = ^{
            kMeSTRONGSELF
            [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            strongSelf.title = [NSString stringWithFormat:@"第%@题",@(indexPath.item)];
        };
        cell.nextBlock = ^{
            kMeSTRONGSELF
            if(indexPath.item == strongSelf.model.questions.count-1){
                if(strongSelf->_type == MEHomeAddTestDecTypelplatVC){
                    [MEShowViewTool showMessage:@"没有下一题了" view:strongSelf.view];
                }else{
                    MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定添加一题?"];
                    [aler addButtonWithTitle:@"确定" block:^{
                        MEHomeAddTestDecContentModel *contentMolde = [MEHomeAddTestDecContentModel new];
                        contentMolde.type = 2;
                        [strongSelf.model.questions addObject:contentMolde];
                        [strongSelf.collectionView reloadData];
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                                strongSelf.title = [NSString stringWithFormat:@"第%@题",@(indexPath.item+2)];
                            });
                        });
                    }];
                    [aler addButtonWithTitle:@"取消"];
                    [aler show];
                }
            }else{
                [strongSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                strongSelf.title = [NSString stringWithFormat:@"第%@题",@(indexPath.item+2)];
            }
        };
        cell.addTextBlock = ^{
            kMeSTRONGSELF
            [strongSelf addContentWithIndex:indexPath.item];
        };
        MEHomeAddTestDecContentModel *contentMolde = _model.questions[indexPath.row];
        [cell setUIWithModel:contentMolde index:indexPath.item type:_type];
        return cell;
    }

}

- (void)addPhotoWithIndex:(NSInteger)index{
    kMeWEAKSELF
    MEHomeAddTestDecContentModel *imagMolde = _model.questions[index];
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingVideo = NO;
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        kMeSTRONGSELF
        for (int i = 0; i < assets.count; i ++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                UIImage *image = photos[i];
                NSString *filename = [phAsset valueForKey:@"filename"];
                NSString *path = [MECommonTool getImagePath:image filename:filename];
                MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
                [MEPublicNetWorkTool postQiNiuUpFileWithToken:strongSelf->_token filePath:path successBlock:^(id object) {
                    NSLog(@"%@",object);
                    if([object isKindOfClass:[NSDictionary class]]){
                        NSString *key = kMeUnNilStr(object[@"key"]);
                        imagMolde.image = key;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        kMeSTRONGSELF
                        [strongSelf.collectionView reloadData];
                    });
                    [HUD hideAnimated:YES];
                } failure:^(id object) {
                    [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"图片上传失败"];
                }];
            }
        }
    }];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)addContentWithIndex:(NSInteger)index{
    MEHomeAddTestDecContentModel *contentMolde = _model.questions[index];
    MEHomeTestAddContentVC *vc = [[MEHomeTestAddContentVC alloc]init];
    vc.model = contentMolde;
    kMeWEAKSELF
    vc.block = ^(MEHomeAddTestDecContentModel *cmodel) {
        contentMolde.content = cmodel.content;
        contentMolde.option1 = cmodel.option1;
        contentMolde.option2 = cmodel.option2;
        contentMolde.option3 = cmodel.option3;
        contentMolde.option4 = cmodel.option4;
        kMeSTRONGSELF
        [strongSelf.collectionView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeAddTestSubjectImageCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEHomeAddTestSubjectImageCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeAddTestSubjectContentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MEHomeAddTestSubjectContentCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.alwaysBounceVertical = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(-20, 0, 30, 25);
        [_btnRight setTitle:@"发布" forState:UIControlStateNormal];
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight setTitleColor:kMEPink forState:UIControlStateNormal];
        [_btnRight addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

@end

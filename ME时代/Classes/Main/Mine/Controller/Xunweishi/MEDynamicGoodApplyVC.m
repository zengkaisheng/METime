//
//  MEDynamicGoodApplyVC.m
//  SunSum
//
//  Created by hank on 2019/3/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEDynamicGoodApplyVC.h"
#import "MEDynamicGoodApplyCell.h"
#import "MEDynamicGoodApplyModel.h"
#import <TZImagePickerController.h>
#import "YBImageBrowser.h"
#import "MEDynamicGoodApplyNineGridCell.h"
#import "MEBynamicPublishGridModel.h"
#import "MEBynamicPublishGridContentView.h"
#import "MEDynamicGoodApplyStatusVC.h"

@interface MEDynamicGoodApplyVC ()<TZImagePickerControllerDelegate,YBImageBrowserDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentIndex;
    NSMutableArray *_arrImage;
    NSString *_token;
    BOOL _isError;
    BOOL _isShow;
}
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) MEDynamicGoodApplyNineGridCell *gridCell;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) UIButton *btnRight;

@end

@implementation MEDynamicGoodApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kMeWEAKSELF
    if(_parModel){
        self.title = @"详情";
        _isShow = YES;
    }else{
        self.title = @"寻味师";
        _isShow = NO;
        _isError = NO;
        MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
        [MEPublicNetWorkTool postgetQiuNiuTokkenWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            [HUD hideAnimated:YES];
            kMeSTRONGSELF
            strongSelf->_token = responseObject.data[@"token"];
        } failure:^(id object) {
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
        _currentIndex = 0;
        _arrImage = [NSMutableArray array];
        _parModel = [MEDynamicGoodApplyModel getModel];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    }
    [self.view addSubview:self.tableView];
}

- (void)checkList:(UIButton *)btn{
    MEDynamicGoodApplyStatusVC *vc = [[MEDynamicGoodApplyStatusVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitAction:(UIButton *)btn{
    [self.view endEditing:YES];
    if(!kMeUnNilStr(self.parModel.true_name).length){
        [MEShowViewTool showMessage:@"名字不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.phone).length){
        [MEShowViewTool showMessage:@"手机号不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.goods_name).length){
        [MEShowViewTool showMessage:@"产品名称不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.price).length){
        [MEShowViewTool showMessage:@"产品价格不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.parModel.goods_detail).length){
        [MEShowViewTool showMessage:@"产品描述不能为空" view:kMeCurrentWindow];
        return;
    }
    if(self.parModel.images.count == 1){
        [MEShowViewTool showMessage:@"产品详情图不能为空" view:kMeCurrentWindow];
        return;
    }
    
    _isError = NO;
    [_arrImage removeAllObjects];
    
    kMeWEAKSELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    MBProgressHUD *hub =  [MEPublicNetWorkTool commitWithHUD:@"提交中"];
    dispatch_group_async(group, queue, ^{
        kMeSTRONGSELF
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        for (MEBynamicPublishGridModel *model in self.parModel.images) {
            if(!model.isAdd){
                [MEPublicNetWorkTool postQiNiuUpFileWithToken:strongSelf->_token filePath:model.filePath successBlock:^(id object) {
                    NSLog(@"%@",object);
                    if([object isKindOfClass:[NSDictionary class]]){
                        [strongSelf->_arrImage addObject:kMeUnNilStr(object[@"key"])];
                    }else{
                        strongSelf->_isError = YES;
                    }
                    dispatch_semaphore_signal(semaphore);
                } failure:^(id object) {
                    strongSelf->_isError = YES;
                    [strongSelf->_arrImage addObject:@""];
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        kMeSTRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!strongSelf->_isError){
                [hub hideAnimated:YES];
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:strongSelf->_arrImage
                                                                   options:kNilOptions
                                                                     error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                             encoding:NSUTF8StringEncoding];
                [MEPublicNetWorkTool postXunweishiApplyWithParModel:self.parModel images:jsonString successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
//                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    MEDynamicGoodApplyStatusVC *vc = [[MEDynamicGoodApplyStatusVC alloc]init];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } failure:^(id object) {
                    
                }];
            }else{
                [MEShowViewTool SHOWHUDWITHHUD:hub test:@"图片上传失败"];
            }
        });
    });
}

#pragma mark - tableView deleagte and sourcedata

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        MEDynamicGoodApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDynamicGoodApplyCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.parModel];
        cell.canEdit = !_isShow;
        return cell;
    }else{
        _gridCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEDynamicGoodApplyNineGridCell class]) forIndexPath:indexPath];
        if(_isShow){
            [_gridCell setUIWithUrlArr:self.parModel.images];
            kMeWEAKSELF
            _gridCell.selectIndexBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                [strongSelf showPhotoWithIndex:index];
            };
        }else{
            [_gridCell setUIWithArr:self.parModel.images];
            kMeWEAKSELF
            _gridCell.selectBlock = ^(MEBynamicPublishGridModel *model) {
                kMeSTRONGSELF
                if(model.isAdd){
                    NSInteger maxIndex= 10 - strongSelf.parModel.images.count;
                    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxIndex columnNumber:3 delegate:strongSelf pushPhotoPickerVc:YES];
                    imagePicker.allowPickingOriginalPhoto = NO;
                    imagePicker.allowPickingVideo = NO;
                    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
                        kMeSTRONGSELF
                        [strongSelf.parModel.images removeLastObject];
                        for (int i = 0; i < assets.count; i ++) {
                            PHAsset *phAsset = assets[i];
                            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                                UIImage *image = photos[i];
                                MEBynamicPublishGridModel *model = [MEBynamicPublishGridModel modelWithImage:image isAdd:NO];
                                NSString *filename = [phAsset valueForKey:@"filename"];
                                model.filePath = [MECommonTool getImagePath:image filename:filename];
                                [strongSelf.parModel.images addObject:model];
                            }
                        }
                        MEBynamicPublishGridModel *lastmodel = [MEBynamicPublishGridModel modelWithImage:[UIImage imageNamed:@"icon_bynamicAdd"] isAdd:YES];
                        [strongSelf.parModel.images addObject:lastmodel];
                        [strongSelf.tableView reloadData];
                    }];
                    [strongSelf presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    kMeSTRONGSELF
                    [strongSelf showPhotoWithIndex:model.selectIndex];
                }
                
            };
            _gridCell.delBlock = ^(NSInteger index) {
                kMeSTRONGSELF
                [strongSelf.parModel.images removeObjectAtIndex:index];
                [strongSelf.tableView reloadData];
            };
        }
        
        return _gridCell;
    }
}


- (void)showPhotoWithIndex:(NSInteger)index{
    _currentIndex = index;
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentIndex = index;
    [browser show];
}


- (NSInteger)numberInYBImageBrowser:(YBImageBrowser *)imageBrowser {
    if(_isShow){
        return self.parModel.images.count;
    }else{
        return self.parModel.images.count -1;
    }
}
- (YBImageBrowserModel *)yBImageBrowser:(YBImageBrowser *)imageBrowser modelForCellAtIndex:(NSInteger)index {
    MEBynamicPublishGridModel *gmodel = [self.parModel.images objectAtIndex:index];
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    if(_isShow){
        model.url = [NSURL URLWithString:self.parModel.images[index]];
    }else{
        model.image = gmodel.image;
    }
    return model;
}
- (UIImageView *)imageViewOfTouchForImageBrowser:(YBImageBrowser *)imageBrowser {
    MEBynamicPublishGridContentView *contenView = [_gridCell.arrImageView objectAtIndex:_currentIndex];
    return contenView.imageVIew;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return kMEDynamicGoodApplyCellHeight;
    }else{
        return [MEDynamicGoodApplyNineGridCell getCellHeightWithArr:self.parModel.images];
    }
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDynamicGoodApplyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDynamicGoodApplyCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEDynamicGoodApplyNineGridCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEDynamicGoodApplyNineGridCell class])];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if(_isShow){
            _tableView.tableFooterView = [UIView new];
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 94)];
            //        view.backgroundColor = [UIColor colorWithHexString:@"ededed"];
            _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnSubmit.titleLabel.font = kMeFont(17);
            _btnSubmit.contentMode = UIViewContentModeRight;
            _btnSubmit.frame = CGRectMake(k15Margin, 25, SCREEN_WIDTH-(k15Margin *2), 44);
            _btnSubmit.cornerRadius = 2;
            _btnSubmit.clipsToBounds = YES;
            [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
            _btnSubmit.backgroundColor = kMEPink;
            _btnSubmit.titleLabel.textColor = [UIColor whiteColor];
            [_btnSubmit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_btnSubmit];
            _tableView.tableFooterView = view;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setTitle:@"申请记录" forState:UIControlStateNormal];

        [_btnRight setImage:[UIImage imageNamed:@"checkxws"] forState:UIControlStateNormal];
        _btnRight.frame = CGRectMake(0, 0, 85, 30);
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight addTarget:self action:@selector(checkList:) forControlEvents:UIControlEventTouchUpInside];
        _btnRight.titleLabel.textColor = kMEPink;
        [_btnRight setTitleColor:kMEPink forState:UIControlStateNormal];
    }
    return _btnRight;
}

@end

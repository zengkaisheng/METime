//
//  MEGoodManngerSpecVC.m
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEGoodManngerSpecVC.h"
#import "MEGoodManngerSpecCell.h"
#import "MEGoodManngerGoodSpec.h"
#import "MEGoodManngerSpecMainCell.h"
#import "MEGoodManngerAddSpecModel.h"
#import "MEAddGoodModel.h"
#import "MEAddGoodStoreGoodsTypeVC.h"
#import "MEGoodManngerAddSpecModel.h"
#import <TZImagePickerController.h>
#import "MEGoodManngerSpecBasicCell.h"
#import "MEEnlargeTouchButton.h"

@interface MEGoodManngerSpecVC ()<UITableViewDelegate, UITableViewDataSource,TZImagePickerControllerDelegate>{
    NSMutableArray *_arrSpec;
//    NSMutableArray *_arrAddSpec;
    CGFloat _cellHeight;//speccell的高度
//    NSInteger _selectCount;//选择的spec的个数
    
    MEAddGoodModel *_addModel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MEGoodManngerSpecCell *cell;
@property (nonatomic, strong) UIButton *btnAdd;
@property (strong, nonatomic) MEEnlargeTouchButton *btnRight;

@end

@implementation MEGoodManngerSpecVC

- (instancetype)initWithModel:(MEAddGoodModel *)model{
    if(self = [super init]){
        _addModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"规格填写";
    _arrSpec = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self btnRight]];
//    _selectCount = 0;
    kMeWEAKSELF
    [MEPublicNetWorkTool postgetGoodSpecNameWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [strongSelf->_arrSpec addObjectsFromArray:[MEGoodManngerGoodSpec mj_objectArrayWithKeyValuesArray:responseObject.data]];
        [strongSelf->_addModel.arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [strongSelf->_arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *newobj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([newobj.idField isEqualToString:obj.idField]){
                    newobj.isSelect = YES;
                }
            }];
        }];
        [strongSelf.view addSubview:self.tableView];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)popBackAction{
    kMeCallBlock(_finishBlcok);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }else{
        return _addModel.arrAddSpec.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(!_cell){
            MEGoodManngerSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGoodManngerSpecCell class]) forIndexPath:indexPath];
            [cell setUIWihtArr:_arrSpec];
            kMeWEAKSELF
            cell.addBlock = ^(MEGoodManngerGoodSpec * model) {
                kMeSTRONGSELF
//                strongSelf->_selectCount ++;
                [strongSelf->_addModel.arrSpec addObject:model];
                [strongSelf->_addModel.arrAddSpec enumerateObjectsUsingBlock:^(MEGoodManngerAddSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MEGoodManngerGoodSpec *sepcModel = [model copy];
                    [obj.arrSpec addObject:sepcModel];
                }];
                [strongSelf.tableView reloadData];
            };
            cell.divBlock = ^(MEGoodManngerGoodSpec * model) {
                kMeSTRONGSELF
//                strongSelf->_selectCount --;
                [strongSelf->_addModel.arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.idField isEqualToString:model.idField]){
                        [strongSelf->_addModel.arrSpec removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                }];
//                [strongSelf->_addModel.arrSpec removeObject:model];
                if(strongSelf->_addModel.arrSpec.count == 0){
                    [strongSelf->_addModel.arrAddSpec removeAllObjects];
                }else{
                    [strongSelf->_addModel.arrAddSpec enumerateObjectsUsingBlock:^(MEGoodManngerAddSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [obj.arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *sepcobj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if([model.idField isEqualToString:sepcobj.idField]){
                                [obj.arrSpec removeObjectAtIndex:idx];
                                 *stop = YES;
                            }
                        }];
                    }];
                }
                [strongSelf.tableView reloadData];
            };
            _cell = cell;
        }
        return _cell;
    }else{
        MEGoodManngerAddSpecModel *model = _addModel.arrAddSpec[indexPath.row];
        MEGoodManngerSpecMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEGoodManngerSpecMainCell class]) forIndexPath:indexPath];
        [cell setUiWihtModel:model];
        kMeWEAKSELF
        cell.delBlock = ^{
            MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定删除?"];
            [aler addButtonWithTitle:@"确定" block:^{
                kMeSTRONGSELF
                [strongSelf->_addModel.arrAddSpec removeObject:model];
                [strongSelf.tableView reloadData];
            }];
            [aler addButtonWithTitle:@"取消"];
            [aler show];
        };
        cell.tapImgBlock = ^(MEGoodManngerSpecBasicCell * cell) {
            kMeSTRONGSELF
            [strongSelf delaActionWithModel:cell];
        };
        return cell;
    }
}

- (void)delaActionWithModel:(MEGoodManngerSpecBasicCell *)cell{
    NSString *str = kMeUnNilStr(cell.model.sepc_img);
    if(str.length == 0){
        kMeWEAKSELF
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
                            cell.model.sepc_img = key;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [cell reloadUI];
                        });
                        [HUD hideAnimated:YES];
                    } failure:^(id object) {
                        [MEShowViewTool SHOWHUDWITHHUD:HUD test:@"图片上传失败"];
                    }];
                }
            }
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
//        [self showPhotoWithModel:str];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(!_cellHeight){
            _cellHeight = [MEGoodManngerSpecCell getCellHeightWithArr:_arrSpec];
        }
        return _cellHeight;
    }else{
        MEGoodManngerAddSpecModel *model = _addModel.arrAddSpec[indexPath.row];
       return [MEGoodManngerSpecMainCell getCellHeightWithModel:model];
    }
}

- (void)addAction:(UIButton *)btn{
//    __block BOOL isSelct = NO;
//    [_arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if(obj.isSelect){
//            isSelct = YES;
//            *stop = YES;
//        }
//    }];
    if(_addModel.arrSpec.count ==0){
        kMeAlter(@"", @"请选择规格");
        return;
    }
    MEGoodManngerAddSpecModel *model = [MEGoodManngerAddSpecModel new];
    [_arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.isSelect){
            MEGoodManngerGoodSpec *sepcModel = [obj copy];
            [model.arrSpec addObject:sepcModel];
        }
    }];
    [_addModel.arrAddSpec addObject:model];
    [self.tableView reloadData];
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGoodManngerSpecCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGoodManngerSpecCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEGoodManngerSpecMainCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEGoodManngerSpecMainCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.btnAdd;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    }
    return _tableView;
}

- (UIButton *)btnAdd{
    if(!_btnAdd){
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAdd.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [_btnAdd addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnAdd.backgroundColor =kMEPink;
        [_btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnAdd setTitle:@"追加规格" forState:UIControlStateNormal];
        _btnAdd.titleLabel.font = kMeFont(15);
    }
    return _btnAdd;
}
- (MEEnlargeTouchButton *)btnRight{
    MEEnlargeTouchButton *btnRight= [MEEnlargeTouchButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 70, 25);
    [btnRight setImage:[UIImage imageNamed:@"inc-xz"] forState:UIControlStateNormal];
    [btnRight setTitle:@"返回" forState:UIControlStateNormal];
    btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 26);
    btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [btnRight setTitleColor:[UIColor colorWithHexString:@"e3e3e3"] forState:UIControlStateNormal];
    btnRight.titleLabel.font = kMeFont(15);
    [btnRight setTitleColor:kMEblack forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(popBackAction) forControlEvents:UIControlEventTouchUpInside];
    return btnRight;
}

@end

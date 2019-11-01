//
//  MEHomeAddTestResultVC.m
//  志愿星
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEHomeAddTestResultVC.h"
#import "MEHomeAddTestResultCell.h"
#import "MEHomeAddTestDecModel.h"
#import <TZImagePickerController.h>
#import "MEHomeTestVC.h"

@interface MEHomeAddTestResultVC ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic, strong) MEHomeAddTestDecModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnSave;

@end

@implementation MEHomeAddTestResultVC

- (instancetype)initWithModel:(MEHomeAddTestDecModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结果上传";
    if(_type == MEHomeAddTestDecTypeeditVC){
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
        CGFloat av = (max - min)/ (kMeUnArr(_model.answers).count + 1);
        kMeWEAKSELF
        [kMeUnArr(_model.answers) enumerateObjectsUsingBlock:^(MEHomeAddTestDecResultModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            kMeSTRONGSELF
            if(idx==0){
                obj.min = min;
                obj.max = min +av;
            }else if (idx==kMeUnArr(strongSelf->_model.answers).count-1){
                obj.min = min + (av*idx) + 1;
                obj.max = max;
            }
            else{
                obj.min = min + (av*idx) + 1;
                obj.max = min + (av*(idx+1));
            }
        }];
    }
    if(_type != MEHomeAddTestDecTypelplatVC){
        [self.view addSubview:[self getBottomView]];
    }
    [self.view addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kMeUnArr(_model.answers).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEHomeAddTestDecResultModel *model = kMeUnArr(_model.answers)[indexPath.row];
    MEHomeAddTestResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEHomeAddTestResultCell class]) forIndexPath:indexPath];
    [cell setUiWIthModel:model index:indexPath.row type:_type];
    kMeWEAKSELF
    cell.addPhotoBlock = ^{
        kMeSTRONGSELF
        [strongSelf addPhotoWithIndex:indexPath.row];
    };
    if(_type == MEHomeAddTestDecTypelplatVC){
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (void)addPhotoWithIndex:(NSInteger)index{
    kMeWEAKSELF
    MEHomeAddTestDecResultModel *model = kMeUnArr(_model.answers)[index];
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
                        model.answer = key;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        kMeSTRONGSELF
                        [strongSelf.tableView reloadData];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMEHomeAddTestResultCellHeight;
}


- (void)saveAction:(UIButton*)btn{
    kMeWEAKSELF
    [kMeUnArr(_model.answers) enumerateObjectsUsingBlock:^(MEHomeAddTestDecResultModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        kMeSTRONGSELF
        if(!kMeUnNilStr(obj.answer).length){
            [MEShowViewTool showMessage:@"请先上传图片" view:strongSelf.view];
            *stop = YES;
        }
    }];
    if(_type == MEHomeAddTestDecTypeeditVC){
        [MEPublicNetWorkTool postgetbankeditBankWithModel:_model SuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            MEHomeTestVC *dvc = (MEHomeTestVC *)[MECommonTool getClassWtihClassName:[MEHomeTestVC class] targetVC:strongSelf];
            if(dvc){
                [strongSelf.navigationController popToViewController:dvc animated:YES];
            }
        } failure:^(id object) {
            
        }];
    }else{
        [MEPublicNetWorkTool postgetbankaddBankWithModel:_model SuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            MEHomeTestVC *dvc = (MEHomeTestVC *)[MECommonTool getClassWtihClassName:[MEHomeTestVC class] targetVC:strongSelf];
            if(dvc){
                [strongSelf.navigationController popToViewController:dvc animated:YES];
            }
        } failure:^(id object) {
            
        }];
    }
    

}

- (void)addAction:(UIButton*)btn{
    MEAlertView *aler = [[MEAlertView alloc] initWithTitle:@"" message:@"确定分数阶段吗?"];
    kMeWEAKSELF
    [aler addButtonWithTitle:@"确定" block:^{
        kMeSTRONGSELF
        [strongSelf addLevel];
    }];
    [aler addButtonWithTitle:@"取消"];
    [aler show];
}

- (void)addLevel{
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
    CGFloat av = (max - min)/ (kMeUnArr(_model.answers).count + 1);
    
    for (NSInteger i=0; i<_model.answers.count; i++) {
        MEHomeAddTestDecResultModel *model = _model.answers[i];
        if(i==0){
            model.min = min;
            model.max = min +av;
        }else{
            model.min = min + (av*i) + 1;
            model.max = min + (av*(i+1));
        }
    }
    MEHomeAddTestDecResultModel *lastmodel = [MEHomeAddTestDecResultModel new];
    lastmodel.min = min + (av*_model.answers.count);
    lastmodel.max = max;
    [_model.answers addObject:lastmodel];
    [self.tableView reloadData];
}

#pragma MARK - Setter

- (UITableView *)tableView{
    if(!_tableView){
        CGFloat bottom = 0;
        if(_type != MEHomeAddTestDecTypelplatVC){
            bottom = 90;
        }
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-bottom) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEHomeAddTestResultCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEHomeAddTestResultCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if(_type != MEHomeAddTestDecTypelplatVC){
            _tableView.tableFooterView = self.btnAdd;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)btnAdd{
    if(!_btnAdd){
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAdd.frame = CGRectMake(0,0, SCREEN_WIDTH, k50WH);
        _btnAdd.backgroundColor = [UIColor colorWithHexString:@"f3f4f6"];
        [_btnAdd setImage:[UIImage imageNamed:@"stortadd"] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

- (UIView *)getBottomView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 90, SCREEN_WIDTH, 90)];
    _btnSave = [MEView btnWithFrame:CGRectMake(15, (90-40)/2, SCREEN_WIDTH-30, 40) Img:nil title:@"确定" target:self Action:@selector(saveAction:)];
    _btnSave.cornerRadius = 20;
    _btnSave.clipsToBounds = YES;
    _btnSave.backgroundColor = kMEPink;
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSave.titleLabel.font = kMeFont(15);
    [view addSubview:_btnSave];
    return view;
}


@end

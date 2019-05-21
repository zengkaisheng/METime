//
//  MEAddGoodVC.m
//  ME时代
//
//  Created by hank on 2019/3/27.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEAddGoodVC.h"
#import "MEAddGoodBasicCell.h"
#import "MEAddGoodAssembleCell.h"
#import "MEAddGoodDivideCell.h"
#import "MEAddGoodGoodAttributeCell.h"
#import "MEGoodManngerSpecVC.h"
#import "MEAddGoodModel.h"
#import "MEAddGoodStoreGoodsTypeVC.h"
#import "MEAddGoodStoreGoodsType.h"
#import <TZImagePickerController.h>
#import "YBImageBrowser.h"
#import "MEGoodManngerAddSpecModel.h"
#import "MEGoodManngerGoodSpec.h"
#import "MEAddGoodDetailModel.h"
#import "MEGoodManngerStorePowerModel.h"
#import "MERichTextVC.h"

@interface MEAddGoodVC ()<UITableViewDelegate, UITableViewDataSource,TZImagePickerControllerDelegate,YBImageBrowserDataSource>{
    //0 good 1 hot 2rec
    NSInteger _type;
    NSString *_token;
    BOOL _isEdit;
    NSString *_productId;
    MEGoodManngerStorePowerModel *_powermodel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) MEAddGoodModel *addModel;
@property (nonatomic, strong) MEAddGoodGoodAttributeCell *cell;
@end

@implementation MEAddGoodVC

- (instancetype)initWithProductId:(NSString *)productId{
    if(self = [super init]){
        _isEdit = YES;
        _productId = productId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _isEdit?@"修改商品":@"添加商品";
    kMeWEAKSELF
    [MEPublicNetWorkTool postgetStorePowerWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf->_powermodel = [MEGoodManngerStorePowerModel mj_objectWithKeyValues:responseObject.data];
        if(strongSelf->_isEdit){
            [strongSelf initWithSomethingEdit];
        }else{
            [strongSelf initWithSomething];
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)initWithSomethingEdit{
    kMeWEAKSELF
    [MEPublicNetWorkTool postgetStoreGoodsDetailWithProduct_id:_productId SuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if(![responseObject.data isKindOfClass:[NSDictionary class]]){
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        MEAddGoodDetailModel *model = [MEAddGoodDetailModel mj_objectWithKeyValues:responseObject.data];
        MEAddGoodModel *addmodel = [MEAddGoodModel getModel];
        addmodel.list_order = kMeUnNilStr(model.list_order);
        addmodel.title = kMeUnNilStr(model.title);
        
        addmodel.desc = kMeUnNilStr(model.desc);
        addmodel.market_price = kMeUnNilStr(model.market_price);
        addmodel.money = kMeUnNilStr(model.money);
        addmodel.postage = kMeUnNilStr(model.postage);
        
        addmodel.store_product_type = model.store_product_type;
        addmodel.ratio_after_sales = model.ratio_after_sales;
        addmodel.ratio_marketing = model.ratio_marketing;
        addmodel.ratio_store = model.ratio_store;
        
        //拼团
        addmodel.group_num =kMeUnNilStr(model.group.group_num);
        addmodel.over_time = kMeUnNilStr(model.group.over_time);
        addmodel.red_packet = kMeUnNilStr(model.group.red_packet);
        addmodel.start_time = kMeUnNilStr(model.group.start_time);
        addmodel.end_time = kMeUnNilStr(model.group.end_time);
        
        
        addmodel.images = kMeUnNilStr(model.images);
        addmodel.images_hot = kMeUnNilStr(model.images_hot);
        addmodel.image_rec = kMeUnNilStr(model.image_rec);
        addmodel.keywords = kMeUnNilStr(model.keywords);
        
        
        addmodel.tool = model.product_position;
        addmodel.state = model.state;
        addmodel.is_new = model.is_new;
        addmodel.is_hot = model.is_hot;
        addmodel.is_recommend = model.is_recommend;
        addmodel.is_clerk_share = model.is_clerk_share;
        addmodel.restrict_num = kMeUnNilStr(model.restrict_num);
        addmodel.category_id = model.category_id;
        addmodel.category = kMeUnNilStr(model.category_name);
        
        addmodel.content = kMeUnNilStr(model.content);
        addmodel.product_id = strongSelf->_productId;
        __block NSMutableArray *arrSpec = [NSMutableArray array];
        //            __block NSMutableArray *arrSpecTrueName = [NSMutableArray array];
        //            __block NSMutableArray *arrSpecTrueID = [NSMutableArray array];
        [model.spec_name enumerateObjectsUsingBlock:^(MEAddGoodDetailSpecNameModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MEGoodManngerGoodSpec *spec = [MEGoodManngerGoodSpec new];
            spec.spec_name = kMeUnNilStr(obj.name);
            spec.idField = kMeUnNilStr(obj.key);
            //                [arrSpecTrueName addObject:kMeUnNilStr(obj.name)];
            
            //                spec.specContent = kMeUnNilStr(obj.value);
            [arrSpec addObject:spec];
        }];
        addmodel.arrSpec = [NSMutableArray arrayWithArray:arrSpec];
        
        __block NSMutableArray *arrAddSpec = [NSMutableArray array];
        [model.spec_ids enumerateObjectsUsingBlock:^(MEAddGoodDetailSpecIdsModel *obj, NSUInteger idxx, BOOL * _Nonnull stop) {
            MEGoodManngerAddSpecModel *addspecModel = [MEGoodManngerAddSpecModel new];
            addspecModel.saleIntegral = obj.integral;
            addspecModel.shareIntegral = obj.shop_integral;
            addspecModel.price = obj.goods_price;
            addspecModel.stock = obj.stock;
            addspecModel.sepc_img = obj.spec_img;
            __block NSMutableArray *arrSpecc = [NSMutableArray array];
            [obj.spec_ids_value enumerateObjectsUsingBlock:^(MEAddGoodDetailSpecIdsValueModel *objvalue, NSUInteger idx, BOOL * _Nonnull stop) {
                MEGoodManngerGoodSpec *specModel = [MEGoodManngerGoodSpec new];
                MEGoodManngerGoodSpec *sssModel = arrSpec[idx];
                specModel.spec_name = kMeUnNilStr(sssModel.spec_name);
                specModel.idField = kMeUnNilStr(sssModel.idField);
                specModel.specContent = kMeUnNilStr(objvalue.value);
                [arrSpecc addObject:specModel];
            }];
            addspecModel.arrSpec = [NSMutableArray arrayWithArray:arrSpecc];;
            [arrAddSpec addObject:addspecModel];
        }];
        addmodel.arrAddSpec = [NSMutableArray arrayWithArray:arrAddSpec];
        strongSelf.addModel = addmodel;
        [strongSelf initWithSomething];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)initWithSomething{
    if(_powermodel.is_goods == 2){
        kMeAlter(@"提示", @"您没有添加商品的权限");
    }
    [self.view addSubview:self.tableView];
    UIView *viewForBottom = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-67, SCREEN_WIDTH, 67)];
    _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAdd.frame = CGRectMake(16, 10, SCREEN_WIDTH-32, 47);
    _btnAdd.backgroundColor = kMEPink;
    [_btnAdd setTitle:@"保存" forState:UIControlStateNormal];
    _btnAdd.cornerRadius =2;
    _btnAdd.clipsToBounds = YES;
    [_btnAdd addTarget:self action:@selector(addGoodAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewForBottom addSubview:_btnAdd];
    [self.view addSubview:viewForBottom];
    kMeWEAKSELF
    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
    [MEPublicNetWorkTool postgetQiuNiuTokkenWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [HUD hideAnimated:YES];
        strongSelf->_token = responseObject.data[@"token"];
    } failure:^(id object) {
        kMeSTRONGSELF
        [HUD hideAnimated:YES];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)addGoodAction:(UIButton *)btn{
    [self.view endEditing:YES];
    if(_powermodel.is_goods == 2){
        kMeAlter(@"提示", @"您没有添加商品的权限");
        return;
    }
    if(!kMeUnNilStr(self.addModel.list_order).length){
        [MEShowViewTool showMessage:@"排序不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.title).length){
        [MEShowViewTool showMessage:@"商品名称不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.desc).length){
        [MEShowViewTool showMessage:@"商品描述不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.market_price).length){
        [MEShowViewTool showMessage:@"市场价格不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.money).length){
        [MEShowViewTool showMessage:@"现价不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.postage).length){
        [MEShowViewTool showMessage:@"邮费不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.images).length){
        [MEShowViewTool showMessage:@"商品图标不能为空" view:kMeCurrentWindow];
        return;
    }
    if(self.addModel.store_product_type == 7){
        if(!kMeUnNilStr(self.addModel.group_num).length){
            [MEShowViewTool showMessage:@"拼团人数不能为空" view:kMeCurrentWindow];
            return;
        }
        if(!kMeUnNilStr(self.addModel.over_time).length){
            [MEShowViewTool showMessage:@"拼团结束时间不能为空" view:kMeCurrentWindow];
            return;
        }
        if(!kMeUnNilStr(self.addModel.red_packet).length){
            [MEShowViewTool showMessage:@"平团成功红包金额不能为空" view:kMeCurrentWindow];
            return;
        }
        if(!kMeUnNilStr(self.addModel.start_time).length){
            [MEShowViewTool showMessage:@"开始时间不能为空" view:kMeCurrentWindow];
            return;
        }
        if(!kMeUnNilStr(self.addModel.end_time).length){
            [MEShowViewTool showMessage:@"结束时间不能为空" view:kMeCurrentWindow];
            return;
        }
        
        if(![MECommonTool compareOneDay:self.addModel.end_time withAnotherDay:self.addModel.start_time]){
            [MEShowViewTool showMessage:@"拼团开始时间不能大于结束时间" view:kMeCurrentWindow];
            return;
        }
        
    }
    
    if(_powermodel.is_brokerage == 1){
        CGFloat alldivide = self.addModel.ratio_store + self.addModel.ratio_marketing + self.addModel.ratio_after_sales;
        if(alldivide>100){
            [MEShowViewTool showMessage:@"分成相加不能大于100" view:kMeCurrentWindow];
            return;
        }
    }

    if(!kMeUnNilStr(self.addModel.keywords).length){
        [MEShowViewTool showMessage:@"关键词不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.restrict_num).length){
        [MEShowViewTool showMessage:@"限制购买个数不能为空" view:kMeCurrentWindow];
        return;
    }
    if(!kMeUnNilStr(self.addModel.category).length){
        [MEShowViewTool showMessage:@"商品分类不能为空" view:kMeCurrentWindow];
        return;
    }
    
    if(self.addModel.arrSpec.count == 0){
        [MEShowViewTool showMessage:@"请选择规格" view:kMeCurrentWindow];
        return;
    }
    __block BOOL isreturn = NO;
    [self.addModel.arrAddSpec enumerateObjectsUsingBlock:^(MEGoodManngerAddSpecModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL iserror = NO;
        [obj.arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *objSpec, NSUInteger idx, BOOL * _Nonnull stopspec) {
            if(!kMeUnNilStr(objSpec.specContent).length){
                [MEShowViewTool showMessage:@"请输入完整规格规格" view:kMeCurrentWindow];
                iserror = YES;
                isreturn = YES;
                *stopspec = YES;
            }
        }];
        if(iserror){
            isreturn = YES;
            *stop = YES;
        }
        if(!kMeUnNilStr(obj.stock).length){
            [MEShowViewTool showMessage:@"请输入完整规格规格" view:kMeCurrentWindow];
            isreturn = YES;
            *stop = YES;
        }
        if(!kMeUnNilStr(obj.price).length){
            [MEShowViewTool showMessage:@"请输入完整规格规格" view:kMeCurrentWindow];
            isreturn = YES;
            *stop = YES;
        }
        if(!kMeUnNilStr(obj.shareIntegral).length){
            [MEShowViewTool showMessage:@"请输入完整规格规格" view:kMeCurrentWindow];
            isreturn = YES;
            *stop = YES;
        }
        if(!kMeUnNilStr(obj.saleIntegral).length){
            [MEShowViewTool showMessage:@"请输入完整规格规格" view:kMeCurrentWindow];
            isreturn = YES;
            *stop = YES;
        }
    }];
    
    if(isreturn){
        return;
    }
    __block NSMutableArray *arrSpecName = [NSMutableArray array];
    [self.addModel.arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MEAddGoodspecNameModel *specNameModel = [MEAddGoodspecNameModel new];
        specNameModel.key = kMeUnNilStr(obj.idField);
        __block NSMutableArray *arrValue = [NSMutableArray array];
        [self.addModel.arrAddSpec enumerateObjectsUsingBlock:^(MEGoodManngerAddSpecModel *addobj, NSUInteger idx, BOOL * _Nonnull stopadd) {
            [addobj.arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *addSpecobj, NSUInteger idx, BOOL * _Nonnull stopaddspec) {
                if([obj.idField isEqualToString:addSpecobj.idField]){
                    [arrValue addObject:addSpecobj.specContent];
                    *stopaddspec = YES;
                }
            }];
        }];
        specNameModel.value = [NSArray arrayWithArray:arrValue];
        NSDictionary *dic = [specNameModel mj_keyValues];
        [arrSpecName addObject:dic];
    }];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrSpecName
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    self.addModel.spec_name = jsonString;
    
    __block NSMutableArray *arrjson = [NSMutableArray array];
    [self.addModel.arrAddSpec enumerateObjectsUsingBlock:^(MEGoodManngerAddSpecModel *addobj, NSUInteger idx, BOOL * _Nonnull stopadd) {
        MEAddGoodspecJsoneModel *jsonModel = [MEAddGoodspecJsoneModel new];
        __block NSMutableArray *arrvalue = [NSMutableArray new];
        [addobj.arrSpec enumerateObjectsUsingBlock:^(MEGoodManngerGoodSpec *addSpecobj, NSUInteger idx, BOOL * _Nonnull stopaddspec) {
            [arrvalue addObject:kMeUnNilStr(addSpecobj.specContent)];
        }];
        jsonModel.value = [arrvalue componentsJoinedByString:@","];
        jsonModel.goods_price = addobj.price;
        jsonModel.stock = addobj.stock;
        jsonModel.integral = addobj.saleIntegral;
        jsonModel.shop_integral = addobj.shareIntegral;
        jsonModel.spec_img = addobj.sepc_img;
        NSDictionary *dic = [jsonModel mj_keyValues];

        [arrjson addObject:dic];
    }];
    
    NSData *jsonDatajson = [NSJSONSerialization dataWithJSONObject:arrjson
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonStringjson = [[NSString alloc] initWithData:jsonDatajson
                                                 encoding:NSUTF8StringEncoding];
    self.addModel.spec_json = jsonStringjson;
    kMeWEAKSELF
    [MEPublicNetWorkTool postcommonAddOrEditGoodsWithParModel:self.addModel successBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        kMeCallBlock(strongSelf.finishAddBlock);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id object) {
        
    }];
    
}

- (void)dealActionWithType:(NSInteger)type{
    _type = type;
    switch (type) {
        case 0:{
            NSString *imgStr = self.addModel.images;
            [self delaActionWithModel:imgStr];
        }
            break;
        case 1:{
            NSString *imgHotStr = self.addModel.images_hot;
            [self delaActionWithModel:imgHotStr];
        }
            break;
        case 2:{
            NSString *imgRecStr = self.addModel.image_rec;
            [self delaActionWithModel:imgRecStr];
        }
            break;
        default:
            break;
    }
}

- (void)delaActionWithModel:(NSString *)model{
    NSString *str = kMeUnNilStr(model);
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
//                    MEBynamicPublishGridModel *gmodel = [MEBynamicPublishGridModel modelWithImage:image isAdd:NO];
                    NSString *filename = [phAsset valueForKey:@"filename"];
                    NSString *path = [MECommonTool getImagePath:image filename:filename];
                    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];

                    [MEPublicNetWorkTool postQiNiuUpFileWithToken:strongSelf->_token filePath:path successBlock:^(id object) {
                        NSLog(@"%@",object);
                        if([object isKindOfClass:[NSDictionary class]]){
                            NSString *key = kMeUnNilStr(object[@"key"]);
                            switch (strongSelf->_type) {
                                case 0:{
                                    strongSelf->_addModel.images = key;
                                }
                                    break;
                                case 1:{
                                    strongSelf->_addModel.images_hot = key;
                                }
                                    break;
                                case 2:{
                                    strongSelf->_addModel.image_rec = key;
                                }
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            kMeSTRONGSELF
                           [strongSelf->_cell setUIWithModel:strongSelf->_addModel];
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
        [self showPhotoWithModel:str];
    }
}

- (void)showPhotoWithModel:(NSString*)model{
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentIndex = 0;
    [browser show];
}

- (NSInteger)numberInYBImageBrowser:(YBImageBrowser *)imageBrowser {
    return 1;
}
- (YBImageBrowserModel *)yBImageBrowser:(YBImageBrowser *)imageBrowser modelForCellAtIndex:(NSInteger)index {
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    switch (_type) {
        case 0:{
            NSString *imgStr = MELoadQiniuImagesWithUrl(self.addModel.images);
            model.url = [NSURL URLWithString:imgStr];
        }
            break;
        case 1:{
            NSString *imgHotStr = MELoadQiniuImagesWithUrl(self.addModel.images_hot);
            model.url = [NSURL URLWithString:imgHotStr];
        }
            break;
        case 2:{
            NSString *imgRecStr = MELoadQiniuImagesWithUrl(self.addModel.image_rec);
            model.url = [NSURL URLWithString:imgRecStr];
        }
            break;
        default:
            break;
    }
    return model;
}
- (UIImageView *)imageViewOfTouchForImageBrowser:(YBImageBrowser *)imageBrowser {
    switch (_type) {
        case 0:{
            return _cell.imgGood;
        }
            break;
        case 1:{
            return _cell.imgGoodHot;
            
        }
            break;
        case 2:{
            return _cell.imgRecommend;
        }
            break;
        default:
            return [UIImageView new];
            break;
    }
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        MEAddGoodBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAddGoodBasicCell class]) forIndexPath:indexPath];
        [cell setUIWithModel:self.addModel];
        kMeWEAKSELF
        cell.selectType = ^{
            kMeSTRONGSELF
            [strongSelf.tableView reloadData];
        };
        cell.selectGoodType = ^{
            kMeSTRONGSELF
            MEAddGoodStoreGoodsTypeVC *vc = [[MEAddGoodStoreGoodsTypeVC alloc]init];
            vc.blcok = ^(MEAddGoodStoreGoodsType *model) {
                strongSelf.addModel.category_id = model.idField;
                strongSelf.addModel.category = model.category_name;
                [strongSelf.tableView reloadData];
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if(indexPath.row == 1){
        if(self.addModel.store_product_type == 1){
            return [UITableViewCell new];
        }else{
            MEAddGoodAssembleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAddGoodAssembleCell class]) forIndexPath:indexPath];
            [cell setUIWithModel:self.addModel];
            return cell;
        }
    }else if(indexPath.row == 2){
        if(_powermodel.is_brokerage == 1){
            MEAddGoodDivideCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAddGoodDivideCell class]) forIndexPath:indexPath];
            [cell setUIWithModel:self.addModel];
            return cell;
        }else{
            return [UITableViewCell new];
        }
    }else if(indexPath.row == 3){
        _cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEAddGoodGoodAttributeCell class]) forIndexPath:indexPath];
        [_cell setUIWithModel:self.addModel];
        kMeWEAKSELF
        _cell.selectSpecBlock = ^{
            kMeSTRONGSELF
            MEGoodManngerSpecVC *vc = [[MEGoodManngerSpecVC alloc]initWithModel:strongSelf.addModel];
            vc.token = strongSelf->_token;
            vc.finishBlcok = ^{
                [strongSelf.tableView reloadData];
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        _cell.selectImgBlock = ^(NSInteger index) {
            kMeSTRONGSELF
            [strongSelf dealActionWithType:index];
        };
        _cell.selectRichEditBlock = ^{
            kMeSTRONGSELF
            MERichTextVC *vc = [[MERichTextVC alloc]init];
            vc.model = strongSelf.addModel;
            vc.token = strongSelf->_token;
            vc.finishBlcok = ^{
                [strongSelf.tableView reloadData];
            };
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        return _cell;
    }else{
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return kMEAddGoodBasicCellHeight;
    }else if(indexPath.row == 1){
        if(self.addModel.store_product_type == 1){
            return 0.1;
        }else{
            return kMEAddGoodAssembleCellHeight;
        }
    }else if(indexPath.row == 2){
        if(_powermodel.is_brokerage == 1){
            return kMEAddGoodDivideCellHeight;
        }else{
            return 0.1;
        }
    }else if(indexPath.row == 3){
        return kMEAddGoodGoodAttributeCellHeight;
    }else{
        return 0.1;
    }
}


#pragma mark - Set And Get

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-67) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAddGoodBasicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAddGoodBasicCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAddGoodAssembleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAddGoodAssembleCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAddGoodDivideCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAddGoodDivideCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEAddGoodGoodAttributeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEAddGoodGoodAttributeCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];;
    }
    return _tableView;
}

- (MEAddGoodModel *)addModel{
    if(!_addModel){
        _addModel = [MEAddGoodModel getModel];
    }
    return _addModel;
}

@end

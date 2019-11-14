//
//  MEApplyOrganizationInfoVC.m
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEApplyOrganizationInfoVC.h"
#import "MEAddCustomerInfoModel.h"
#import "MEApplyOrganizationCell.h"
#import "MECustomerClassifyListModel.h"
#import "MEApplyOrganizationModel.h"

#import "MEAddressPickerView.h"
#import "DataPickerView.h"
#import "MECreatedOrganizationVC.h"

#import <TZImagePickerController.h>

@interface MEApplyOrganizationInfoVC ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>{
    NSString *_token;
    BOOL _isError;
}

@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) UIImageView *reviewImageV;
@property (nonatomic, strong) NSMutableArray *serviceTypeArr;      //服务类型

@property (nonatomic, strong) NSString *applyCerPath;
@property (nonatomic, strong) NSString *headerPicPath;
@property (nonatomic, strong) MEApplyOrganizationModel *applyModel;

@end

@implementation MEApplyOrganizationInfoVC

- (instancetype)initWithLatitude:(NSString *)latitude longitude:(NSString *)longitude {
    if (self = [super init]) {
        self.applyModel.la = latitude;
        self.applyModel.lg = longitude;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请入会";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topImgV];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.applyBtn];
    
    [self loadBaseInformation];
    kMeWEAKSELF
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
    
    [kMeCurrentWindow addSubview:self.reviewImageV];
    self.reviewImageV.hidden = YES;
    
    [self requestServiceTypeWithNetWork];
}

#pragma mark -- Networking
//机构服务类型
- (void)requestServiceTypeWithNetWork {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetServiceTypeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)responseObject.data;
            strongSelf.serviceTypeArr = [MECustomerClassifyListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        }
    } failure:^(id object) {
    }];
}

- (void)loadBaseInformation {
    //基本资料
    MEAddCustomerInfoModel *orgNameModel = [self creatModelWithTitle:@"组织名称" andPlaceHolder:@"请输入你的组织名称" andMaxInputWords:20 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入你的组织名称"];
    
    MEAddCustomerInfoModel *nameModel = [self creatModelWithTitle:@"联系人" andPlaceHolder:@"请输入你的姓名" andMaxInputWords:20 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入你的姓名"];
    
    MEAddCustomerInfoModel *idCardModel = [self creatModelWithTitle:@"身份证号码" andPlaceHolder:@"请输入你的身份证号码" andMaxInputWords:18 andIsTextField:YES andIsMustInput:YES andToastStr:@"输入你的身份证号码"];
    
    MEAddCustomerInfoModel *phoneModel = [self creatModelWithTitle:@"手机号" andPlaceHolder:@"请输入你的手机号" andMaxInputWords:11 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入你的手机号"];
    phoneModel.isNumberType = YES;
    
    MEAddCustomerInfoModel *emailModel = [self creatModelWithTitle:@"邮箱" andPlaceHolder:@"请输入你的邮箱" andMaxInputWords:20 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入你的邮箱"];
    
    MEAddCustomerInfoModel *areaModel = [self creatModelWithTitle:@"所在地区" andPlaceHolder:@"请选择你的所在地区" andMaxInputWords:20 andIsTextField:YES andIsMustInput:YES andToastStr:@"请选择你的所在地区"];
    areaModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *typeModel = [self creatModelWithTitle:@"服务类型" andPlaceHolder:@"请选择服务类型" andMaxInputWords:20 andIsTextField:YES andIsMustInput:YES andToastStr:@"请选择服务类型"];
    typeModel.isHideArrow = NO;
    
    MEAddCustomerInfoModel *fileModel = [self creatModelWithTitle:@"组织申请函" andPlaceHolder:@"请上传你的组织申请函" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请上传你的组织申请函"];
    fileModel.isCanCheck = YES;
    
    MEAddCustomerInfoModel *reasonModel = [self creatModelWithTitle:@"申请理由" andPlaceHolder:@"不少于50字" andMaxInputWords:100 andIsTextField:NO andIsMustInput:YES andToastStr:@"不少于50字"];
    reasonModel.isTextView = YES;
    
    MEAddCustomerInfoModel *remarkModel = [self creatModelWithTitle:@"备注" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:YES andIsMustInput:NO andToastStr:@""];
    remarkModel.isTextView = YES;
    
    MEAddCustomerInfoModel *introduceModel = [self creatModelWithTitle:@"组织详情介绍" andPlaceHolder:@"请输入你的组织详情介绍" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请输入你的组织详情介绍"];
    introduceModel.isTextView = YES;
    
    MEAddCustomerInfoModel *signModel = [self creatModelWithTitle:@"组织宣言" andPlaceHolder:@"限制20字以内" andMaxInputWords:20 andIsTextField:YES andIsMustInput:YES andToastStr:@"请输入你的组织宣言"];
    
    MEAddCustomerInfoModel *uploadModel = [self creatModelWithTitle:@"上传组织头像" andPlaceHolder:@"" andMaxInputWords:0 andIsTextField:NO andIsMustInput:YES andToastStr:@"请上传你的组织头像"];
    
    [self.dataSource addObjectsFromArray:@[orgNameModel,nameModel,idCardModel,phoneModel,emailModel,areaModel,typeModel,fileModel,reasonModel,remarkModel,introduceModel,signModel,uploadModel]];
    [self.tableView reloadData];
}

- (MEAddCustomerInfoModel *)creatModelWithTitle:(NSString *)title andPlaceHolder:(NSString *)placeHolder andMaxInputWords:(NSInteger)maxInputWords andIsTextField:(BOOL)isTextField andIsMustInput:(BOOL)isMustInput andToastStr:(NSString *)toastStr{
    
    MEAddCustomerInfoModel *model = [[MEAddCustomerInfoModel alloc]init];
    model.title = title;
    model.value = @"";
    model.placeHolder = placeHolder;
    model.maxInputWord = maxInputWords;
    model.isTextField = isTextField;
    model.isMustInput = isMustInput;
    model.toastStr = toastStr;
    model.isEdit = YES;
    model.isHideArrow = YES;
    model.isCanCheck = NO;
    return model;
}

#pragma mark -- Aaction
- (void)applyBtnAction {
    [self.view endEditing:YES];
    for (MEAddCustomerInfoModel *model in self.dataSource) {
        if ([model.title isEqualToString:@"组织名称"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.org_name = model.value;
            }
        }
        if ([model.title isEqualToString:@"联系人"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.link_name = model.value;
            }
        }
        if ([model.title isEqualToString:@"身份证号码"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                if (![MECommonTool checkIdentityStringValid:kMeUnNilStr(model.value)]) {
                    [MECommonTool showMessage:@"身份证号码格式不正确" view:kMeCurrentWindow];
                    return;
                }else {
                    self.applyModel.link_name = model.value;
                }
            }
        }
        if ([model.title isEqualToString:@"手机号"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.phone = model.value;
            }
        }
        if ([model.title isEqualToString:@"邮箱"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.e_mail = model.value;
            }
        }
        if ([model.title isEqualToString:@"所在地区"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }
//            else {
//                self.applyModel.e_mail = model.value;
//            }
        }
        if ([model.title isEqualToString:@"组织申请函"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.org_img = model.value;
            }
        }
        if ([model.title isEqualToString:@"申请理由"]) {
            if (kMeUnNilStr(model.value).length <= 50) {
                [MECommonTool showMessage:[NSString stringWithFormat:@"申请理由%@",model.toastStr] view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.apply_reason = model.value;
            }
        }
        if ([model.title isEqualToString:@"备注"]) {
            self.applyModel.org_remark = model.value;
        }
        if ([model.title isEqualToString:@"组织详情介绍"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.detail = model.value;
            }
        }
        if ([model.title isEqualToString:@"组织宣言"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.signature = model.value;
            }
        }
        if ([model.title isEqualToString:@"服务类型"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.services_type = model.valueId;
            }
        }
        if ([model.title isEqualToString:@"上传组织头像"]) {
            if (kMeUnNilStr(model.value).length <= 0) {
                [MECommonTool showMessage:model.toastStr view:kMeCurrentWindow];
                return;
            }else {
                self.applyModel.org_images = model.value;
            }
        }
    }
    
    _isError = NO;
    
    NSArray *images = [NSArray arrayWithObjects:self.applyCerPath,self.headerPicPath, nil];
    
    kMeWEAKSELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    MBProgressHUD *hub =  [MEPublicNetWorkTool commitWithHUD:@"提交中"];
    dispatch_group_async(group, queue, ^{
        kMeSTRONGSELF
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        for (int i = 0; i < images.count; i++) {
            NSString *filePath = images[i];
            [MEPublicNetWorkTool postQiNiuUpFileWithToken:strongSelf->_token filePath:filePath successBlock:^(id object) {
                NSLog(@"%@",object);
                if([object isKindOfClass:[NSDictionary class]]){
                    if (i == 0) {
                        strongSelf.applyModel.org_img = kMeUnNilStr(object[@"key"]);
                    }else if (i == 1) {
                        strongSelf.applyModel.org_images = kMeUnNilStr(object[@"key"]);
                    }
                }else{
                    strongSelf->_isError = YES;
                }
                dispatch_semaphore_signal(semaphore);
            } failure:^(id object) {
                strongSelf->_isError = YES;
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        kMeSTRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!strongSelf->_isError){
                [hub hideAnimated:YES];
                
                [MEPublicNetWorkTool postApplyOrganizationWithApplyModel:self.applyModel successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    [MEShowViewTool showMessage:@"组织入驻申请已提交" view:self.view];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        MECreatedOrganizationVC *vc = [[MECreatedOrganizationVC alloc] init];
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    });
                } failure:^(id object) {
                }];
            }else{
                [MEShowViewTool SHOWHUDWITHHUD:hub test:@"图片上传失败"];
            }
        });
    });
}

- (void)tapAction {
    if (!self.reviewImageV.hidden) {
        self.reviewImageV.hidden = YES;
    }
}

#pragma mark ------------------ <UITableViewDelegate, UITableViewDataSource> ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEApplyOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MEApplyOrganizationCell class]) forIndexPath:indexPath];
    MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
    [cell setUIWithCustomerModel:model];
    kMeWEAKSELF
    cell.textBlock = ^(NSString *str) {
        model.value = str;
        CGFloat height = 25+11;
        height += [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+20;
        model.orgCellHeight = height>(77+(model.isTextView?18:0))?height:(77+(model.isTextView?18:0));
    };
    cell.reloadBlock = ^{
        kMeSTRONGSELF
        [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.indexBlock = ^(NSInteger index) {
        kMeSTRONGSELF
        if (index == 0) {
            [strongSelf chooseImageWithIndex:indexPath.row];
        }else if (index == 1) {
            //查看
            if (model.image != nil) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    strongSelf.reviewImageV.hidden = NO;
                    strongSelf.reviewImageV.image = model.image;
                });
            }
        }else if (index == 2) {
            //查看模板
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                strongSelf.reviewImageV.hidden = NO;
                strongSelf.reviewImageV.image = [UIImage imageNamed:@"organiation_formwork"];
            });
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
    if (model.isTextView) {
        if ([model.title isEqualToString:@"申请理由"] || [model.title isEqualToString:@"组织详情介绍"] || [model.title isEqualToString:@"备注"]) {
            return model.orgCellHeight;
        }
    }else {
        if (!model.isTextField) {
            return 100;
        }
    }
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MEAddCustomerInfoModel *model = self.dataSource[indexPath.row];
    [self.view endEditing:YES];
    if ([model.title isEqualToString:@"所在地区"]) {
        kMeWEAKSELF
        [MEAddressPickerView areaPickerViewWithProvince:kMeUnNilStr(self.applyModel.province) city:kMeUnNilStr(self.applyModel.city) area:kMeUnNilStr(self.applyModel.county) areaBlock:^(NSString *province, NSString *city, NSString *area) {
            kMeSTRONGSELF
            strongSelf.applyModel.province = kMeUnNilStr(province);
            strongSelf.applyModel.city = kMeUnNilStr(city);
            strongSelf.applyModel.county = kMeUnNilStr(area);
            model.value = [NSString stringWithFormat:@"%@%@%@", kMeUnNilStr(province),kMeUnNilStr(city),kMeUnNilStr(area)];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else if ([model.title isEqualToString:@"服务类型"]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.serviceTypeArr.count; i++) {
            MECustomerClassifyListModel *model = self.serviceTypeArr[i];
            [array addObject:@{@"name":kMeUnNilStr(model.type_name),@"value":@(model.idField)}];
        }
        DataPickerView *dataPicker = [[DataPickerView alloc] init];
        dataPicker.pickerHeight = 52 * (array.count + 2);
        dataPicker.title = @"选择服务类型";
        dataPicker.dataSource = array.copy;
        dataPicker.selectedData = model.value;
        kMeWEAKSELF
        dataPicker.selectBlock = ^(NSString *selectData, NSString *selectId) {
            kMeSTRONGSELF
    //        NSLog(@"选择的value:%@,id:%@",selectData,selectId);
            model.value = selectData;
            model.valueId = selectId;
            strongSelf.applyModel.services_type = selectId;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
}

//选择照片
- (void)chooseImageWithIndex:(NSInteger)index {
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:1 delegate:self pushPhotoPickerVc:YES];
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingVideo = NO;
    kMeWEAKSELF
    [imagePicker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        kMeSTRONGSELF
        for (int i = 0; i < assets.count; i ++) {
            PHAsset *phAsset = assets[i];
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                UIImage *image = photos[i];
                //                NSDictionary *info = infos[i];
                NSString *filename = [phAsset valueForKey:@"filename"];
                NSString *filePath = [MECommonTool getImagePath:image filename:filename];
                MEAddCustomerInfoModel *model = strongSelf.dataSource[index];
                model.value = filePath;
                model.image = image;
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                [strongSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                if (index == 7) {
                    strongSelf.applyCerPath = filePath;
                }else if (index == 12) {
                    strongSelf.headerPicPath = filePath;
                }
            }
        }
    }];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - Set And Get
- (UIImageView *)topImgV {
    if (!_topImgV) {
        _topImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apply_organization_top"]];
        _topImgV.frame = CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, 122*kMeFrameScaleX());
    }
    return _topImgV;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(25,kMeNavBarHeight+37, SCREEN_WIDTH-50, SCREEN_HEIGHT-kMeNavBarHeight-37-25-38-10) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MEApplyOrganizationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MEApplyOrganizationCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 14;
    }
    return _tableView;
}

- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT-25-38, SCREEN_WIDTH-50, 38)];
        _applyBtn.backgroundColor = [UIColor colorWithHexString:@"#2ED9A4"];
        [_applyBtn setTitle:@"申请入会" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _applyBtn.layer.cornerRadius = 14;
        
        [_applyBtn addTarget:self action:@selector(applyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UIImageView *)reviewImageV {
    if (!_reviewImageV) {
        _reviewImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _reviewImageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_reviewImageV addGestureRecognizer:tap];
    }
    return _reviewImageV;
}

- (NSMutableArray *)serviceTypeArr {
    if (!_serviceTypeArr) {
        _serviceTypeArr = [[NSMutableArray alloc] init];
    }
    return _serviceTypeArr;
}

- (MEApplyOrganizationModel *)applyModel {
    if (!_applyModel) {
        _applyModel = [[MEApplyOrganizationModel alloc] init];
    }
    return _applyModel;
}

@end

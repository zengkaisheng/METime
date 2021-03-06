//
//  MERegisteVolunteerVC.m
//  志愿星
//
//  Created by gao lei on 2019/10/23.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MERegisteVolunteerVC.h"
#import "MEBlockTextField.h"
#import "MEAddressPickerView.h"
#import <TZImagePickerController.h>

#import "MERegisterVolunteerModel.h"

@interface MERegisteVolunteerVC ()<TZImagePickerControllerDelegate>{
    NSString *_token;
    BOOL _isError;
}

@property (weak, nonatomic) IBOutlet MEBlockTextField *nameTF;
@property (weak, nonatomic) IBOutlet MEBlockTextField *IDCardTypeTF;
@property (weak, nonatomic) IBOutlet MEBlockTextField *IDCardNumTF;
@property (weak, nonatomic) IBOutlet MEBlockTextField *addressTF;

@property (weak, nonatomic) IBOutlet UIImageView *IDCardFontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *IDCardBackImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTFConsTop;

@property (nonatomic, strong) MERegisterVolunteerModel *model;
@property (nonatomic, strong) NSString *cardFontPath;
@property (nonatomic, strong) NSString *cardBackPath;
@property (nonatomic, strong) NSString *register_protocol;

@end

@implementation MERegisteVolunteerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"成为志愿者";
    self.view.backgroundColor = [UIColor whiteColor];
    _nameTFConsTop.constant = self.isHome?55:(kMeNavBarHeight+55);
    _isError = NO;
    self.navBarHidden = self.isHome;
    kMeWEAKSELF
    _nameTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 15) {
            str = [str substringWithRange:NSMakeRange(0, 15)];
            strongSelf->_nameTF.text = str;
            [strongSelf->_nameTF endEditing:YES];
        }
        strongSelf.model.name = str;
    };
    _IDCardTypeTF.contentBlock = ^(NSString *str) {
        
    };
    _IDCardNumTF.contentBlock = ^(NSString *str) {
        kMeSTRONGSELF
        if (str.length > 18) {
            str = [str substringWithRange:NSMakeRange(0, 18)];
            strongSelf->_IDCardNumTF.text = str;
            [strongSelf->_IDCardNumTF endEditing:YES];
        }
        strongSelf.model.id_number = str;
    };
    _addressTF.contentBlock = ^(NSString *str) {
        
    };
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
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
}

#pragma mark --- Action
- (void)tapAction {
    [self.view endEditing:YES];
}

- (IBAction)chooseIDCardTypeAction:(id)sender {
    //选择证件类型
}

- (IBAction)chooseAddressAction:(id)sender {
    [self.view endEditing:YES];
    kMeWEAKSELF
    [MEAddressPickerView areaPickerViewWithProvince:kMeUnNilStr(self.model.province) city:kMeUnNilStr(self.model.city) area:kMeUnNilStr(self.model.area) areaBlock:^(NSString *province, NSString *city, NSString *area) {
        kMeSTRONGSELF
        strongSelf.model.province = kMeUnNilStr(province);
        strongSelf.model.city = kMeUnNilStr(city);
        strongSelf.model.area = kMeUnNilStr(area);
        strongSelf->_addressTF.text = [NSString stringWithFormat:@"%@%@%@", kMeUnNilStr(province),kMeUnNilStr(city),kMeUnNilStr(area)];
    }];
}

- (IBAction)uploadIDCardFontAction:(id)sender {
    //上传身份证正面
    [self chooseIDCardImageWithIndex:0];
}

- (IBAction)uploadIDCardBackAction:(id)sender {
    //上传身份证反面
    [self chooseIDCardImageWithIndex:1];
}

- (IBAction)agreementAction:(id)sender {
    //查看注册协议
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetVolunteerProtocolWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)responseObject.data;
            strongSelf.register_protocol = kMeUnNilStr(data[@"volunteer_register_protocol"]);
            
            MEBaseVC *vc = [[MEBaseVC alloc] init];
            vc.title = @"注册协议";
            
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight)];
            CGFloat width = [UIScreen mainScreen].bounds.size.width-15;
            NSString *header = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head>",width];
            [webView loadHTMLString:[NSString stringWithFormat:@"%@%@",header,kMeUnNilStr(strongSelf.register_protocol)] baseURL:nil];
            [vc.view addSubview:webView];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(id object) {
        
    }];
}

- (IBAction)registerAction:(id)sender {
    //立即注册
    [self registerVolunteer];
}
//选择照片
- (void)chooseIDCardImageWithIndex:(NSInteger)index {
    BOOL isNotFirstChoosePhoto = [kMeUserDefaults boolForKey:kMEIsNotFirstChoosePhoto];
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:1 delegate:self pushPhotoPickerVc:YES];
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingVideo = NO;

    if (!isNotFirstChoosePhoto) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\"志愿星\"想访问您的相册" message:@"App需要您的同意才能使用相册以供您选择要上传的照片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [kMeUserDefaults setBool:NO forKey:kMEIsNotFirstChoosePhoto];
            [kMeUserDefaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [kMeUserDefaults setBool:YES forKey:kMEIsNotFirstChoosePhoto];
            [kMeUserDefaults synchronize];
            imagePicker.allowPickingImage = YES;
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
                        if (index == 0) {
                            strongSelf.cardFontPath = filePath;
                            strongSelf->_IDCardFontImageView.image = image;
                        }else if (index == 1) {
                            strongSelf.cardBackPath = filePath;
                            strongSelf->_IDCardBackImageView.image = image;
                        }
                    }
                }
            }];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
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
                    if (index == 0) {
                        strongSelf.cardFontPath = filePath;
                        strongSelf->_IDCardFontImageView.image = image;
                    }else if (index == 1) {
                        strongSelf.cardBackPath = filePath;
                        strongSelf->_IDCardBackImageView.image = image;
                    }
                }
            }
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark -- Networking
- (void)registerVolunteer{
    [self.view endEditing:YES];
    NSString *content = kMeUnNilStr(_nameTF.text);
    if(!content.length){
        [MEShowViewTool showMessage:@"请输入姓名" view:self.view];
        return;
    }
    
    content = kMeUnNilStr(_IDCardNumTF.text);
    if(!content.length){
        [MEShowViewTool showMessage:@"请输入证件号码" view:self.view];
        return;
    }
    
    content = kMeUnNilStr(_addressTF.text);
    if(!content.length){
        [MEShowViewTool showMessage:@"请选择注册地址" view:self.view];
        return;
    }
    
    if (self.cardFontPath.length < 0) {
        [MEShowViewTool showMessage:@"请选择身份证正面照片" view:self.view];
        return;
    }
    if (self.cardBackPath.length < 0) {
        [MEShowViewTool showMessage:@"请选择身份证反面照片" view:self.view];
        return;
    }
    
    _isError = NO;
    
    NSArray *images = [NSArray arrayWithObjects:self.cardFontPath,self.cardBackPath, nil];
    
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
                        strongSelf.model.id_image_front = kMeUnNilStr(object[@"key"]);
                    }else if (i == 1) {
                        strongSelf.model.id_image_back = kMeUnNilStr(object[@"key"]);
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
                
                [MEPublicNetWorkTool postRegisterVolunteerWithModel:strongSelf.model successBlock:^(ZLRequestResponse *responseObject) {
                    kMeSTRONGSELF
                    [MEShowViewTool showMessage:@"您已成为志愿者" view:self.view];
                    kCurrentUser.is_volunteer = 1;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    });
                } failure:^(id object) {
                    
                }];
            }else{
                [MEShowViewTool SHOWHUDWITHHUD:hub test:@"图片上传失败"];
            }
        });
    });
}

#pragma mark -- Setter&&Getter
- (MERegisterVolunteerModel *)model {
    if (!_model) {
        _model = [[MERegisterVolunteerModel alloc] init];
    }
    return _model;
}


@end

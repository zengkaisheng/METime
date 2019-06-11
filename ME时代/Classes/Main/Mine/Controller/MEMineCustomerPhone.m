//
//  MEMineCustomerPhone.m
//  ME时代
//
//  Created by hank on 2018/10/9.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineCustomerPhone.h"
//#import "MEStoreModel.h"
#import "ALAssetsLibrary+MECategory.h"

#define kMeWorkPhone @"18102678630"
#define kMeOffWorkPhone @"13580363686"

@interface MEMineCustomerPhone (){
//    MEStoreModel *_stroeModel;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
//@property (weak, nonatomic) IBOutlet UILabel *lblTel;
//@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgVLeft;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgVRight;
@property (weak, nonatomic) IBOutlet UILabel *nameLblLeft;
@property (weak, nonatomic) IBOutlet UILabel *nameLblRight;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MEMineCustomerPhone

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = YES;
//        _lblTel.text = kMeWorkPhone;
//        _lblMobile.text = kMeOffWorkPhone;
    _consTopMargin.constant = kMeStatusBarHeight+k15Margin;
    self.dataArray = [[NSArray alloc] init];
    
    kMeWEAKSELF
    MBProgressHUD *HUD = [MEPublicNetWorkTool commitWithHUD:@""];
    [MEPublicNetWorkTool postGetCustomerServiceWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        [HUD hideAnimated:YES];
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.dataArray = (NSArray *)responseObject.data;
            if (strongSelf.dataArray.count > 1) {
                NSDictionary *leftDic = strongSelf.dataArray[0];
                NSDictionary *rightDic = strongSelf.dataArray[1];
                kSDLoadImg(strongSelf->_codeImgVLeft, leftDic[@"wx_code"]);
                strongSelf->_nameLblLeft.text = leftDic[@"wx_name"];
                kSDLoadImg(strongSelf->_codeImgVRight, rightDic[@"wx_code"]);
                strongSelf->_nameLblRight.text = rightDic[@"wx_name"];
            }
        }
    } failure:^(id object) {
        kMeSTRONGSELF
        if([object isKindOfClass:[ZLRequestResponse class]]){
            ZLRequestResponse *res = (ZLRequestResponse*)object;
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kMeUnNilStr(res.message)];
        }else{
            [MEShowViewTool SHOWHUDWITHHUD:HUD test:kApiError];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - Private

- (IBAction)workCallPhoneAction:(UIButton *)sender {
//    [MECommonTool showWithTellPhone:kMeUnNilStr(_lblTel.text) inView:self.view];
}

- (IBAction)offWorkCallPhoneAction:(UIButton *)sender {
//    [MECommonTool showWithTellPhone:kMeUnNilStr(_lblMobile.text) inView:self.view];
}
- (IBAction)leftDownloadAction:(id)sender {
    NSDictionary *leftDic = self.dataArray[0];
    
    [self saveImageWithImageName:kMeUnNilStr(leftDic[@"wx_code"])];
}
- (IBAction)rightDownloadAction:(id)sender {
    NSDictionary *rightDic = self.dataArray[1];
    
    [self saveImageWithImageName:kMeUnNilStr(rightDic[@"wx_code"])];
}

- (void)saveImageWithImageName:(NSString *)image {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    __block BOOL isError = NO;
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image]];
        UIImage *img = [UIImage imageWithData:data];
        HUD.label.text = @"正在保存...";
        [library saveImage:img toAlbum:kMEAppName withCompletionBlock:^(NSError *error) {
            NSLog(@"%@",[error description]);
            if (!error) {
                dispatch_semaphore_signal(semaphore);
            }else{
                isError = YES;
                dispatch_semaphore_signal(semaphore);
            }
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            if(isError){
                [[[UIAlertView alloc]initWithTitle:@"无法保存" message:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的照片" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"图片已保存至您的手机相册并复制描述" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            }
        });
    });
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end

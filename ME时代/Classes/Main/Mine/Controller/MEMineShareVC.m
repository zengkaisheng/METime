//
//  MEMineShareVC.m
//  ME时代
//
//  Created by hank on 2018/9/26.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineShareVC.h"

@interface MEMineShareVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgHeight;
@property (strong, nonatomic) UIImage *imgShare;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@end

@implementation MEMineShareVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"推广二维码";
    _consTopMargin.constant = kMeNavBarHeight;
    _consImgHeight.constant = 250 * kMeFrameScaleX();
    _btnSave.hidden = YES;
    _imgPic.hidden = YES;
    kMeWEAKSELF
    [MEPublicNetWorkTool getUserGetCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        strongSelf.btnSave.hidden = NO;
        strongSelf.imgPic.hidden = NO;
        kSDLoadImg(strongSelf->_imgCode, kMeUnNilStr(responseObject.data));
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Public

- (IBAction)saveAction:(UIButton *)sender {
    [MECommonTool saveImg:[self getShareImage]];
}


#pragma mark - Private

- (UIImage *)getShareImage{
    if(!_imgShare){
        _btnSave.hidden = YES;
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _btnSave.hidden = NO;
        _imgShare = img;
    }
    return _imgShare;
}

#pragma mark - Getter
 
#pragma mark - Setter

@end

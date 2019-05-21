//
//  MECreatePosterVC.m
//  ME时代
//
//  Created by hank on 2018/11/30.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MECreatePosterVC.h"
#import "MEPosterModel.h"
#import "MEActivePosterModel.h"

@interface MECreatePosterVC (){
    MEPosterChildrenModel *_model;
    MEActivePosterModel *_activeModel;
    BOOL _isActive;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgR;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consBtnheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImgTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *imgposter;
@property (weak, nonatomic) IBOutlet UIImageView *imgCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *sContentView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consCodeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consCodeW;

@property (strong, nonatomic) UIImage *imgShare;
@end

@implementation MECreatePosterVC

#pragma mark - LifeCycle

- (instancetype)initWithActiveModel:(MEActivePosterModel *)model{
    if(self = [super init]){
        _activeModel = model;
        _isActive = YES;
    }
    return self;
}


- (instancetype)initWithModel:(MEPosterChildrenModel *)model{
    if(self = [super init]){
        _model = model;
        _isActive = NO;
    }
    return self;
}

- (void)viewDidLoad {
#pragma mark - 2.0.5
    [super viewDidLoad];
    _btnShare.hidden = YES;
    self.title = @"分享海报生成器";
    _backView.layer.shadowColor = kMEPink.CGColor;
    _backView.layer.shadowOpacity = 0.5;
    _backView.layer.shadowOffset = CGSizeMake(0, 10);
    if(IS_iPhoneX){
        _consImgTop.constant = (70 * kMeFrameScaleX()) + kMeNavBarHeight;
    }else{
        _consImgTop.constant = (35 * kMeFrameScaleX()) + kMeNavBarHeight;
    }
    CGFloat RLMargin = 66 * kMeFrameScaleX();
    _consImgR.constant = RLMargin;
    _consImgL.constant = RLMargin;
    CGFloat imgWdith = SCREEN_WIDTH - (RLMargin *2);
    _consImgHeight.constant = ((152 * imgWdith)/102);
    _consViewHeight.constant = 66 * kMeFrameScaleX();
    _consCodeH.constant = 47* kMeFrameScaleX();
    _consCodeW.constant = 47* kMeFrameScaleX();
    _consBtnheight.constant = 49 * kMeFrameScaleX();
    kMeWEAKSELF
    if(_isActive){
        [_imgposter sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(_activeModel.image)] placeholderImage:kImgPlaceholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            kMeSTRONGSELF
            strongSelf->_btnShare.hidden = NO;
        }];
    }else{
        [_imgposter sd_setImageWithURL:[NSURL URLWithString:kMeUnNilStr(_model.image)] placeholderImage:kImgPlaceholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            kMeSTRONGSELF
            strongSelf->_btnShare.hidden = NO;
        }];
    }
    kSDLoadImg(_imgHeader,kMeUnNilStr(kCurrentUser.header_pic));
    _lblName.text = kMeUnNilStr(kCurrentUser.name);
    NSString *str = @"";
    if(_isActive){
        str = [NSString stringWithFormat:@"http://md.meshidai.com/api/redbag_qrcode?uid=%@&pid=0&activity_id=%@",kMeUnNilStr(kCurrentUser.uid),kMeUnNilStr(_activeModel.activity_id)];
    }else{
        str = [NSString stringWithFormat:@"http://md.meshidai.com/api/qrcode?uid=%@&pid=0&posters_id=%@",kMeUnNilStr(kCurrentUser.uid),@(_model.idField)];
    }
    _imgCode.image = [UIImage getDataWithUrl:str];
    if([WXApi isWXAppInstalled]){
        [_btnShare setTitle:@"分享" forState:UIControlStateNormal];
    }else{
        [_btnShare setTitle:@"保存" forState:UIControlStateNormal];
    }
}

- (IBAction)shareAction:(UIButton *)sender {
    [self getShareImage];
    if([WXApi isWXAppInstalled]){
        MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
        shareTool.shareImage = self.imgShare;
        if(_isActive){
//            shareTool.posterId = kMeUnNilStr(_activeModel.activity_id);
        }else{
            shareTool.posterId = @(_model.idField).description;
        }
        [shareTool showShareView:kShareImageContentType success:^(id data) {
            NSLog(@"分享成功%@",data);
        } failure:^(NSError *error) {
            NSLog(@"分享失败");
        }];
    }else{
         [MECommonTool saveImg: self.imgShare];
    }
}

- (UIImage *)getShareImage{
    if(!_imgShare){
        CGRect rect = _backView.frame;
        _imgShare = [UIImage imageWithView:self.view frame:rect];
    }
    return _imgShare;
}




@end

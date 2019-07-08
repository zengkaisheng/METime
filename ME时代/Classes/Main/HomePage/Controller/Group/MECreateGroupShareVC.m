//
//  MECreateGroupShareVC.m
//  ME时代
//
//  Created by gao lei on 2019/7/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MECreateGroupShareVC.h"
#import "MEGoodDetailModel.h"

@interface MECreateGroupShareVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginCons;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) UIImage *imgShare;
@property (nonatomic, strong) MEGoodDetailModel *model;

@end

@implementation MECreateGroupShareVC

- (instancetype)initWithModel:(MEGoodDetailModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"分享";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#D6D6D6"];
    _topMarginCons.constant += kMeNavBarHeight;
    
    kSDLoadImg(_headerPic, kMeUnNilStr(kCurrentUser.header_pic));
    _nameLbl.text = kMeUnNilStr(kCurrentUser.name);
    
    [self addShadowToView:self.shadowView withColor:[UIColor blackColor]];
    
    [self setUpUI];
}

- (void)setUpUI {
    kSDLoadImg(_productImageView, kMeUnNilStr(self.model.image_url));
    _productNameLbl.text = kMeUnNilStr(self.model.title);
    _productPriceLbl.text = kMeUnNilStr(self.model.group_price);
    
}

- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 5;
}

- (IBAction)shareAction:(id)sender {
    [self getShareImage];
    if([WXApi isWXAppInstalled]){
        MEShareTool *shareTool = [MEShareTool me_instanceForTarget:self];
        shareTool.shareImage = self.imgShare;
        shareTool.posterId = @(_model.product_id).description;
        [shareTool showShareView:kShareImageContentType success:^(id data) {
            NSLog(@"分享成功%@",data);
        } failure:^(NSError *error) {
            NSLog(@"分享失败");
        }];
    }else{
        [MECommonTool saveImg:self.imgShare];
    }
}

- (IBAction)saveImageAction:(id)sender {
    [self getShareImage];
    [MECommonTool saveImg:self.imgShare];
}

- (UIImage *)getShareImage{
    if(!_imgShare){
//        CGRect rect = _shadowView.frame;
//        _imgShare = [UIImage imageWithView:self.view frame:rect];
        _imgShare = [self captureScrollView];
    }
    return _imgShare;
}

- (UIImage *)captureScrollView{
    UIGraphicsBeginImageContextWithOptions(self.shadowView.bounds.size, 0, [[UIScreen mainScreen] scale]);
    [self.shadowView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}


@end

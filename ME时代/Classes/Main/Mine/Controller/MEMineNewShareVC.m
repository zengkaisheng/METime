//
//  MEMineNewShareVC.m
//  ME时代
//
//  Created by hank on 2018/12/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEMineNewShareVC.h"
#import "MEMineNewShareView.h"

@interface MEMineNewShareVC ()<UIScrollViewDelegate>{
    CGFloat _allHeight;
    NSString *_lev;
    NSString *_codeStr;
    NSString *_bgImgStr;
}

@property (nonatomic, strong) MEMineNewShareView *cview;
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIButton *btnSave;
@end

@implementation MEMineNewShareVC

- (instancetype)initWithLevel:(NSString *)lev{
    if(self = [super init]){
//        _lev = lev;
        switch (kCurrentUser.client_type ) {
            case MEClientTypeClerkStyle:{
                _lev = [NSString stringWithFormat:@"当前等级:店员"];
            }
                break;
            case MEClientBTypeStyle:{
                _lev = [NSString stringWithFormat:@"当前等级:体验中心"];
            }
                break;
            case MEClientCTypeStyle:{
                _lev = [NSString stringWithFormat:@"当前等级:会员"];
            }
                break;
            case MEClientOneTypeStyle:{
                _lev = [NSString stringWithFormat:@"当前等级:售后中心"];
            }
                break;
            case MEClientTwoTypeStyle:{
                _lev = [NSString stringWithFormat:@"当前等级:营销中心"];
            }
                break;
            default:
                _lev = @"";
                break;
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"推广二维码";
    _allHeight = [MEMineNewShareView getViewHeight];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fbfbfb"];
    [self requestNetwork];
}

- (void)requestNetwork {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kMeCurrentWindow animated:YES];
    hud.label.text = @"获取二维码...";
    hud.userInteractionEnabled = YES;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //获取分类
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool getUserGetCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_codeStr = kMeUnNilStr(responseObject.data);
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
            kMeSTRONGSELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
    });
    dispatch_group_async(group, queue, ^{
        kMeWEAKSELF
        [MEPublicNetWorkTool getUserGetCodeBGImageWithSuccessBlock:^(ZLRequestResponse *responseObject) {
            kMeSTRONGSELF
            strongSelf->_bgImgStr = kMeUnNilStr(responseObject.data[@"img_url"]);
            dispatch_semaphore_signal(semaphore);
        } failure:^(id object) {
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    kMeWEAKSELF
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf.view addSubview:strongSelf.scrollerView];
            [strongSelf.view addSubview:strongSelf.btnSave];
            [strongSelf.scrollerView addSubview:strongSelf.cview];
            [strongSelf.cview setCode:strongSelf->_codeStr levStr:strongSelf->_lev bgImg:strongSelf->_bgImgStr];
        });
    });
}

- (UIScrollView *)scrollerView{
    if(!_scrollerView){
        _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kMeNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-k50WH)];
        _scrollerView.backgroundColor = [UIColor whiteColor];
        _scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, _allHeight);
        _scrollerView.bounces = YES;
        _scrollerView.showsVerticalScrollIndicator =NO;
        _scrollerView.delegate = self;
    }
    return _scrollerView;
}

- (MEMineNewShareView *)cview{
    if(!_cview){
        _cview = [[[NSBundle mainBundle]loadNibNamed:@"MEMineNewShareView" owner:nil options:nil] lastObject];
        _cview.frame = CGRectMake(0, 0, SCREEN_WIDTH, _allHeight);
    }
    return _cview;
}

- (UIButton *)btnSave{
    if(!_btnSave){
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(0, SCREEN_HEIGHT - k50WH, SCREEN_WIDTH, k50WH);
        [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnSave.backgroundColor = kMEPink;
        [_btnSave addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSave;
}

- (void)save:(UIButton *)btn{
    [MECommonTool saveImg:[self captureScrollView]];
}

- (UIImage *)captureScrollView{
    UIGraphicsBeginImageContextWithOptions(self.cview.bounds.size, 0, [[UIScreen mainScreen] scale]);
    [self.cview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}




@end

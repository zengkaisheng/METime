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
    kMeWEAKSELF
    [MEPublicNetWorkTool getUserGetCodeWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            kMeSTRONGSELF
            [strongSelf.view addSubview:strongSelf.scrollerView];
            [strongSelf.view addSubview:strongSelf.btnSave];
            [strongSelf.scrollerView addSubview:strongSelf.cview];
            [strongSelf.cview setCode:kMeUnNilStr(responseObject.data) levStr:strongSelf->_lev];
        });
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
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

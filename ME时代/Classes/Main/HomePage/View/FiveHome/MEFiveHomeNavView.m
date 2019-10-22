//
//  MEFiveHomeNavView.m
//  ME时代
//
//  Created by gao lei on 2019/10/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFiveHomeNavView.h"
#import "MEFiveHomeVC.h"
#import "MENoticeVC.h"
#import "MECoupleFilterVC.h"

@interface MEFiveHomeNavView (){
    CGFloat _top;
}

@property (nonatomic, strong)UIButton *btnNotice;
@property (nonatomic, strong)UIButton *btnSort;
@property (nonatomic, strong)UIView *viewForSearch;
@property (nonatomic, strong)UIImageView *imageForSearch;
@property (nonatomic, strong)UIView *viewForUnread;
@property (nonatomic, strong)UILabel *placeholderLbl;

@end

@implementation MEFiveHomeNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        [self addSubUIView];
    }
    return self;
}

- (void)addSubUIView{
    self.userInteractionEnabled = YES;
    _top = ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 49 : 25);
    [self addSubview:self.viewForSearch];
    [self.viewForSearch addSubview:self.imageForSearch];
    [self.viewForSearch addSubview:self.placeholderLbl];
    [self addSubview:self.btnNotice];
    [self addSubview:self.btnSort];
    [self addSubview:self.viewForUnread];
    self.viewForUnread.hidden = YES;
}

- (void)setRead:(BOOL)read{
    self.viewForUnread.hidden = read;
}
#pragma mark -- Action
- (void)searchProduct{
    kMeCallBlock(_searchBlock);
}

- (void)noticeAction:(UIButton*)btn{
    if([MEUserInfoModel isLogin]){
        [self toNotice];
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            [strongSelf toNotice];
        } failHandler:nil];
    }
}

- (void)sortAction:(UIButton*)btn{
    MEFiveHomeVC *homeVC = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
    if(homeVC){
        MECoupleFilterVC *svc = [[MECoupleFilterVC alloc]init];
        [homeVC.navigationController pushViewController:svc animated:YES];
    }
}

- (void)toNotice{
    MEFiveHomeVC *homeVC = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
    if(homeVC){
        MENoticeVC *svc = [[MENoticeVC alloc]init];
        [homeVC.navigationController pushViewController:svc animated:YES];
    }
}

#pragma mark ----Setter&&Getter
- (UIView *)viewForUnread{
    if(!_viewForUnread){
        _viewForUnread = [[UIView alloc]initWithFrame:CGRectMake(self.btnNotice.right-12, self.btnNotice.top+5,6, 6)];
        _viewForUnread.backgroundColor = [UIColor redColor];
        _viewForUnread.cornerRadius = 3;
        _viewForUnread.clipsToBounds = YES;
    }
    return _viewForUnread;
}

- (UIView *)viewForSearch{
    if(!_viewForSearch){
        _viewForSearch = [[UIView alloc]initWithFrame:CGRectMake(10+32+10, _top, self.width-104, 32)];
        _viewForSearch.backgroundColor = [UIColor whiteColor];
        _viewForSearch.cornerRadius = 32/2;
        _viewForSearch.clipsToBounds = YES;
        UITapGestureRecognizer *search = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchProduct)];
        _viewForSearch.userInteractionEnabled = YES;
        [_viewForSearch addGestureRecognizer:search];
    }
    return _viewForSearch;
}


- (UIButton *)btnSort{
    if(!_btnSort){
        _btnSort = [MEView btnWithFrame:CGRectMake(self.viewForSearch.right+10, self.viewForSearch.top, 32, 32) Img:[UIImage imageNamed:@"fourHomeSort"]];
        [_btnSort addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSort;
}

- (UIButton *)btnNotice{
    if(!_btnNotice){
        _btnNotice = [MEView btnWithFrame:CGRectMake(10, self.viewForSearch.top, 32, 32) Img:[UIImage imageNamed:@"thirdHomeNotice"]];
        [_btnNotice addTarget:self action:@selector(noticeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNotice;
}

- (UIImageView *)imageForSearch{
    if(!_imageForSearch){
        _imageForSearch = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchHome"]];
        _imageForSearch.contentMode = UIViewContentModeScaleAspectFit;
        _imageForSearch.frame = CGRectMake(10, 9.5, 16, 16);
    }
    return _imageForSearch;
}

- (UILabel *)placeholderLbl {
    if (!_placeholderLbl) {
        _placeholderLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 9.5, self.width - 104 - 30, 16)];
        _placeholderLbl.text = @"搜索商品名或粘贴淘宝标题";
        _placeholderLbl.textColor = kME999999;
        _placeholderLbl.font = [UIFont systemFontOfSize:14];
    }
    return _placeholderLbl;
}

@end

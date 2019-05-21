//
//  METhridHomeNavView.m
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridHomeNavView.h"
#import "METhridHomeVC.h"
#import "MEProductSearchVC.h"
#import "MERCConversationListVC.h"
//#import "MENoticeTypeVC.h"
#import "MENoticeVC.h"
#import "MEFilterVC.h"
#import "MEStoreModel.h"
#import "MECoupleFilterVC.h"

@interface METhridHomeNavView ()<JXCategoryViewDelegate>{
    CGFloat _top;
    CGFloat _touchArea;
}

//@property (nonatomic, strong)UIView *viewForBack;
@property (nonatomic, strong)UIButton *btnNotice;
@property (nonatomic, strong)UIButton *btnSort;
@property (nonatomic, strong)UIView *viewForSearch;
@property (nonatomic, strong)UIImageView *imageForSearch;
@property (nonatomic, strong)UIView *viewForUnread;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;

//@property (nonatomic, strong)UIView *viewForStore;
//
//@property (nonatomic, strong)UIImageView *imgStore;
//@property (nonatomic, strong)UILabel *lblStoreName;
@end

@implementation METhridHomeNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = NO;
        [self addSubUIView];
    }
    return self;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    if(point.y <_touchArea){
//        return YES;
//    }else{
//        return NO;
//    }
//}

- (void)addSubUIView{
    self.userInteractionEnabled = YES;
    //22
    _top = ((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 49 : 25);
//    _touchArea = kMEThridHomeNavViewHeight-(k5Margin*4)-kImgStore;
//    [self addSubview:self.viewForBack];
    [self addSubview:self.viewForSearch];
    [self.viewForSearch addSubview:self.imageForSearch];
    [self addSubview:self.btnNotice];
    [self addSubview:self.btnSort];
    [self addSubview:self.viewForUnread];
//    [self addSubview:self.viewForStore];
    self.viewForUnread.hidden = YES;
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,self.viewForSearch.bottom, SCREEN_WIDTH, kHomeCategoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor =  [UIColor whiteColor];
    lineView.indicatorLineViewHeight = 1;

    self.categoryView.indicators = @[lineView];

    self.categoryView.titles = @[@"精选",@"特卖",@"猜你喜欢",@"女装",@"美妆",@"母婴"];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.categoryView.titleColor =  [UIColor whiteColor];
    self.categoryView.defaultSelectedIndex = 0;
    [self addSubview:self.categoryView];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectIndexBlock,index);
}

- (void)setRead:(BOOL)read{
    self.viewForUnread.hidden = read;
}

- (void)searchProduct{
    kMeCallBlock(_searchBlock);
//    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
//    if(homeVC){
//        MEProductSearchVC *svc = [[MEProductSearchVC alloc]init];
//        [homeVC.navigationController pushViewController:svc animated:NO];
//    }
}

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
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homeVC){
        MECoupleFilterVC *svc = [[MECoupleFilterVC alloc]init];
        [homeVC.navigationController pushViewController:svc animated:YES];
    }
}

- (void)toNotice{
    METhridHomeVC *homeVC = (METhridHomeVC *)[MECommonTool getVCWithClassWtihClassName:[METhridHomeVC class] targetResponderView:self];
    if(homeVC){
        MENoticeVC *svc = [[MENoticeVC alloc]init];
        [homeVC.navigationController pushViewController:svc animated:YES];
    }
}

- (UIImageView *)imageForSearch{
    if(!_imageForSearch){
        _imageForSearch = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchHome"]];
        _imageForSearch.contentMode = UIViewContentModeScaleAspectFit;
        _imageForSearch.frame = CGRectMake(10, 9.5, 16, 16);
    }
    return _imageForSearch;
}



@end

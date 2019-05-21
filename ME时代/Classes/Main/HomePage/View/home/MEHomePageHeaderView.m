//
//  MEHomePageHeaderView.m
//  ME时代
//
//  Created by hank on 2018/9/6.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEHomePageHeaderView.h"
#import "MEAdModel.h"
#import "MEHomePageVC.h"
#import "MEProductDetailsVC.h"
#import "MEActiveVC.h"
#import "MEVActiveListVC.h"

@interface MEHomePageHeaderView()<SDCycleScrollViewDelegate>{
    NSArray *_arrModel;
}

@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong) MEHomeHeaderMenuView *menuView;
//@property(nonatomic,strong) UIImageView *rimgPic;
//@property(nonatomic,strong) UIImageView *limgPic;
@property(nonatomic,strong) UILabel *lblTitle;
@property(nonatomic,strong) UIImageView *imgPic;
@property(nonatomic,strong) MEHomeSearchView *searchView;

@end

@implementation MEHomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
        self.cycleScrollView.clipsToBounds = YES;
        [self addSubview:self.searchView];
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.lblTitle];
//        [self addSubview:self.limgPic];
//        [self addSubview:self.rimgPic];
         [self addSubview:self.imgPic];
    }
    return self;
}

- (void)setArrModel:(NSArray *)arrModel{
    _arrModel = arrModel;
    _cycleScrollView.height = 255*kMeFrameScaleY();
    __block NSMutableArray *arrImage = [NSMutableArray array];
    [arrModel enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    self.cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
    self.cycleScrollView.clipsToBounds = YES;
    self.cycleScrollView.imageURLStringsGroup = arrImage;
}

- (void)ltapActionAction:(UITapGestureRecognizer *)ges{

    MEHomePageVC *home = (MEHomePageVC *)[MECommonTool getVCWithClassWtihClassName:[MEHomePageVC class] targetResponderView:self];
    if(home){
        MEVActiveListVC *vc = [[MEVActiveListVC alloc]init];
        [home.navigationController pushViewController:vc animated:YES];
    }
}

- (void)rtapActionAction:(UITapGestureRecognizer *)ges{
    if([MEUserInfoModel isLogin]){
        MEHomePageVC *home = (MEHomePageVC *)[MECommonTool getVCWithClassWtihClassName:[MEHomePageVC class] targetResponderView:self];
        if(home){
            MEActiveVC *avc = [[MEActiveVC alloc]init];
            [home.navigationController pushViewController:avc animated:YES];
        }
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            MEHomePageVC *home = (MEHomePageVC *)[MECommonTool getVCWithClassWtihClassName:[MEHomePageVC class] targetResponderView:strongSelf];
            if(home){
                MEActiveVC *avc = [[MEActiveVC alloc]init];
                [home.navigationController pushViewController:avc animated:YES];
            }
        } failHandler:nil];
    }
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    MEAdModel *model = kMeUnArr(_arrModel)[index];
    MEHomePageVC *homeVC = (MEHomePageVC *)[MECommonTool getVCWithClassWtihClassName:[MEHomePageVC class] targetResponderView:self];
    if(homeVC){
        MEProductDetailsVC *dvc = [[MEProductDetailsVC alloc]initWithId:model.product_id];
        [homeVC.navigationController pushViewController:dvc animated:YES];
    }
}

- (SDCycleScrollView *)cycleScrollView{
    if(!_cycleScrollView){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, kMEHomeSearchViewHeight, SCREEN_WIDTH, 255*kMeFrameScaleY()) imageURLStringsGroup:nil];
        _cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.autoScrollTimeInterval = 4;
        _cycleScrollView.delegate =self;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.placeholderImage = kImgBannerPlaceholder;
        _cycleScrollView.currentPageDotColor = kMEPink;
    }
    return _cycleScrollView;
}

- (void)tapActionAction:(UITapGestureRecognizer *)ges{
    if([MEUserInfoModel isLogin]){
        MEHomePageVC *home = (MEHomePageVC *)[MECommonTool getVCWithClassWtihClassName:[MEHomePageVC class] targetResponderView:self];
        if(home){
            MEActiveVC *avc = [[MEActiveVC alloc]init];
            [home.navigationController pushViewController:avc animated:YES];
        }
    }else{
        kMeWEAKSELF
        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
            kMeSTRONGSELF
            MEHomePageVC *home = (MEHomePageVC *)[MECommonTool getVCWithClassWtihClassName:[MEHomePageVC class] targetResponderView:strongSelf];
            if(home){
                MEActiveVC *avc = [[MEActiveVC alloc]init];
                [home.navigationController pushViewController:avc animated:YES];
            }
        } failHandler:nil];
    }
    
}

//- (MEHomeHeaderMenuView *)menuView{
//    if(!_menuView){
//        _menuView = [[[NSBundle mainBundle]loadNibNamed:@"MEHomeHeaderMenuView" owner:nil options:nil] lastObject];
//        _menuView.frame = CGRectMake(0, 254*kMeFrameScaleY(), SCREEN_WIDTH, kMEHomeHeaderMenuViewHeight);
//    }
//    return _menuView;
//}

//- (UIImageView *)limgPic{
//    if(!_limgPic){
//        _limgPic = [[UIImageView alloc]initWithFrame:CGRectMake(k15Margin, 254*kMeFrameScaleY() + 48, (SCREEN_WIDTH - (k15Margin *3))/2, kMEHomeHeaderMenuViewHeight)];
////        _limgPic.image = [UIImage imageNamed:@"lwrtltu"];
////        kSDLoadImg(_limgPic, <#url#>)
//        [_limgPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"ccfghgitfcfnaq"]];
//        _limgPic.contentMode = UIViewContentModeScaleAspectFill;
//        _limgPic.layer.cornerRadius = 5;
//        _limgPic.clipsToBounds = YES;
//        _limgPic.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ltapActionAction:)];
//        [_limgPic addGestureRecognizer:tap];
//    }
//    return _limgPic;
//}
//
//- (UIImageView *)rimgPic{
//    if(!_rimgPic){
//        _rimgPic = [[UIImageView alloc]initWithFrame:CGRectMake(self.limgPic.right + k15Margin, 254*kMeFrameScaleY() + 48, (SCREEN_WIDTH - (k15Margin *3))/2, kMEHomeHeaderMenuViewHeight)];
//        _rimgPic.contentMode = UIViewContentModeScaleAspectFill;
////        _rimgPic.image = [UIImage imageNamed:@"lwrtltu"];
//        [_rimgPic sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"980itfcfnaq"]];
//        _rimgPic.layer.cornerRadius = 5;
//        _rimgPic.clipsToBounds = YES;
//        _rimgPic.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rtapActionAction:)];
//        [_rimgPic addGestureRecognizer:tap];
//    }
//    return _rimgPic;
//}

- (UILabel *)lblTitle{
    if(!_lblTitle){
        _lblTitle = [MEView lblWithFram:CGRectMake(k15Margin, 254*kMeFrameScaleY()+k15Margin+kMEHomeSearchViewHeight, SCREEN_WIDTH-(k15Margin*2), 18) textColor:kMEblack str:@"980活动" font:[UIFont systemFontOfSize:15]];
    }
    return _lblTitle;
}

- (UIImageView *)imgPic{
    if(!_imgPic){
        _imgPic = [[UIImageView alloc]initWithFrame:CGRectMake(k15Margin, 254*kMeFrameScaleY() + 48+kMEHomeSearchViewHeight, SCREEN_WIDTH - (k15Margin *2), kMEHomeHeaderMenuViewHeight)];
        _imgPic.image = [UIImage imageNamed:@"lwrtltu"];
        _imgPic.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionAction:)];
        [_imgPic addGestureRecognizer:tap];
    }
    return _imgPic;
}

- (MEHomeSearchView *)searchView{
    if(!_searchView){
        _searchView = [[[NSBundle mainBundle]loadNibNamed:@"MEHomeSearchView" owner:nil options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMEHomeSearchViewHeight);
        kMeWEAKSELF
        _searchView.searchBlock = ^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf->_searchBlock);
        };
        _searchView.filetBlock = ^{
            kMeSTRONGSELF
            kMeCallBlock(strongSelf->_filetBlock);
        };
    }
    return _searchView;
}


@end

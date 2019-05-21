//
//  MEBrandManngerVC.m
//  ME时代
//
//  Created by hank on 2019/3/8.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandManngerVC.h"
#import "MEBrandManngerAllContentVC.h"
#import "MEBrandAISortVC.h"
#import "MEBrandMangerSortVC.h"
#import "MEBrandManngerAllModel.h"

@interface MEBrandManngerVC ()<UIScrollViewDelegate>{
    // 0 all 1 sort 2ai
    NSInteger _selectIndex;
    UIButton *_selectBtn;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong , nonatomic) MEBrandManngerAllContentVC *allVC;
@property (strong , nonatomic) MEBrandMangerSortVC *sortVC;
@property (strong , nonatomic) MEBrandAISortVC *aiSortVC;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIButton *btnSort;
@property (weak, nonatomic) IBOutlet UIButton *btnAi;
@property (weak, nonatomic) IBOutlet UIView *viewForBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;
@property (weak, nonatomic) IBOutlet UIView *viewForCor;

@end

@implementation MEBrandManngerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌管理";
    _lblStoreCount.text =@"账号数量:0";
    _lblName.text = kMeUnNilStr(kCurrentUser.name);
    kSDLoadImg(_imgPic, kMeUnNilStr(kCurrentUser.header_pic));
    _selectBtn = _btnAll;
    _selectIndex = 0;
    _consTopMargin.constant = kMeNavBarHeight;
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandManngerVCHeaderHeight);
    _scrollview.pagingEnabled = YES;
    [_scrollview addSubview:self.allVC.view];
    [_scrollview addSubview:self.sortVC.view];
    [_scrollview addSubview:self.aiSortVC.view];
    
    
    [_btnAll setBackgroundImage:[MECommonTool createImageWithColor:kMEPink] forState:UIControlStateSelected];
    [_btnSort setBackgroundImage:[MECommonTool createImageWithColor:kMEPink] forState:UIControlStateSelected];
    [_btnAi setBackgroundImage:[MECommonTool createImageWithColor:kMEPink] forState:UIControlStateSelected];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-15, 0, SCREEN_WIDTH+30, 89) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(60, 60)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = _viewForCor.bounds;
//    maskLayer.path = maskPath.CGPath;
//    _viewForCor.layer.mask = maskLayer;
}

- (IBAction)tapSelectAction:(UIButton *)sender {
    [self selectBtnWithBtn:sender];
}

- (void)selectBtnWithBtn:(UIButton *)btn{
    if(_selectBtn == btn){
        return;
    }
    _selectBtn.selected = NO;
    btn.selected = YES;
    _selectBtn = btn;
    _selectIndex = btn.tag-kMeViewBaseTag;
    [self.scrollview setContentOffset:CGPointMake(_selectIndex*SCREEN_WIDTH, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float sub = scrollView.contentOffset.x/SCREEN_WIDTH;
    UIButton * btn = (UIButton * )[_viewForBtn viewWithTag:kMeViewBaseTag+sub];
    if(btn && _selectBtn != btn){
        _selectBtn.selected = NO;
        btn.selected = YES;
        _selectBtn = btn;
        _selectIndex = btn.tag-kMeViewBaseTag;
    }
}

- (MEBrandManngerAllContentVC *)allVC{
    if(!_allVC){
        _allVC = [[MEBrandManngerAllContentVC alloc]init];
        _allVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _allVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandManngerVCHeaderHeight);
        kMeWEAKSELF
        _allVC.modelBlock = ^(MEBrandMemberInfo *model) {
            kMeSTRONGSELF
            strongSelf.lblStoreCount.text = [NSString stringWithFormat:@"账号数量:%@",kMeUnNilStr(model.store_count)];
            strongSelf.lblName.text = kMeUnNilStr(model.store_name);
            kSDLoadImg(strongSelf.imgPic, kMeUnNilStr(model.header_pic));
        };
        [self addChildViewController:_allVC];
    }
    return _allVC;
}

- (MEBrandMangerSortVC *)sortVC{
    if(!_sortVC){
        _sortVC = [[MEBrandMangerSortVC alloc]init];
        _sortVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _sortVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandManngerVCHeaderHeight);
        [self addChildViewController:_sortVC];
    }
    return _sortVC;
}

- (MEBrandAISortVC *)aiSortVC{
    if(!_aiSortVC){
        _aiSortVC = [[MEBrandAISortVC alloc]init];
        _aiSortVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _aiSortVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandManngerVCHeaderHeight);
        [self addChildViewController:_aiSortVC];
    }
    return _aiSortVC;
}

@end

//
//  MEBrandAbilityManngerVC.m
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEBrandAbilityManngerVC.h"
#import "MEBrandAbilityDataVC.h"
#import "MEBrandAbilityVisterVC.h"
#import "MEBrandAbilityAnalysisVC.h"
#import "MEBrandAISortModel.h"

@interface MEBrandAbilityManngerVC (){
    //0 能力 1数据 2来访
    NSInteger _selectIndex;
    UIButton *_selectBtn;
    MEBrandAISortModel *_model;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMargin;
@property (weak, nonatomic) IBOutlet UIButton *btnAblity;
@property (weak, nonatomic) IBOutlet UIButton *btnData;
@property (weak, nonatomic) IBOutlet UIButton *btnVister;
@property (weak, nonatomic) IBOutlet UIView *viewForBtn;
@property (weak, nonatomic) IBOutlet UIView *viewForLine;
@property (strong , nonatomic) MEBrandAbilityDataVC *dataVC;
@property (strong , nonatomic) MEBrandAbilityVisterVC *visterVC;
@property (strong , nonatomic) MEBrandAbilityAnalysisVC *analysisVC;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@end

@implementation MEBrandAbilityManngerVC

- (instancetype)initWithModel:(MEBrandAISortModel *)model{
    if(self = [super init]){
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"能力模型";
    _lblName.text = kMeUnNilStr(_model.store_name);
    kSDLoadImg(_imgPic, kMeUnNilStr(_model.header_pic));
    _selectBtn = _btnAblity;
    _selectIndex = 0;
    _consTopMargin.constant = kMeNavBarHeight;
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandAbilityManngerVCHeight);
    _scrollview.pagingEnabled = YES;
    [_scrollview addSubview:self.analysisVC.view];
    [_scrollview addSubview:self.dataVC.view];
    [_scrollview addSubview:self.visterVC.view];
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
    _viewForLine.centerX = btn.centerX;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float sub = scrollView.contentOffset.x/SCREEN_WIDTH;
    UIButton * btn = (UIButton * )[_viewForBtn viewWithTag:kMeViewBaseTag+sub];
    if(btn && _selectBtn != btn){
        _selectBtn.selected = NO;
        btn.selected = YES;
        _selectBtn = btn;
        _selectIndex = btn.tag-kMeViewBaseTag;
        _viewForLine.centerX = btn.centerX;
    }
}

- (MEBrandAbilityDataVC *)dataVC{
    if(!_dataVC){
        _dataVC = [[MEBrandAbilityDataVC alloc]initWithModel:_model];
        _dataVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _dataVC.view.frame = CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandAbilityManngerVCHeight);
        [self addChildViewController:_dataVC];
    }
    return _dataVC;
}

- (MEBrandAbilityVisterVC *)visterVC{
    if(!_visterVC){
        _visterVC = [[MEBrandAbilityVisterVC alloc]initWithModel:_model];
        _visterVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _visterVC.view.frame = CGRectMake(SCREEN_WIDTH*2,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandAbilityManngerVCHeight);
        [self addChildViewController:_visterVC];
    }
    return _visterVC;
}

- (MEBrandAbilityAnalysisVC *)analysisVC{
    if(!_analysisVC){
        _analysisVC = [[MEBrandAbilityAnalysisVC alloc]initWithModel:_model];
        _analysisVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _analysisVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-kMEBrandAbilityManngerVCHeight);
        [self addChildViewController:_analysisVC];
    }
    return _analysisVC;
}

@end

//
//  MESNewHomePageView.m
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MESNewHomePageView.h"
#import "MESActivityContentModel.h"
#import "LMJScrollTextView2.h"
#import "MEAdvModel.h"

@interface MESNewHomePageView ()<SDCycleScrollViewDelegate,LMJScrollTextView2Delegate>{
//    id _model;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consFCellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consFCellWdith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTopMagrin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTCellHeight;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conslblBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consOCellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consAdvHeight;

//3个top
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consVMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consFMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNoticeTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consVisterTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consNoticeBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consVisterBottomMargin;
@property (weak, nonatomic) IBOutlet LMJScrollTextView2 *vIewForAdv;

@end

@implementation MESNewHomePageView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consImageHeight.constant = (SCREEN_WIDTH * 1334)/750;
    _consTopMagrin.constant = 224 * kMeFrameScaleX();
    _consOCellHeight.constant = 90*kMeFrameScaleY();
    
    _consNoticeTopMargin.constant = 24 *kMeFrameScaleY();
    _consVisterTopMargin.constant = 24 *kMeFrameScaleY();
    _consNoticeBottomMargin.constant = 10 *kMeFrameScaleY();
    _consVisterBottomMargin.constant = 10 *kMeFrameScaleY();
    
    //4image的左右宽度相加
    CGFloat k4ImageMargin = 8.25+8.25+3.5;//8.5+8.5+6;
    CGFloat kMargin = 12;
    CGFloat scellWdith = ((SCREEN_WIDTH - (k4ImageMargin))/2);
    //4个image 的height 340 224
    _consFCellHeight.constant = (scellWdith * 224)/340;
    _consFCellWdith.constant = scellWdith;
    _consAdvHeight.constant = 48 *kMeFrameScaleX();
    CGFloat tcellWdith = SCREEN_WIDTH - (kMargin * 2);
    //轮播的height
    _consTCellHeight.constant = (tcellWdith * 90)/351;
    _conslblBottomMargin.constant = - (30 * kMeFrameScaleX());
    
    //CGFloat kMarginS = 6 ;//* kMeFrameScaleX();
    _consFMargin.constant = 10-3.75;//kMarginS;
    _consSMargin.constant = 2.5;//kMarginS;
    _consTMargin.constant = 10-3.75;//kMarginS;
    _consVMargin.constant = 2.5;
    _lblPoster.adjustsFontSizeToFitWidth = YES;
    _lblArticle.adjustsFontSizeToFitWidth = YES;
    _sdView.contentMode = UIViewContentModeScaleToFill;
    _sdView.clipsToBounds = YES;
    _sdView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
    _sdView.autoScrollTimeInterval = 4;
    _sdView.delegate =self;
    _sdView.backgroundColor = [UIColor clearColor];
    _sdView.placeholderImage = kImgBannerPlaceholder;
    _sdView.currentPageDotColor = kMEPink;
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    
    
    _vIewForAdv.delegate            = self;
    _vIewForAdv.textStayTime        = 2;
    _vIewForAdv.scrollAnimationTime = 1;
    _vIewForAdv.textColor           = [UIColor colorWithHexString:@"0088fe"];
    _vIewForAdv.textFont            = kMeFont(11);
    _vIewForAdv.touchEnable         = YES;
    
}

- (void)setSdViewWithArr:(NSArray *)array{
    if(kMeUnArr(array)){
        NSMutableArray *arrUrl = [NSMutableArray array];
        for (MESActivityContentModel *model in array) {
            [arrUrl addObject:kMeUnNilStr(model.img)];
        }
        _sdView.imageURLStringsGroup = arrUrl;
    }
}

- (void)setAdWithArr:(NSArray *)arr{
    if(kMeUnArr(arr)){
        NSMutableArray *arrTitle = [NSMutableArray array];
        for (NSInteger i=0; i<arr.count; i++) {
            MEAdvModel *model = arr[i];
            [arrTitle addObject:kMeUnNilStr(model.title)];
        }
        _vIewForAdv.textDataArr = arrTitle;
        [_vIewForAdv startScrollBottomToTopWithNoSpace];
    }
}

- (IBAction)visterAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(toVisterVC)]) {
        [_deleate toVisterVC];
    }
}

- (IBAction)noticeAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(toNoticeVC)]) {
        [_deleate toNoticeVC];
    }
}

- (IBAction)productAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(toProdectVC)]) {
        [_deleate toProdectVC];
    }
}

- (IBAction)serviceAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(toServiceVC)]) {
        [_deleate toServiceVC];
    }
}
- (IBAction)posterNewAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(toPosterVC)]) {
        [_deleate toPosterVC];
    }
}

- (IBAction)articelNewAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(toArticelVC)]) {
        [_deleate toArticelVC];
    }
}


- (IBAction)posterAction:(UIButton *)sender {
    //couple
    if ([_deleate respondsToSelector:@selector(toCoupleVC)]) {
        [_deleate toCoupleVC];
    }
}

- (IBAction)articelAction:(UIButton *)sender {
    //gift
    if ([_deleate respondsToSelector:@selector(toGiftVC)]) {
        [_deleate toGiftVC];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if ([_deleate respondsToSelector:@selector(didSdSelectItemAtIndex:)]) {
        [_deleate didSdSelectItemAtIndex:index];
    }
}

- (void)scrollTextView2:(LMJScrollTextView2 *)scrollTextView clickIndex:(NSInteger)index content:(NSString *)content{
    if ([_deleate respondsToSelector:@selector(didAdvdSelectItemAtIndex:)]) {
        [_deleate didAdvdSelectItemAtIndex:index];
    }
}

- (IBAction)bcakgroundTapAction:(UIButton *)sender {
    if ([_deleate respondsToSelector:@selector(tapBackGround)]) {
        [_deleate tapBackGround];
    }
}


+ (CGFloat)getViewHeight{
    CGFloat height = 0;
    //top margin 4个top相加,2个有阴影
    CGFloat kMarginS = 25+2.5;//30;//*kMeFrameScaleX();
    CGFloat kMargin = 12;
    //top margin
    CGFloat topMargin = 224 * kMeFrameScaleX();
    // 第一个view高度
    CGFloat fcellHeight = 90*kMeFrameScaleY();
    // 第二个view的高度
    CGFloat advHeight = 48 *kMeFrameScaleX();
    //  4image的左右宽度相加
    CGFloat k4ImageMargin = 8.25+8.25+3.5;//8.5+8.5+6;
    CGFloat scellWdith = ((SCREEN_WIDTH - (k4ImageMargin))/2);
    //4个image的高度 的height 340 224
    CGFloat scellHeight = (scellWdith * 224)/340;
    
    
    ///轮播的w
    CGFloat tcellWdith = SCREEN_WIDTH - (kMargin * 2);
    //轮播的高度
    CGFloat tcellHeight =  (tcellWdith * 90)/351;
    height = topMargin + advHeight+fcellHeight+(scellHeight * 3)+tcellHeight+(kMarginS);
//    if(height<(SCREEN_HEIGHT)){
//        height = (SCREEN_HEIGHT);
//    }
//    if(height<imageBackgroundHeight){
//        height = imageBackgroundHeight;
//    }
    return height;
}

@end

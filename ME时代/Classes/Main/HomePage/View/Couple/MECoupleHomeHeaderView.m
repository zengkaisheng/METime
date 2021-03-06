//
//  MECoupleHomeHeaderView.m
//  志愿星
//
//  Created by hank on 2019/1/3.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MECoupleHomeHeaderView.h"
#import "MECoupleHomeVC.h"
#import "MECoupleMailVC.h"
#import "MECoupleFilterVC.h"
#import "MEAdModel.h"
#import "MECoupleMailVC.h"
#import "MEPinduoduoCouponSearchDataVC.h"
#import "MEFourCouponSearchHomeVC.h"

@interface MECoupleHomeHeaderView ()<SDCycleScrollViewDelegate>{
    NSArray *_Model;
    BOOL _isTbk;
}

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSdViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consImageH;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *arrImag;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arrBtn;


@end

@implementation MECoupleHomeHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = kMEf5f4f4;
    _consSdViewHeight.constant = 150 *kMeFrameScaleX();
    [self initSD];
    CGFloat imageW = (SCREEN_WIDTH - 12)/2;
    CGFloat imageH = (imageW * 178)/364;
    _consImageH.constant = imageH;
    [self layoutIfNeeded];
}

- (void)setUiWithModel:(NSArray *)Model isTKb:(BOOL)isTbk{
    _Model = Model;
    _isTbk = isTbk;
    if(!_isTbk){
        [_arrImag enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        [_arrBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    }
    __block NSMutableArray *arrImage =[NSMutableArray array];
    [_Model enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrImage addObject:kMeUnNilStr(model.ad_img)];
    }];
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    _sdView.imageURLStringsGroup = arrImage;
    
    if (Model.count <= 0) {
        _sdView.hidden = YES;
        _consSdViewHeight.constant = 0;
    }else {
        _sdView.hidden = NO;
        _consSdViewHeight.constant = 150*kMeFrameScaleY();
    }
}

- (void)initSD{
    _sdView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdView.pageControlStyle =SDCycleScrollViewPageContolStyleClassic;
    _sdView.autoScrollTimeInterval = 4;
    _sdView.delegate =self;
    _sdView.backgroundColor = [UIColor clearColor];
    _sdView.placeholderImage = kImgBannerPlaceholder;
    _sdView.currentPageDotColor = kMEPink;
}


//人气爆款
- (IBAction)haoJuanAction:(UIButton *)sender {
    MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchGoodGoodsType];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}
//特惠
- (IBAction)topBuyAction:(UIButton *)sender {
    MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchTeHuiType];
        [homevc.navigationController pushViewController:vc animated:YES];
    }

}
//时尚
- (IBAction)shishangAction:(UIButton *)sender {
    MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithType:MECouponSearchShiShangType];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}
//好券分类
- (IBAction)teHuiAction:(UIButton *)sender {
    MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
    if(homevc){
        MECoupleFilterVC *vc = [[MECoupleFilterVC alloc]init];
        [homevc.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if(index>_Model.count){
        return;
    }
    MECoupleHomeVC *homevc = [MECommonTool getVCWithClassWtihClassName:[MECoupleHomeVC class] targetResponderView:self];
    if(homevc){
        MEAdModel *model = _Model[index];
        
        if (model.is_need_login == 1) {
            if(![MEUserInfoModel isLogin]){
                kMeWEAKSELF
                [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
                    kMeSTRONGSELF
                    [strongSelf cycleScrollView:strongSelf->_sdView didSelectItemAtIndex:index];
                } failHandler:^(id object) {
                    return;
                }];
                return;
            }
        }
        
        NSDate *date = [[NSDate alloc] init];
        NSDictionary *params = @{@"type":@(model.type), @"show_type":@(model.show_type), @"ad_id":kMeUnNilStr(model.ad_id), @"product_id":@(model.product_id), @"keywork":kMeUnNilStr(model.keywork),@"created_at":[date getNowDateFormatterString]};
        NSString *paramsStr = [NSString convertToJsonData:params];
        NSMutableArray *records = [[NSMutableArray alloc] init];
        if ([kMeUserDefaults objectForKey:kMEGetClickRecord]) {
            [records addObjectsFromArray:(NSArray *)[kMeUserDefaults objectForKey:kMEGetClickRecord]];
        }
        
        [records addObject:@{@"type":@"1",@"parameter":paramsStr}];
        [kMeUserDefaults setObject:records forKey:kMEGetClickRecord];
        [kMeUserDefaults synchronize];
        
        if (kMeUnNilStr(model.keywork).length > 0) {
            if (_isTbk) {
                MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] init];
                searchHomeVC.keyWords = model.keywork;
                searchHomeVC.recordType = 5;
                [homevc.navigationController pushViewController:searchHomeVC animated:YES];
            }else {
                MEFourCouponSearchHomeVC *searchHomeVC = [[MEFourCouponSearchHomeVC alloc] initWithIndex:1];
                searchHomeVC.keyWords = model.keywork;
                searchHomeVC.recordType = 5;
                [homevc.navigationController pushViewController:searchHomeVC animated:YES];
            }
        }
//        if(_isTbk){
//            MECoupleMailVC *vc = [[MECoupleMailVC alloc]initWithQuery:kMeUnNilStr(model.keywork)];
//            [homevc.navigationController pushViewController:vc animated:YES];
//        }else{
//            MEPinduoduoCouponSearchDataVC *vc = [[MEPinduoduoCouponSearchDataVC alloc]initWithQuery:kMeUnNilStr(model.keywork)];
//            [homevc.navigationController pushViewController:vc animated:YES];
//        }
    }
}

+ (CGFloat)getViewHeightWithisTKb:(BOOL)isTbk{
    if(isTbk){
        CGFloat height = 0;
        CGFloat sdHeight = 150 *kMeFrameScaleX();
        CGFloat imageW = (SCREEN_WIDTH - 12)/2;
        CGFloat imageH = (imageW * 178)/364;
        height = sdHeight + (imageH*2) +8;
        return height;
    }else{
        return 150 *kMeFrameScaleX();;
    }

}

+ (CGFloat)getViewHeightWithisTKb:(BOOL)isTbk hasSdView:(BOOL)hasSdView {
    if(isTbk){
        CGFloat height = 0;
        CGFloat sdHeight = (hasSdView?1:0.05)*150 *kMeFrameScaleX();
        CGFloat imageW = (SCREEN_WIDTH - 12)/2;
        CGFloat imageH = (imageW * 178)/364;
        height = sdHeight + (imageH*2) +8;
        return height;
    }else{
        return 150 *kMeFrameScaleX();;
    }
}



@end

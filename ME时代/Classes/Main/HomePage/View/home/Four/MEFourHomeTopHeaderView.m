//
//  MEFourHomeTopHeaderView.m
//  志愿星
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeTopHeaderView.h"
#import "MEHomeRecommendAndSpreebuyModel.h"
#import "METhridProductDetailsVC.h"
//#import "METhridHomeVC.h"
#import "MEFourHomeVC.h"
#import "METhridHomeModel.h"
#import "MEFiveHomeVC.h"

@interface MEFourHomeTopHeaderView ()<SDCycleScrollViewDelegate> {
    MEHomeRecommendAndSpreebuyModel *_model;
}

@property (weak, nonatomic) IBOutlet UILabel *lblFtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblFPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgfPic;

@property (weak, nonatomic) IBOutlet UILabel *lblStitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblSPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgSPic;
@property (weak, nonatomic) IBOutlet UIView *viewForF;
@property (weak, nonatomic) IBOutlet UIView *viewForS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consFw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cosnSw;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdViewLeft;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdViewRight;

@end

@implementation MEFourHomeTopHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _lblFtitle.adjustsFontSizeToFitWidth = YES;
//    _lblStitle.adjustsFontSizeToFitWidth = YES;
    
    _lblFPrice.adjustsFontSizeToFitWidth = YES;
    _lblSPrice.adjustsFontSizeToFitWidth = YES;
    
//    _viewForF.userInteractionEnabled = YES;
//    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapF)];
//    [_viewForF addGestureRecognizer:ges];
    
    
//    _viewForS.userInteractionEnabled = YES;
//    UITapGestureRecognizer *gess = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapS)];
//    [_viewForS addGestureRecognizer:gess];
}

- (void)tapF{
    if(_model.recommend_goods){
        MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
        if(homevc){
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:_model.recommend_goods.product_id];
            [homevc.navigationController pushViewController:details animated:YES];
        }
    }
}

- (void)tapS{
    if(_model.spreebuy_goods){
        MEFiveHomeVC *homevc = (MEFiveHomeVC *)[MECommonTool getVCWithClassWtihClassName:[MEFiveHomeVC class] targetResponderView:self];
        if(homevc){
            METhridProductDetailsVC *details = [[METhridProductDetailsVC alloc]initWithId:_model.spreebuy_goods.product_id];
//            details.time = kMeUnNilStr(_model.spreebuy_goods.time);
            [homevc.navigationController pushViewController:details animated:YES];
        }
    }
}

- (void)setUiWithModel:(MEHomeRecommendAndSpreebuyModel *)model{
    _model = model;
//    kSDLoadImg(_imgfPic, kMeUnNilStr(model.recommend_goods.images_url));
//    NSString *ftitle = kMeUnNilStr(model.recommend_goods.title);
//    CGFloat w = (SCREEN_WIDTH/2)-74-15-13-1;
//    CGFloat h = 14;
//
//    CGRect rect = [ftitle boundingRectWithSize:CGSizeMake(w, h) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kMeFont(10)} context:nil];
//
//    CGFloat LabelFW = rect.size.width+12;
//    LabelFW = LabelFW>w?w:LabelFW;
//    _consFw.constant = LabelFW;
//    _lblFtitle.text = ftitle;
//    _lblFDesc.text = kMeUnNilStr(model.recommend_goods.desc).length?kMeUnNilStr(model.recommend_goods.desc):kMeUnNilStr(model.recommend_goods.title);
//
//    NSString *fstr = [NSString stringWithFormat:@"¥%@ ¥%@",@(kMeUnNilStr(model.recommend_goods.market_price).floatValue),@(kMeUnNilStr(model.recommend_goods.money).floatValue)];
//    NSMutableAttributedString *faString = [[NSMutableAttributedString alloc]initWithString:fstr];
//
//    NSUInteger firstLoc = 0;
//    NSUInteger secondLoc = [[faString string] rangeOfString:@" "].location;
//
//    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
//    [faString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"848484"] range:range];
//    [faString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
//
//    _lblFPrice.attributedText = faString;
//
//    kSDLoadImg(_imgSPic, kMeUnNilStr(model.spreebuy_goods.images_url));
//    NSString *Stitle = kMeUnNilStr(model.spreebuy_goods.title);
//    CGRect srect = [Stitle boundingRectWithSize:CGSizeMake(w, h) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kMeFont(10)} context:nil];
//
//    CGFloat LabelSW = srect.size.width+12;
//    LabelSW = LabelSW>w?w:LabelSW;
//    _cosnSw.constant = LabelSW;
//
//
//    _lblStitle.text = Stitle;
//    _lblSDesc.text = kMeUnNilStr(model.spreebuy_goods.desc).length?kMeUnNilStr(model.spreebuy_goods.desc):kMeUnNilStr(model.spreebuy_goods.title);
//
//    NSString *sstr = [NSString stringWithFormat:@"¥%@ ¥%@",@(kMeUnNilStr(model.spreebuy_goods.market_price).floatValue),@(kMeUnNilStr(model.spreebuy_goods.money).floatValue)];
//    NSMutableAttributedString *saString = [[NSMutableAttributedString alloc]initWithString:sstr];
//
//    NSUInteger sfirstLoc = 0;
//    NSUInteger ssecondLoc = [[saString string] rangeOfString:@" "].location;
//
//    NSRange srange = NSMakeRange(sfirstLoc, ssecondLoc - sfirstLoc);
//    [saString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"848484"] range:srange];
//    [saString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:srange];
//    _lblSPrice.attributedText = saString;
    
    
    _sdViewLeft.contentMode = UIViewContentModeScaleAspectFill;
    _sdViewLeft.clipsToBounds = YES;
    _sdViewLeft.delegate = self;
    _sdViewLeft.imageURLStringsGroup = @[kMeUnNilStr(model.recommend_left.ad_img)];
    _sdViewLeft.infiniteLoop = NO;
    _sdViewLeft.tag = 100;
    _sdViewLeft.autoScroll = NO;
    _sdViewLeft.backgroundColor = [UIColor clearColor];
    
    _sdViewRight.contentMode = UIViewContentModeScaleAspectFill;
    _sdViewRight.clipsToBounds = YES;
    _sdViewRight.delegate = self;
    _sdViewRight.tag = 101;
    _sdViewRight.imageURLStringsGroup = @[kMeUnNilStr(model.recommend_right.ad_img)];
    _sdViewRight.infiniteLoop = NO;
    _sdViewRight.autoScroll = NO;
    _sdViewRight.backgroundColor = [UIColor clearColor];
}

- (void)setUIWithCourseModel:(METhridHomeStudyTogetherModel *)model {
    NSArray *leftBanner = kMeUnArr(model.left_banner);
    METhridHomeAdModel *leftAdModel = (METhridHomeAdModel *)leftBanner.firstObject;
    _sdViewLeft.contentMode = UIViewContentModeScaleAspectFill;
    _sdViewLeft.clipsToBounds = YES;
    _sdViewLeft.delegate = self;
    _sdViewLeft.imageURLStringsGroup = @[kMeUnNilStr(leftAdModel.ad_img)];
    _sdViewLeft.infiniteLoop = NO;
    _sdViewLeft.tag = 100;
    _sdViewLeft.autoScroll = NO;
    _sdViewLeft.backgroundColor = [UIColor clearColor];
    
    NSArray *rightBanner = kMeUnArr(model.right_banner);
    METhridHomeAdModel *rightAdModel = (METhridHomeAdModel *)rightBanner.firstObject;
    _sdViewRight.contentMode = UIViewContentModeScaleAspectFill;
    _sdViewRight.clipsToBounds = YES;
    _sdViewRight.delegate = self;
    _sdViewRight.tag = 101;
    _sdViewRight.imageURLStringsGroup = @[kMeUnNilStr(rightAdModel.ad_img)];
    _sdViewRight.infiniteLoop = NO;
    _sdViewRight.autoScroll = NO;
    _sdViewRight.backgroundColor = [UIColor clearColor];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView.tag == 100) {
        kMeCallBlock(_leftBlock);
    }
    if (cycleScrollView.tag == 101) {
        kMeCallBlock(_rightBlock);
    }
}

@end

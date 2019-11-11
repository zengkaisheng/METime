//
//  MEFourCoupleHeaderView.m
//  志愿星
//
//  Created by gao lei on 2019/6/14.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourCoupleHeaderView.h"
#import "MEAdModel.h"

@interface MEFourCoupleHeaderView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *siftView;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, copy) NSString *sort;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdViewConsHeight;

@end


@implementation MEFourCoupleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSArray *titles = @[@"综合",@"佣金",@"销量",@"价格"];
    [self setSiftViewWithTitlesArray:titles];
}

- (void)setSiftViewWithTitlesArray:(NSArray *)titles {
    CGFloat itemW = SCREEN_WIDTH / titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIButton *siftBtn = [self createSiftButtomWithTitle:titles[i] tag:100+i];
        siftBtn.frame = CGRectMake(itemW * i, 0, itemW, 40);
        if (i == 0) {
            siftBtn.selected = YES;
            self.isUp = YES;
        }
        [_siftView addSubview:siftBtn];
    }
}

- (void)setUIWithBannerImage:(NSArray *)bannerImages isJD:(BOOL)isJD {
    for (id obj in _siftView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *siftBtn = (UIButton *)obj;
            [siftBtn removeFromSuperview];
        }
    }
    
    NSArray *titles = @[@"综合",@"佣金",@"销量",@"价格"];
    if (isJD) {
        titles = @[@"综合",@"佣金",@"销量"];
    }
    [self setSiftViewWithTitlesArray:titles];
    
    if (bannerImages.count > 0) {
        _sdViewConsHeight.constant = 150;
        _sdView.hidden = NO;
        _sdView.contentMode = UIViewContentModeScaleAspectFill;
        _sdView.clipsToBounds = YES;
        _sdView.delegate = self;
        _sdView.backgroundColor = [UIColor clearColor];
        
        __block NSMutableArray *arrImage =[NSMutableArray array];
        [bannerImages enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrImage addObject:kMeUnNilStr(model.ad_img)];
        }];
        _sdView.imageURLStringsGroup = arrImage;
        
        if (arrImage.count <= 1) {
            _sdView.infiniteLoop = NO;
            _sdView.autoScroll = NO;
        }else {
            _sdView.infiniteLoop = YES;
            _sdView.autoScroll = YES;
            _sdView.autoScrollTimeInterval = 4;
        }
    }else {
        _sdViewConsHeight.constant = 0;
        _sdView.hidden = YES;
    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    kMeCallBlock(_selectedIndexBlock,index);
}

#pragma helper
- (UIButton *)createSiftButtomWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *siftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [siftBtn setTitle:title forState:UIControlStateNormal];
    [siftBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:14]];
    [siftBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [siftBtn setTitleColor:[UIColor colorWithHexString:@"#2ED9A4"] forState:UIControlStateSelected];
    if (tag != 100) {
        [siftBtn setImage:[UIImage imageNamed:@"jiagenomal"] forState:UIControlStateNormal];
        [siftBtn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
    }
    //jiagedown  jiagenomal  jiageup
    [siftBtn setTag:tag];
    if ([title isEqualToString:@"优惠券"]) {
        [siftBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-95];
    }else {
        [siftBtn setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:-70];
    }
    [siftBtn addTarget:self action:@selector(siftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    siftBtn.backgroundColor = [UIColor whiteColor];
    
    return siftBtn;
}

- (void)siftBtnAction:(UIButton *)sender {
    UIButton *siftBtn = (UIButton *)sender;
    self.isTop = NO;
    
    [self reloadStatusWithSiftButton:siftBtn];
    
    if (self.titleSelectedIndexBlock) {
        self.titleSelectedIndexBlock(siftBtn.tag,self.isUp);
    }
}

//刷新筛选按钮状态
- (void)reloadStatusWithSiftButton:(UIButton *)siftBtn {
    for (UIButton *btn in _siftView.subviews) {
        if (btn.tag == siftBtn.tag) {
            if (self.isTop) {
                btn.selected = YES;
                if (btn.tag != 100) {
                    if (self.isUp) {
                        [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                    }else {
                        [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                    }
                }
            }else {
                if (siftBtn.selected == YES && siftBtn.tag != 100) {
                    if (self.isUp == YES) {
                        self.isUp = NO;
                        [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                    }else {
                        [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                        self.isUp = YES;
                    }
                }else {
                    siftBtn.selected = YES;
                    if (siftBtn.tag == 103) {
                        self.isUp = YES;
                        [btn setImage:[UIImage imageNamed:@"jiageup"] forState:UIControlStateSelected];
                    }else {
                        self.isUp = NO;
                        if (siftBtn.tag != 100) {
                            [btn setImage:[UIImage imageNamed:@"jiagedown"] forState:UIControlStateSelected];
                        }
                    }
                }
            }
        }else {
            btn.selected = NO;
        }
    }
}

- (void)reloadSiftButtonWithSelectedBtn:(UIButton *)selectedBtn isUp:(BOOL)isUp isTop:(BOOL)isTop {
    self.isUp = isUp;
    self.isTop = isTop;
    for (UIButton *btn in _siftView.subviews) {
        if (btn.tag == selectedBtn.tag) {
            [self reloadStatusWithSiftButton:btn];
        }
    }
}

@end

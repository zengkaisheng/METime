//
//  MEGroupDetailHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/7/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupDetailHeaderView.h"
#import "MEGoodDetailModel.h"

@interface MEGroupDetailHeaderView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (weak, nonatomic) IBOutlet UILabel *daysLbl;
@property (weak, nonatomic) IBOutlet UILabel *hourLbl;
@property (weak, nonatomic) IBOutlet UILabel *minuteLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondsLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *origanPriceLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLblConsHeight;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *daysLblConsWidth;
@property (weak, nonatomic) IBOutlet UIView *orangeView;

@property (strong, nonatomic) NSTimer *timer;

@end


@implementation MEGroupDetailHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSD];
}

- (void)initSD{
    _sdView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _sdView.autoScrollTimeInterval = 4;
    _sdView.delegate =self;
    _sdView.backgroundColor = [UIColor clearColor];
    _sdView.placeholderImage = kImgBannerPlaceholder;
    _sdView.currentPageDotColor = kMEPink;
    
    _orangeView.frame = CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 51);
    CAGradientLayer *btnLayer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:254/255.0 green:83/255.0 blue:55/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:111/255.0 blue:87/255.0 alpha:1.0].CGColor] locations:@[@(0.0),@(1.0)] frame:_orangeView.layer.bounds];
    [_orangeView.layer insertSublayer:btnLayer atIndex:0];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

- (void)setUIWithModel:(MEGoodDetailModel *)model{
    self.sdView.imageURLStringsGroup = @[MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images))];
    _titleLbl.text = kMeUnNilStr(model.title);
    
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(model.title) font:[UIFont systemFontOfSize:18] width:(SCREEN_WIDTH - 30) lineH:0 maxLine:0];
    _titleLblConsHeight.constant = titleHeight>19?titleHeight:19;
    [_titleLbl setAtsWithStr:kMeUnNilStr(model.title) lineGap:0];
    
    NSString *price = kMeUnNilStr(model.money);
    if ([kMeUnNilStr(model.group_price) length] > 0) {
        price = kMeUnNilStr(model.group_price);
    }
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",price];
    NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"%d",price.intValue]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(range.location+range.length, priceStr.length-range.location-range.length)];
    _priceLbl.attributedText = attStr;
    
    NSString *commStr = [NSString stringWithFormat:@"¥%@",kMeUnNilStr(model.market_price)];
    [_origanPriceLbl setLineStrWithStr:commStr];
    _countLbl.text = [NSString stringWithFormat:@"%@人团",kMeUnNilStr(model.group_num)];
    
    [self downSecondHandle:kMeUnNilStr(model.end_time) nowTime:kMeUnNilStr(model.now)];
}

- (CAGradientLayer *)getLayerWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors locations:(NSArray *)locations frame:(CGRect)frame {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = startPoint;//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = endPoint;//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = colors;
    layer.locations = locations;//渐变颜色的区间分布，locations的数组长度和color一致，这个值一般不用管它，默认是nil，会平均分布
    layer.frame = frame;
    return layer;
}

- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:timeString];
    return date;
}

-(void)downSecondHandle:(NSString *)aTimeString nowTime:(NSString *)nowTime{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [self timeWithTimeIntervalString:kMeUnNilStr(aTimeString)]; //结束时间
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    NSDate *startDate = [self timeWithTimeIntervalString:kMeUnNilStr(nowTime)]; //开始时间;
    NSString* dateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"现在的时间 === %@",dateString);
    NSTimeInterval timeInterval = [endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.daysLbl.text = @"00";
                        self.hourLbl.text = @"00";
                        self.minuteLbl.text = @"00";
                        self.secondsLbl.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days < 10) {
                            self.daysLbl.text = [NSString stringWithFormat:@"0%d",days];;
                        }else {
                            if (days > 99) {
                                self.daysLblConsWidth.constant = 20;
                            }else {
                                self.daysLblConsWidth.constant = 15;
                            }
                            self.daysLbl.text = [NSString stringWithFormat:@"%d",days];;
                        }
                        if (hours<10) {
                            self.hourLbl.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLbl.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLbl.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLbl.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondsLbl.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondsLbl.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}


+ (CGFloat)getHeightWithModel:(MEGoodDetailModel *)model{
    CGFloat height = 10+15+10+15+17+15+15+61;
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(model.title) font:[UIFont systemFontOfSize:18] width:(SCREEN_WIDTH - 30) lineH:0 maxLine:0];
    height += titleHeight>19?titleHeight:19;
    height += SCREEN_WIDTH;
    return height;
}

@end

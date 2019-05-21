//
//  METhridProductDetailsHeaderView.m
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import "METhridProductDetailsHeaderView.h"
#import "MEGoodDetailModel.h"

@interface METhridProductDetailsHeaderView ()<SDCycleScrollViewDelegate>


@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceLine;
@property (weak, nonatomic) IBOutlet UILabel *lblExpress;
@property (weak, nonatomic) IBOutlet UILabel *lblStock;
@property (weak, nonatomic) IBOutlet UILabel *lblSaled;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSdHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTitleHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblMinite;
@property (weak, nonatomic) IBOutlet UILabel *lblHour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSockRate;
@property (weak, nonatomic) IBOutlet UIView *viewForStock;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;

@end

@implementation METhridProductDetailsHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    _consSdHeight.constant = SCREEN_WIDTH;
    _lblStock.adjustsFontSizeToFitWidth = YES;
    _lblExpress.adjustsFontSizeToFitWidth = YES;
    _lblSaled.adjustsFontSizeToFitWidth = YES;
    [self initSD];
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

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

- (void)setUIWithModel:(MEGoodDetailModel *)model{
    self.sdView.imageURLStringsGroup = @[MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images))];
    _lblTitle.text = kMeUnNilStr(model.title);
    
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(model.title) font:[UIFont systemFontOfSize:15] width:(SCREEN_WIDTH - 20) lineH:0 maxLine:0];
    _consTitleHeight.constant = titleHeight>19?titleHeight:19;
    [_lblTitle setAtsWithStr:kMeUnNilStr(model.title) lineGap:0];
    if(kMeUnNilStr(model.desc).length){
        _lblSubTitle.text = kMeUnNilStr(model.desc);
    }else{
        _lblSubTitle.text = kMeUnNilStr(model.title);
    }
    _lblPrice.text = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.money).floatValue)];
    NSString *commStr = [NSString stringWithFormat:@"¥%@",@(kMeUnNilStr(model.market_price).floatValue)];
    [_lblPriceLine setLineStrWithStr:commStr];
    
    if(model.stock ==0 && model.sell_num==0){
        _viewForStock.hidden = YES;
        _lblRate.hidden = YES;
    }else{
        _viewForStock.hidden = NO;
        _lblRate.hidden = NO;
//        CGFloat rate = model.sell_num/(model.stock+model.sell_num);
        NSInteger rate = (model.sell_num *100)/(model.stock+model.sell_num);

//        NSInteger rateNum = 100*rate;
        _lblRate.text = [NSString stringWithFormat:@"%ld%%",(long)rate];
        _consSockRate.constant = rate;
    }
    
    CGFloat postage = [model.postage floatValue];
    if(postage<=0){
        _lblExpress.text = @"快递:包邮";
    }else{
        _lblExpress.text = [NSString stringWithFormat:@"快递:%@元",model.postage];
    }
    _lblStock.text = [NSString stringWithFormat:@"参与数:%@",kMeUnNilStr(model.browse)];
    _lblSaled.text = [NSString stringWithFormat:@"销量:%@",kMeUnNilStr(model.sales)];
    
//    _model
}

- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:timeString];
    return date;
}


-(void)downSecondHandle:(NSString *)aTimeString{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [self timeWithTimeIntervalString:kMeUnNilStr(aTimeString)]; //结束时间
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    NSDate *startDate = [NSDate date];
    NSString* dateString = [dateFormatter stringFromDate:startDate];
    NSLog(@"现在的时间 === %@",dateString);
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
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
                        self.lblHour.text = @"00";
                        self.lblMinite.text = @"00";
                        self.lblSecond.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (hours<10) {
                            self.lblHour.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.lblHour.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.lblMinite.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.lblMinite.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.lblSecond.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.lblSecond.text = [NSString stringWithFormat:@"%d",second];
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
    CGFloat height = 10+16+16+21+15+15+19+71;
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(model.title) font:[UIFont systemFontOfSize:15] width:(SCREEN_WIDTH - 20) lineH:0 maxLine:0];
    height += titleHeight>19?titleHeight:19;
    height += SCREEN_WIDTH;
    return height;
}

@end

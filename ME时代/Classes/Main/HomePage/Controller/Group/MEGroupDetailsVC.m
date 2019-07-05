//
//  MEGroupDetailsVC.m
//  ME时代
//
//  Created by gao lei on 2019/7/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupDetailsVC.h"
#import "MEGoodDetailModel.h"

@interface MEGroupDetailsVC ()
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConsHeight;
@property (nonatomic, strong) MEGoodDetailModel *model;

@property (nonatomic, copy) NSString *hoursStr;
@property (nonatomic, copy) NSString *minuteStr;
@property (nonatomic, copy) NSString *secondStr;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MEGroupDetailsVC

- (instancetype)initWithModel:(MEGoodDetailModel*)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"拼购详情";
    
    kSDLoadImg(_productImage, self.model.image_url);
    _imageTopCons.constant = kMeNavBarHeight+15;
    NSString *title = kMeUnNilStr(self.model.title);
    _titleLbl.text = title;
    CGFloat titleHeight = [NSAttributedString heightForAtsWithStr:kMeUnNilStr(title) font:[UIFont systemFontOfSize:14] width:(SCREEN_WIDTH - 156-17) lineH:0 maxLine:0];
    _titleConsHeight.constant = titleHeight>19?titleHeight:19;
    
    _numberLbl.text = [NSString stringWithFormat:@"%@人团",kMeUnNilStr(self.model.group_num)];
    
    NSString *faStr = [NSString stringWithFormat:@"拼团价￥%@ ￥%@",kMeUnNilStr(self.model.group_price),kMeUnNilStr(self.model.market_price)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:faStr];
    NSUInteger firstLoc = [faStr rangeOfString:@" "].location;
    
    [string addAttribute:NSForegroundColorAttributeName value:kME999999 range:NSMakeRange(firstLoc, faStr.length-firstLoc)];
    [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(firstLoc+1, faStr.length-firstLoc-1)];
    _priceLbl.attributedText = string;
    
    NSString *timeStr = @"还差1人拼团成功，剩余00:00:00";
    NSMutableAttributedString *timeAtt = [[NSMutableAttributedString alloc] initWithString:timeStr];
    NSUInteger secondLoc = [timeStr rangeOfString:@"余"].location;
    [timeAtt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF0000"] range:NSMakeRange(secondLoc+1, timeStr.length-secondLoc-1)];
    _timeLbl.attributedText = timeAtt;
    
    _groupBtn.frame = CGRectMake(15, CGRectGetMaxY(_timeLbl.frame)+109, SCREEN_WIDTH-30, 49);
    CAGradientLayer *btnLayer = [self getLayerWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) colors:@[(__bridge id)[UIColor colorWithRed:254/255.0 green:83/255.0 blue:55/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:253/255.0 green:139/255.0 blue:15/255.0 alpha:1.0].CGColor] locations:@[@(0.0),@(1.0)] frame:_groupBtn.layer.bounds];
    [_groupBtn.layer insertSublayer:btnLayer atIndex:0];
    
    CGFloat itemW = 50;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-(itemW*2+20*(2-1)))/2, CGRectGetMaxY(_timeLbl.frame)+16, itemW*2+20*(2-1), 53)];
    for (int i = 0; i < 2; i++) {
        UIImageView *imageV = [self createImageViewWithImage:@"image" frame:CGRectMake((itemW+20)*i, 3, itemW, itemW)];
        if (i == 0) {
            UILabel *topLbl = [[UILabel alloc] initWithFrame:CGRectMake(itemW-17, -3, 20, 20)];
            topLbl.text = @"团长";
            topLbl.textColor = [UIColor whiteColor];
            topLbl.font = [UIFont systemFontOfSize:8];
            topLbl.textAlignment = NSTextAlignmentCenter;
            topLbl.layer.cornerRadius = 10;
            topLbl.layer.masksToBounds = YES;
            topLbl.backgroundColor = [UIColor colorWithHexString:@"#FD809E"];
            [imageV addSubview:topLbl];
        }
        [bgView addSubview:imageV];
    }
    [self.view addSubview:bgView];
}

- (UIImageView *)createImageViewWithImage:(NSString *)image frame:(CGRect)frame {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:frame];
    if ([image hasPrefix:@"http"]) {
        kSDLoadImg(imgV, image);
    }else {
        imgV.image = [UIImage imageNamed:image];
    }
    imgV.backgroundColor = [UIColor colorWithHexString:@"#A1A1A1"];
    imgV.layer.cornerRadius = frame.size.width/2.0;
    return imgV;
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

- (IBAction)groupBtnAction:(id)sender {
}

- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:timeString];
    return date;
}

-(void)downSecondHandle:(NSString *)aTimeString{
    
    //    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //
    //    NSDate *endDate = [self timeWithTimeIntervalString:kMeUnNilStr(aTimeString)]; //结束时间
    //    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate])];
    //    NSDate *startDate = [self timeWithTimeIntervalString:kMeUnNilStr(nowTime)]; //开始时间;
    //    NSString* dateString = [dateFormatter stringFromDate:startDate];
    //    NSLog(@"现在的时间 === %@",dateString);
    //    NSTimeInterval timeInterval = [endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = [aTimeString intValue]; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.timeLbl.text = @"剩余00:00:00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (hours<10) {
                            self.hoursStr = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hoursStr = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteStr = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteStr = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondStr = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondStr = [NSString stringWithFormat:@"%d",second];
                        }
                        self.timeLbl.text = [NSString stringWithFormat:@"剩余%@:%@:%@",self.hoursStr,self.minuteStr,self.secondStr];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

@end

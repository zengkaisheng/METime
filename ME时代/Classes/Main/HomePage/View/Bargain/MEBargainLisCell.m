//
//  MEBargainLisCell.m
//  志愿星
//
//  Created by gao lei on 2019/6/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainLisCell.h"
#import "MEBargainListModel.h"
#import "MEMyBargainListModel.h"

@interface MEBargainLisCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *bargainBtn;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *lblHour;
@property (weak, nonatomic) IBOutlet UILabel *lblMinite;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UILabel *endLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bargainConsWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConsTrailing;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConsWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPicConsBottom;

@end

@implementation MEBargainLisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = 0;
    _timeView.hidden = YES;
    _endLbl.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEBargainListModel *)model {
    _timeView.hidden = YES;
    _endLbl.hidden = YES;
    _subTitleLbl.hidden = NO;
    _countLbl.hidden = NO;
    _bgViewConsTop.constant = _bgViewConsLeading.constant = _bgViewConsTrailing.constant = 0;
    _bgView.cornerRadius = 0.0;
    _headerPicConsTop.constant = 12.0;
    _headerPicConsLeading.constant = 15.0;
    _headerPicConsBottom.constant = 12.0;
    _headerPic.cornerRadius = 0;
    
    kSDLoadImg(_headerPic, kMeUnNilStr(model.images));
    _titleLbl.text = kMeUnNilStr(model.title);
    _subTitleLbl.text = [NSString stringWithFormat:@"砍成免费领%@",kMeUnNilStr(model.title)];
    _countLbl.text = [NSString stringWithFormat:@"已有%@人领取",kMeUnNilNumber(@(model.finish_bargin_num))];
    if (kMeUnNilStr(model.product_price).length > 0) {
        NSArray *productPrice = [model.product_price componentsSeparatedByString:@"."];
        if ([productPrice.lastObject intValue] == 0) {
            _priceLbl.text = [NSString stringWithFormat:@"价值%@元",productPrice.firstObject];
        }else {
            _priceLbl.text = [NSString stringWithFormat:@"价值%@元",kMeUnNilStr(model.product_price)];
        }
    }else {
        _priceLbl.text = @"价值0元";
    }
    
    NSString *content = [NSString stringWithFormat:@"砍价%.2f元得",[kMeUnNilStr(model.product_price) floatValue] - [kMeUnNilStr(model.amount_money) floatValue]];
    NSString *balance = [NSString stringWithFormat:@"%.2f",[kMeUnNilStr(model.product_price) floatValue] - [kMeUnNilStr(model.amount_money) floatValue]];
    NSArray *balanceArr = [balance componentsSeparatedByString:@"."];
    if ([balanceArr.lastObject intValue] == 0) {
        content = [NSString stringWithFormat:@"砍价%@元得",balanceArr.firstObject];
    }else {
        content = [NSString stringWithFormat:@"砍价%@元得",balance];
    }
    CGFloat width = [content boundingRectWithSize:CGSizeMake(100, 32) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
    [_bargainBtn setTitle:content forState:UIControlStateNormal];
    _bargainConsWidth.constant = width+24;
}

- (void)setHomeUIWithModel:(MEBargainListModel *)model {
    _timeView.hidden = YES;
    _endLbl.hidden = YES;
    _subTitleLbl.hidden = NO;
    _countLbl.hidden = NO;
    _bgViewConsLeading.constant = _bgViewConsTrailing.constant = 10.0;
    _bgViewConsTop.constant = 5.0;
    _bgView.cornerRadius = 10.0;
    _headerPicConsTop.constant = 15.0;
    _headerPicConsLeading.constant = 10.0;
    _headerPicConsBottom.constant = 17.0;
    _headerPic.cornerRadius = 4;
    
    kSDLoadImg(_headerPic, MELoadQiniuImagesWithUrl(kMeUnNilStr(model.images)));
    _titleLbl.text = kMeUnNilStr(model.title);
    _subTitleLbl.text = [NSString stringWithFormat:@"砍成免费领%@",kMeUnNilStr(model.title)];
    _countLbl.text = [NSString stringWithFormat:@"已有%@人领取",kMeUnNilNumber(@(model.finish_bargin_num))];
    _priceLbl.text = [NSString stringWithFormat:@"价值%@元",kMeUnNilStr(model.product_price).length>0?kMeUnNilStr(model.product_price):@"0"];
    _priceLbl.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15];
    _priceLbl.textColor = [UIColor colorWithHexString:@"#EA3982"];
    
    NSString *content = [NSString stringWithFormat:@"砍价%.2f元得",[kMeUnNilStr(model.product_price) floatValue] - [kMeUnNilStr(model.amount_money) floatValue]];
    CGFloat width = [content boundingRectWithSize:CGSizeMake(100, 32) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
    [_bargainBtn setTitle:content forState:UIControlStateNormal];
    _bargainConsWidth.constant = width+12;
    [_bargainBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_bargainBtn setBackgroundColor:[UIColor colorWithHexString:@"#EA3982"]];
    _bargainBtn.cornerRadius = 5.0;
    _btnConsHeight.constant = 30;
}

- (void)setMyBargainUIWithModel:(MEMyBargainListModel *)model {
    kSDLoadImg(_headerPic, kMeUnNilStr(model.images));
    _titleLbl.text = kMeUnNilStr(model.title);
    _subTitleLbl.hidden = YES;
    _bargainConsWidth.constant = 83;
    _bgViewConsTop.constant = _bgViewConsLeading.constant = _bgViewConsTrailing.constant = 0;
    _bgView.cornerRadius = 0.0;
    _headerPicConsTop.constant = 12.0;
    _headerPicConsLeading.constant = 15.0;
    _headerPicConsBottom.constant = 12.0;
    _headerPic.cornerRadius = 0;
    
    if (model.bargin_status == 1) {//未结束
        _timeView.hidden = NO;
        _endLbl.hidden = YES;
        _countLbl.hidden = YES;
        [self downSecondHandle:[NSString stringWithFormat:@"%@",kMeUnNilNumber(@(model.over_time))]];
        
        if (model.status == 1) {//砍价中
            _priceLbl.text = [NSString stringWithFormat:@"还差%.2f元",[kMeUnNilStr(model.amount_money) floatValue] - [kMeUnNilStr(model.money) floatValue]];
            [_bargainBtn setTitle:@"继续砍价" forState:UIControlStateNormal];
        }else if (model.status == 2) {//砍价成功
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        }else if (model.status == 3) {
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"已领取" forState:UIControlStateNormal];
        }else if (model.status == 4) {
            _priceLbl.text = @"砍价失败";
            [_bargainBtn setTitle:@"重砍一个" forState:UIControlStateNormal];
        }
    }else if (model.bargin_status == 2) {//已结束
        _timeView.hidden = YES;
        _endLbl.hidden = NO;
        _countLbl.hidden = NO;
        if (model.status == 1) {
            _countLbl.text = [NSString stringWithFormat:@"只差%.2f元就成功了",[kMeUnNilStr(model.amount_money) floatValue] - [kMeUnNilStr(model.money) floatValue]];
            _priceLbl.text = @"砍价失败";
            [_bargainBtn setTitle:@"重砍一个" forState:UIControlStateNormal];
        }else if (model.status == 2) {
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        }else if (model.status == 3) {
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"已领取" forState:UIControlStateNormal];
        }else if (model.status == 4) {
            _countLbl.text = [NSString stringWithFormat:@"只差%.2f元就成功了",[kMeUnNilStr(model.amount_money) floatValue] - [kMeUnNilStr(model.money) floatValue]];
            _priceLbl.text = @"砍价失败";
            [_bargainBtn setTitle:@"重砍一个" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)bargainAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger index = 0;
    if ([btn.titleLabel.text isEqualToString:@"已兑换"]) {
        return;
    }
    if ([btn.titleLabel.text isEqualToString:@"重砍一个"]) {
        index = 1;
    }
    if (self.tapBlock) {
        self.tapBlock(index);
    }
}

- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
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
//    NSDate *startDate = [NSDate date];
//    NSString* dateString = [dateFormatter stringFromDate:startDate];
//    NSLog(@"现在的时间 === %@",dateString);
//    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = [aTimeString intValue]; //倒计时时间
        
        if (timeout>0) {
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
//                        if (days > 0) {
//                            self.endTimeLbl.text = [NSString stringWithFormat:@"距离结束还剩%d天",days];
//                        }else {
//                            self.endTimeLbl.text = @"距离结束时间";
//                        }
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
        }else {
            self.lblHour.text = @"00";
            self.lblMinite.text = @"00";
            self.lblSecond.text = @"00";
        }
    }
}

@end

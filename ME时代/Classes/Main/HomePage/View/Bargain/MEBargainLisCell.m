//
//  MEBargainLisCell.m
//  ME时代
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
    
    kSDLoadImg(_headerPic, model.images);
    _titleLbl.text = model.title;
    _subTitleLbl.text = [NSString stringWithFormat:@"砍成免费领%@",model.title];
    _countLbl.text = [NSString stringWithFormat:@"已有%ld人领取",(long)model.finish_bargin_num];
    _priceLbl.text = [NSString stringWithFormat:@"价值%@元",model.amount_money];
    
    NSString *content = [NSString stringWithFormat:@"砍价%.2f元得",[model.product_price floatValue] - [model.amount_money floatValue]];
    CGFloat width = [content boundingRectWithSize:CGSizeMake(100, 32) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
    [_bargainBtn setTitle:[NSString stringWithFormat:@"砍价%.2f元得",[model.product_price floatValue] - [model.amount_money floatValue]] forState:UIControlStateNormal];
    _bargainConsWidth.constant = width+24;
}

- (void)setMyBargainUIWithModel:(MEMyBargainListModel *)model {
    kSDLoadImg(_headerPic, model.images);
    _titleLbl.text = model.title;
    _subTitleLbl.hidden = YES;
    
    if (model.bargin_status == 1) {//未结束
        _timeView.hidden = NO;
        _endLbl.hidden = YES;
        _countLbl.hidden = YES;
        [self downSecondHandle:model.end_time];
        
        if (model.status == 1) {//砍价中
            _priceLbl.text = [NSString stringWithFormat:@"还差%@元",model.amount_money];
            [_bargainBtn setTitle:@"继续砍价" forState:UIControlStateNormal];
        }else if (model.status == 2) {//砍价成功
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        }else if (model.status == 3) {
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"已兑换" forState:UIControlStateNormal];
        }
    }else if (model.bargin_status == 2) {//已结束
        _timeView.hidden = YES;
        _endLbl.hidden = NO;
        _countLbl.hidden = NO;
        if (model.status == 1) {
            _countLbl.text = [NSString stringWithFormat:@"只差%.2f元就成功了",[model.amount_money floatValue] - [model.money floatValue]];
            [_bargainBtn setTitle:@"重砍一个" forState:UIControlStateNormal];
            _priceLbl.text = @"砍价失败";
        }else if (model.status == 2) {
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        }else if (model.status == 3) {
            _priceLbl.text = @"砍价成功";
            [_bargainBtn setTitle:@"已兑换" forState:UIControlStateNormal];
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
        }
    }
}

@end

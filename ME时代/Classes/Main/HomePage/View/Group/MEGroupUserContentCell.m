//
//  MEGroupUserContentCell.m
//  ME时代
//
//  Created by gao lei on 2019/7/4.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupUserContentCell.h"
#import "MEGroupUserContentModel.h"

@interface MEGroupUserContentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (nonatomic, copy) NSString *hoursStr;
@property (nonatomic, copy) NSString *minuteStr;
@property (nonatomic, copy) NSString *secondStr;

@property (strong, nonatomic) NSTimer *timer;

@end



@implementation MEGroupUserContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEGroupUserContentModel *)model{
    kSDLoadImg(_headerPic, kMeUnNilStr(model.header_pic));
    _nameLbl.text = [NSString stringWithFormat:@"%@人",kMeUnNilStr(model.name)];
    
    NSString *numberStr = [NSString stringWithFormat:@"还差%ld人拼成",kMeUnNilStr(model.num).intValue];
    NSRange range = [numberStr rangeOfString:[NSString stringWithFormat:@"%ld人",kMeUnNilStr(model.num).intValue]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:numberStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF0000"] range:range];
    _numberLbl.attributedText = attStr;
    
    [self downSecondHandle:kMeUnNilStr(model.over_time)];
}
- (IBAction)groupAction:(id)sender {
    kMeCallBlock(self.groupBlock);
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
                        self.timeLbl.text = @"剩余00时00分00秒";
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
                        self.timeLbl.text = [NSString stringWithFormat:@"剩余%@时%@分%@秒",self.hoursStr,self.minuteStr,self.secondStr];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

@end

//
//  MEGroupCountsCell.m
//  ME时代
//
//  Created by gao lei on 2019/7/3.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEGroupCountsCell.h"
#import "MEGoodDetailModel.h"

@interface MEGroupCountsCell ()
@property (weak, nonatomic) IBOutlet UILabel *allCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *daysLbl;
@property (weak, nonatomic) IBOutlet UILabel *groupNumberLbl;

@end



@implementation MEGroupCountsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEGoodDetailModel *)model{
    _allCountLbl.text = [NSString stringWithFormat:@"%@人",kMeUnNilStr(model.group_total)];
    _groupNumberLbl.text = [NSString stringWithFormat:@"%@人",kMeUnNilStr(model.finish_group_total)];
    
    [self downSecondHandle:kMeUnNilStr(model.end_time) nowTime:kMeUnNilStr(model.now)];
}

- (NSDate *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
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
    
    __block int timeout = timeInterval; //倒计时时间
    
    if (timeout <= 0) {
        _daysLbl.text = @"0天";
    }else {
        int days = (int)(timeout/(3600*24));
        self.daysLbl.text = [NSString stringWithFormat:@"%d天",days];;
    }
}

@end

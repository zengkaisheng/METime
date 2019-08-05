//
//  MEBargainDetailTopCell.m
//  ME时代
//
//  Created by gao lei on 2019/6/28.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBargainDetailTopCell.h"
#import "MEBargainDetailModel.h"

@interface MEBargainDetailTopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *productCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *daysLbl;
@property (weak, nonatomic) IBOutlet UILabel *hourLbl;
@property (weak, nonatomic) IBOutlet UILabel *minuteLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondLbl;
@property (weak, nonatomic) IBOutlet UIView *productBGView;

@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSInteger status;

@end


@implementation MEBargainDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.productBGView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productBGView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithModel:(MEBargainDetailModel *)model {
    self.status = model.status;
    kSDLoadImg(_headerImgV, kMeUnNilStr(model.header_pic));
    _nameLbl.text = kMeUnNilStr(model.nick_name);
    
    NSString *balance = [NSString stringWithFormat:@"%.2f",[kMeUnNilStr(model.product_price) floatValue] - [kMeUnNilStr(model.amount_money) floatValue]];
    NSArray *balanceArr = [balance componentsSeparatedByString:@"."];
    if ([balanceArr.lastObject intValue] == 0) {
        balance = [NSString stringWithFormat:@"%@",balanceArr.firstObject];
    }
    _contentLbl.text = [NSString stringWithFormat:@"想要此产品，一起砍价%@元领取吧~",balance];
    if (IS_IPHONE_4S || IS_IPHONE_5 || IS_iPhone5S) {
        _contentLbl.font = [UIFont boldSystemFontOfSize:16];
    }else if (IS_IPHONE_6) {
        _contentLbl.font = [UIFont boldSystemFontOfSize:17];
    }else {
        _contentLbl.font = [UIFont boldSystemFontOfSize:18];
    }
    kSDLoadImg(_productImageView, kMeUnNilStr(model.images));
    _productTitleLbl.text = kMeUnNilStr(model.title);
    _productCountLbl.text = [NSString stringWithFormat:@"已有%ld人领取",(long)model.finish_bargin_num];
    if (kMeUnNilStr(model.product_price).length > 0) {
        NSArray *productPrice = [model.product_price componentsSeparatedByString:@"."];
        if ([productPrice.lastObject intValue] == 0) {
            _productPriceLbl.text = [NSString stringWithFormat:@"价值%@元",productPrice.firstObject];
        }else {
            _productPriceLbl.text = [NSString stringWithFormat:@"价值%@元",kMeUnNilStr(model.product_price)];
        }
    }else {
        _productPriceLbl.text = @"价值0元";
    }
    if (IS_IPHONE_4S || IS_IPHONE_5 || IS_iPhone5S) {
        _productPriceLbl.font = [UIFont boldSystemFontOfSize:13];
    }else if (IS_IPHONE_6) {
        _productPriceLbl.font = [UIFont boldSystemFontOfSize:14];
    }else {
        _productPriceLbl.font = [UIFont boldSystemFontOfSize:16];
    }
    [self downSecondHandle:[NSString stringWithFormat:@"%ld",(long)model.over_time]];
    
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"bargainShareBtnImg"] forState:UIControlStateNormal];
    
    if (model.status == 1) {//砍价中
        NSString *message = [NSString stringWithFormat:@"已砍%@元,完成%.1f%%,只差%.2f元!",kMeUnNilStr(model.money).length>0?kMeUnNilStr(model.money):@"0",[kMeUnNilStr(model.money) floatValue]/[kMeUnNilStr(model.amount_money) floatValue]*100,[kMeUnNilStr(model.amount_money) floatValue] - [kMeUnNilStr(model.money) floatValue]];
        
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:message];
        NSRange range1 = [message rangeOfString:kMeUnNilStr(model.money).length>0?kMeUnNilStr(model.money):@"0"];
        NSRange range2 = [message rangeOfString:[NSString stringWithFormat:@"%.1f",[kMeUnNilStr(model.money) floatValue]/[kMeUnNilStr(model.amount_money) floatValue]*100]];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range1];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FEF200"] range:range1];
        
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range2];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FEF200"] range:range2];
        _messageLbl.attributedText = attriStr;
        
        [_shareButton setTitle:@"分享好友，一起砍价" forState:UIControlStateNormal];
    }else if (model.status == 2) {//砍价成功
//        NSString *message = [NSString stringWithFormat:@"恭喜您，砍价成功，已获得价值%@元礼品!",kMeUnNilStr(model.amount_money)];
//
//        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:message];
//        NSRange range1 = [message rangeOfString:kMeUnNilStr(model.amount_money)];
//        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range1];
//        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FEF200"] range:range1];
//        _messageLbl.attributedText = attriStr;
        _messageLbl.text = @"恭喜您，砍价成功";
        [_shareButton setTitle:@"立即领取" forState:UIControlStateNormal];
    }else if (model.status == 3) {
//        NSString *message = [NSString stringWithFormat:@"恭喜您，砍价成功，已获得价值%@元礼品!",kMeUnNilStr(model.amount_money)];
//
//        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:message];
//        NSRange range1 = [message rangeOfString:kMeUnNilStr(model.amount_money)];
//        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range1];
//        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FEF200"] range:range1];
//        _messageLbl.attributedText = attriStr;
        _messageLbl.text = @"恭喜您，砍价成功";
        [_shareButton setTitle:@"已领取" forState:UIControlStateNormal];
        [_shareButton setTitleColor:kME999999 forState:UIControlStateNormal];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"bargainShareBtnImg_gray"] forState:UIControlStateNormal];
    }else if (model.status == 4) {
        NSString *message = [NSString stringWithFormat:@"砍价失败，还差%.2f元，就成功啦!",[kMeUnNilStr(model.amount_money) floatValue] - [kMeUnNilStr(model.money) floatValue]];
        
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:message];
        NSRange range1 = [message rangeOfString:[NSString stringWithFormat:@"%.2f",[kMeUnNilStr(model.amount_money) floatValue] - [kMeUnNilStr(model.money) floatValue]]];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range1];
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FEF200"] range:range1];
        _messageLbl.attributedText = attriStr;
        
        [_shareButton setTitle:@"重砍一个" forState:UIControlStateNormal];
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
                        self.hourLbl.text = @"00";
                        self.minuteLbl.text = @"00";
                        self.secondLbl.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days > 0) {
                            self.daysLbl.text = [NSString stringWithFormat:@"剩余时间%d天",days];
                        }else {
                            self.daysLbl.text = @"剩余时间";
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
                            self.secondLbl.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLbl.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }else {
            self.hourLbl.text = @"00";
            self.minuteLbl.text = @"00";
            self.secondLbl.text = @"00";
        }
    }
}

- (IBAction)ruleBtnAction:(id)sender {
    if (self.indexBlock) {
        self.indexBlock(0);
    }
}

- (void)tapAction {
    if (self.indexBlock) {
        self.indexBlock(1);
    }
}

- (IBAction)shareAction:(id)sender {
    switch (self.status) {
        case 1://砍价中
        {
            if (self.indexBlock) {
                self.indexBlock(2);
            }
        }
            break;
        case 2://砍价成功 立即领取
        {
            if (self.indexBlock) {
                self.indexBlock(3);
            }
        }
            break;
        case 3://已兑换
        {
        }
            break;
        case 4://砍价失败
        {
            if (self.indexBlock) {
                self.indexBlock(4);
            }
        }
            break;
        default:
            break;
    }
//    if ([btn.titleLabel.text isEqualToString:@"已兑换"]) {
//        return;
//    }
//    if ([btn.titleLabel.text isEqualToString:@"立即领取"]) {
//        if (self.indexBlock) {
//            self.indexBlock(2);
//        }
//    }else if ([btn.titleLabel.text isEqualToString:@"重砍一个"]) {
//        if (self.indexBlock) {
//            self.indexBlock(3);
//        }
//    }
}


@end

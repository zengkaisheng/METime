//
//  TimePickerView.m
//  ME时代
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "TimePickerView.h"

@interface TimePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIControl *background;     //背景蒙版

@property (strong, nonatomic) UIPickerView *pickerView; // 选择器
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题

@property (strong, nonatomic) NSMutableArray *dataArray; // 数据源
@property (copy, nonatomic) NSString *selectStr; // 选中的时间

@property (strong, nonatomic) NSMutableArray *hourArr; // 时数组
@property (strong, nonatomic) NSMutableArray *minuteArr; // 分数组
@property (strong, nonatomic) NSMutableArray *secArr; // 秒数组
@property (strong, nonatomic) NSArray *timeArr; // 当前时间数组

@property (copy, nonatomic) NSString *hour; //选中时
@property (copy, nonatomic) NSString *minute; //选中分
@property (copy, nonatomic) NSString *sec; //选中秒

@end

@implementation TimePickerView

#pragma mark - init
/// 初始化
- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //半透明背景蒙版
        _background = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _background.backgroundColor = [UIColor blackColor];
        _background.alpha = 0.0;
        [_background addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_background];
        
        [self configToolView];
        [self configPickerView];
        
        [self pushDatePicker];
    }
    return self;
}
#pragma mark - 配置界面
/// 配置工具条
- (void)configToolView {
    self.toolView = [[UIView alloc] init];
    self.toolView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 44);
    self.toolView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.toolView];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(self.frame.size.width - 50, 2, 40, 40);
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(10, 2, 40, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.font = [UIFont systemFontOfSize:17];
    self.titleLbl.textColor = [UIColor blackColor];
    [self.toolView addSubview:self.titleLbl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.toolView addSubview:line];
}

/// 配置UIPickerView
- (void)configPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, self.frame.size.height - 44)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    self.isFutureTime = YES;
    [self addSubview:self.pickerView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)show {
    self.dataArray = [NSMutableArray array];
    
    [self.dataArray addObject:self.hourArr];
    [self.dataArray addObject:self.minuteArr];
    [self.dataArray addObject:self.secArr];
    
    self.hour = [NSString stringWithFormat:@"%ld时", [self.timeArr[0] integerValue]];
    self.minute = [NSString stringWithFormat:@"%ld分", [self.timeArr[1] integerValue]];
    self.sec = [NSString stringWithFormat:@"%ld秒", [self.timeArr[2] integerValue]];
    
    /// 重新格式化转一下，是因为如果是09月/日/时，数据源是9月/日/时,就会出现崩溃
    [self.pickerView selectRow:[self.hourArr indexOfObject:self.hour] inComponent:0 animated:YES];
    [self.pickerView selectRow:[self.minuteArr indexOfObject:self.minute] inComponent:1 animated:YES];
    [self.pickerView selectRow:[self.secArr indexOfObject:self.sec] inComponent:2 animated:YES];
}

- (void)pushDatePicker {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.background.alpha = 0.4;
        self.toolView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 44);
        self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, 156);
        [self show];
    }];
}

//蒙版点击时间
- (void)dismissDatePicker {
    if (self.selectBlock) {
        self.selectBlock(@"");
    }
    [self dismissSelf];
}
//消失
- (void)dismissSelf {
    [UIView animateWithDuration:0.2 animations:^{
        self.toolView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 44);
        self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolView.frame), self.frame.size.width, 156);
        self.background.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.toolView removeFromSuperview];
        self.toolView = nil;
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
        [self.background removeFromSuperview];
        self.background = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    //    NSLog(@"点击了保存");
    
    NSString *hour = self.hour.length == 3 ? [NSString stringWithFormat:@"%ld", self.hour.integerValue] : [NSString stringWithFormat:@"0%ld", self.hour.integerValue];
    NSString *minute = self.minute.length == 3 ? [NSString stringWithFormat:@"%ld", self.minute.integerValue] : [NSString stringWithFormat:@"0%ld", self.minute.integerValue];
    NSString *sec = self.sec.length == 3 ? [NSString stringWithFormat:@"%ld", self.sec.integerValue] : [NSString stringWithFormat:@"0%ld", self.sec.integerValue];
    
    self.selectStr = [NSString stringWithFormat:@"%@:%@:%@",hour, minute, sec];
    
    if (self.selectBlock) {
        self.selectBlock(self.selectStr);
    }
    [self dismissSelf];
    
}
/// 取消按钮点击方法
- (void)cancelBtnClick {
    //    NSLog(@"点击了取消");
    if (self.selectBlock) {
        self.selectBlock(@"");
    }
    [self dismissSelf];
}

#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
/// UIPickerView返回多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.dataArray.count;
}

/// UIPickerView返回每组多少条数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  [self.dataArray[component] count] * 200;
}

/// UIPickerView选择哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
//    NSInteger time_integerValue = [self.timeArr[component] integerValue];
    
    switch (component) {
        case 0: { // 时
            // 如果选择的时小于当前时，就刷新到当前时
            if ([self.hourArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[0] integerValue]) {
                if (self.isBeforeTime) {
                    self.hour = self.hourArr[row%[self.dataArray[component] count]];
                }else {
                    [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                }
                // 如果选择的时大于当前时，就直接赋值
            } else {
                self.hour = self.hourArr[row%[self.dataArray[component] count]];
            }
        }
            break;
        case 1: { // 分
            // 如果选择的时大于当前时，就直接赋值
            if ([self.hour integerValue] > [self.timeArr[0] integerValue]) {
                self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                // 如果选择的时等于当前时,就判断分
            } else if ([self.hour integerValue] == [self.timeArr[0] integerValue]) {
                // 如果选择的分小于当前分，就刷新分
                if ([self.minuteArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[1] integerValue]) {
                    if (self.isBeforeTime) {
                        self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                    }else {
                        [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                    }
                    // 如果选择分大于当前分，就直接赋值
                } else {
                    self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                }
            }
        }
            break;
        case 2: { // 秒
            // 如果选择的时大于当前时，就直接赋值
            if ([self.hour integerValue] > [self.timeArr[0] integerValue]) {
                self.minute = self.minuteArr[row%[self.dataArray[component] count]];
                // 如果选择的时等于当前时,就判断分
            } else if ([self.hour integerValue] == [self.timeArr[0] integerValue]) {
                // 如果选择的分大于当前分，就直接赋值
                if ([self.minute integerValue] > [self.timeArr[1] integerValue]) {
                    self.sec = self.secArr[row%[self.dataArray[component] count]];
                    // 如果选择的分等于当前分,就判断秒
                }else if ([self.minute integerValue] == [self.timeArr[1] integerValue]) {
                    // 如果选择的秒小于当前秒，就刷新秒
                    if ([self.secArr[row%[self.dataArray[component] count]] integerValue] < [self.timeArr[2] integerValue]) {
                        if (self.isBeforeTime) {
                            self.sec = self.secArr[row%[self.dataArray[component] count]];
                        }else {
                            [pickerView selectRow:[self.dataArray[component] indexOfObject:self.timeArr[component]] inComponent:component animated:YES];
                        }
                        // 如果选择秒大于当前秒，就直接赋值
                    } else {
                        self.sec = self.secArr[row%[self.dataArray[component] count]];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

/// UIPickerView返回每一行数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
}
/// UIPickerView返回每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}
/// UIPickerView返回每一行的View
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //    NSLog(@"%@", view);
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 30)];
    titleLbl.font = [UIFont systemFontOfSize:20];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = [self.dataArray[component] objectAtIndex:row%[self.dataArray[component] count]];
    [self changeSpearatorLineColor];
    return titleLbl;
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in self.pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor lightGrayColor];//隐藏分割线
        }
    }
}

- (void)pickerViewLoaded:(NSInteger)component row:(NSInteger)row{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%row;
    [self.pickerView selectRow:[self.pickerView selectedRowInComponent:component] % row + base10 inComponent:component animated:NO];
}

- (void)setIsBeforeTime:(BOOL)isBeforeTime
{
    _isBeforeTime = isBeforeTime;
}

- (void)setMinimumDate:(NSString *)minimumDate {
    _minimumDate = minimumDate;
    if (minimumDate.length > 0) {
        NSArray *tempArr = [minimumDate componentsSeparatedByString:@"/"];
        NSArray *unitArr = @[@"时",@"分",@"秒"];
        NSMutableArray *dateArr = [NSMutableArray array];
        for (int i = 0; i < tempArr.count; i++) {
            [dateArr addObject:[NSString stringWithFormat:@"%@%@",tempArr[i],unitArr[i]]];
        }
        self.timeArr = dateArr.mutableCopy;
    }
}

/// 获取小时
- (NSMutableArray *)hourArr {
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%d时", i]];
        }
    }
    return _hourArr;
}

/// 获取分钟
- (NSMutableArray *)minuteArr {
    if (!_minuteArr) {
        _minuteArr = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            [_minuteArr addObject:[NSString stringWithFormat:@"%d分", i]];
        }
    }
    return _minuteArr;
}

/// 获取分钟
- (NSMutableArray *)secArr {
    if (!_secArr) {
        _secArr = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            [_secArr addObject:[NSString stringWithFormat:@"%d秒", i]];
        }
    }
    return _secArr;
}

/// 获取当前的年月日时
- (NSArray *)timeArr {
    if (!_timeArr) {
        _timeArr = [NSArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH时,mm分,ss秒"];
        NSDate *date = [NSDate date];
        NSString *time = [formatter stringFromDate:date];
        _timeArr = [time componentsSeparatedByString:@","];
    }
    return _timeArr;
}

/// 比较选择的时间是否小于当前时间
- (int)compareDate:(NSString *)date01 withDate:(NSString *)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH时,mm分,ss秒"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending: ci=1;break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}


@end

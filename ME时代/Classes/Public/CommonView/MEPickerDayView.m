//
//  MEPickerDayView.m
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import "MEPickerDayView.h"

#define kFirstComponent 0
#define ktopViewHeight 44

@interface MEPickerDayView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    kMeTextBlock _selectedDate;

}

@property(strong,nonatomic)UIPickerView * pickerView;
@property(strong,nonatomic)NSString * selectedDateString;
@property(strong,nonatomic)NSArray * arrayDay;

@end

@implementation MEPickerDayView

- (instancetype)initWithSelectedDate:(kMeTextBlock)selectedDate arrDay:(NSArray*)arrDay{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]){
        _arrayDay = arrDay;
        _selectedDate = selectedDate;
        [self initSomeThing];
    }
    return self;
}

- (void)initSomeThing{
    self.backgroundColor =[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:0.65];
    
    UIView * backGroudView =[[UIView alloc]init];
    backGroudView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
    backGroudView.backgroundColor =[UIColor whiteColor];
    [self addSubview:backGroudView];
    
    UIButton * cancelButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(5, 0, 64, ktopViewHeight);
    [cancelButton setTitleColor:kMEblack forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backGroudView addSubview:cancelButton];
    
    
    UIButton * DoneButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [DoneButton setTitle:@"完成" forState:UIControlStateNormal];
    DoneButton.frame = CGRectMake(SCREEN_WIDTH-69, 0, 64, ktopViewHeight);
    [DoneButton setTitleColor:kMEblack forState:UIControlStateNormal];
    [DoneButton addTarget:self action:@selector(DoneButton) forControlEvents:UIControlEventTouchUpInside];
    [backGroudView addSubview:DoneButton];
    

    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = kMEblack;
    titleLbl.text = @"请选择时间";
    [backGroudView addSubview:titleLbl];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ktopViewHeight, SCREEN_WIDTH, 200)];
    self.pickerView.delegate =self;
    self.pickerView.dataSource = self;
    [backGroudView addSubview:self.pickerView];
}

- (void)cancelButtonClick {
    [self removeFromSuperview];
}

- (void)DoneButton {
    [self removeFromSuperview];
    kMeCallBlock(_selectedDate,_selectedDateString);
}

//返回几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arrayDay.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *dayStr = [_arrayDay objectAtIndex:row];
    return dayStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    [pickerView selectRow:row inComponent:0 animated:YES];
    [pickerView reloadComponent:0];
    
    NSInteger index = [pickerView selectedRowInComponent:0];

    NSString * dayStr = [_arrayDay objectAtIndex:index];
    _selectedDateString = dayStr;
}

@end

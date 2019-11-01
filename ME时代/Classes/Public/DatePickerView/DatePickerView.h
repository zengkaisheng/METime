//
//  DatePickerView.h
//  志愿星
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DatePickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer;

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate;

@end

typedef void (^selectedDate)(NSString *selectDate);

@interface DatePickerView : UIView

@property (nonatomic,assign) BOOL isBeforeTime;   //是否可选择当前时间之前的时间,默认为NO
@property (copy, nonatomic) NSString *title;
@property (nonatomic, copy) NSString *minimumDate;  //设置最小时间
@property (weak, nonatomic) id <DatePickerViewDelegate> delegate;
//@property (nonatomic,copy) NSString *maxDate;//年月日
@property (nonatomic,assign) BOOL isShowHour;     //是否展示时分
@property (nonatomic, assign) BOOL isFutureTime; //是否可选择当前时间之后的时间，默认为yes；

@property (nonatomic, copy) selectedDate selectBlock;

/// 显示
- (void)show;

@end

NS_ASSUME_NONNULL_END

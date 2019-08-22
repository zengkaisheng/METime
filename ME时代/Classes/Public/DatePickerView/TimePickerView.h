//
//  TimePickerView.h
//  ME时代
//
//  Created by gao lei on 2019/8/22.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^selectedDate)(NSString *selectDate);

@interface TimePickerView : UIView

@property (nonatomic,assign) BOOL isBeforeTime;   //是否可选择当前时间之前的时间,默认为NO
@property (copy, nonatomic) NSString *title;
@property (nonatomic, copy) NSString *minimumDate;  //设置最小时间
@property (nonatomic, assign) BOOL isFutureTime; //是否可选择当前时间之后的时间，默认为yes；

@property (nonatomic, copy) selectedDate selectBlock;

/// 显示
- (void)show;

@end

NS_ASSUME_NONNULL_END

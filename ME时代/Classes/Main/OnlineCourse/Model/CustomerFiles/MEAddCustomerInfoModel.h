//
//  MEAddCustomerInfoModel.h
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MEAddCustomerInfoModel : MEBaseModel

@property (nonatomic, assign) BOOL isTextField;    //是否为键盘输入,不为键盘输入则显示箭头
@property (nonatomic, copy) NSString *placeHolder; //默认显示的文字
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *valueId;
@property (nonatomic, assign) NSInteger maxInputWord;//键盘输入最大字符个数

@property (nonatomic, assign) BOOL isLastItem;     //控制是否显示分割线
@property (nonatomic, assign) BOOL isNumberType;   //是否为数字键盘

@property (nonatomic, copy) NSString *toastStr;    //
@property (nonatomic, assign) BOOL isMustInput;    //是否为必填项

@property (nonatomic, assign) BOOL isVoicePutCell; //是否为语音输入cell

@property (nonatomic, assign) BOOL isEdit; //判断当前cell是否可以点击
@property (nonatomic, assign) BOOL isHideArrow;    //是否隐藏箭头
@property (nonatomic, assign) CGFloat offsetL;     //值的左边距

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL isCanCheck;  //是否有查看按钮
@property (nonatomic, assign) BOOL isTextView;  //是否是textView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat orgCellHeight;
@property (nonatomic, assign) BOOL isShowImage;  //是否是展示头像

@end

NS_ASSUME_NONNULL_END

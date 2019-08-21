//
//  DataPickerView.h
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataPickerView : UIView

typedef void (^DataSelect)(NSString *selectData, NSString *selectId);

@property (assign, nonatomic) CGFloat pickerHeight;    //view的自定义高度
@property (copy, nonatomic) NSString *title;           //view的title
@property (copy, nonatomic) NSString *selectedData;    //选中的值
@property (nonatomic, strong) NSArray *dataSource;     //数据源 传入的参数 @[@{@"name":@"儿子",@"val":@"1"}]类型

@property (nonatomic, copy) DataSelect selectBlock;

@end

NS_ASSUME_NONNULL_END

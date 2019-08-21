//
//  DataPickerViewCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/21.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataPickerViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) BOOL isSelected;

@end

@interface DataPickerViewCell : UITableViewCell

- (void)fullCellWithModel:(DataPickerViewModel *)model;

@end

NS_ASSUME_NONNULL_END

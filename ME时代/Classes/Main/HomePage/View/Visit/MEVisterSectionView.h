//
//  MEVisterSectionView.h
//  ME时代
//
//  Created by hank on 2018/11/28.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    MyEnumkMEVisterSectionViewAllType,
    MyEnumkMEVisterSectionViewHopeType,
    MyEnumkMEVisterSectionViewVisterType,
} MyEnumkMEVisterSectionViewType;
const static CGFloat kMEVisterSectionViewHeight = 117;

@interface MEVisterSectionView : UITableViewHeaderFooterView

- (void)setTypeWithType:(MyEnumkMEVisterSectionViewType)type block:(kMeIndexBlock)block;

@end

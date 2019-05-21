//
//  MEAIDataHomeActiveHomeView.h
//  ME时代
//
//  Created by hank on 2019/4/9.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MEAIDataHomeActiveHomeViewAllType = 0,
    MEAIDataHomeActiveHomeViewtodayType = 1,
    MEAIDataHomeActiveHomeViewsevenAllType = 2,
    MEAIDataHomeActiveHomeViewmonthType = 3,
} MEAIDataHomeActiveHomeViewType;

const static CGFloat kMEAIDataHomeActiveHomeViewHeight = 55;

@interface MEAIDataHomeActiveHomeView : UITableViewHeaderFooterView

@property (nonatomic, copy) kMeIndexBlock selectBlock;
- (void)setUiWithType:(MEAIDataHomeActiveHomeViewType)type;

@end

NS_ASSUME_NONNULL_END

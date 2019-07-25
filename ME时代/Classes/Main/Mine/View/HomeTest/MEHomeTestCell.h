//
//  MEHomeTestCell.h
//  ME时代
//
//  Created by by gao lei on 2019/7/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MEHomeTestCellCotentType = 0,
    MEHomeTestListCell,
    MEHomeTestHistoryCell,
} MEHomeTestCellType;


const static CGFloat kMEHomeTestCellHeight = 80;

@interface MEHomeTestCell : UITableViewCell

- (void)setUIWIithType:(MEHomeTestCellType)type;

@end

NS_ASSUME_NONNULL_END

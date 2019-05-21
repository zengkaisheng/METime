//
//  MEAIDataHomeActiveHomeCell.h
//  ME时代
//
//  Created by hank on 2019/4/10.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MEAIDataHomeActiveHomeCellcheckStoreType = 0,
    MEAIDataHomeActiveHomeCellshareStoreType = 1,
    MEAIDataHomeActiveHomeCellcheckpintuanType = 2,
    MEAIDataHomeActiveHomeCellcheckServerType = 3,
} MEAIDataHomeActiveHomeCellType;

const static CGFloat kMEAIDataHomeActiveHomeCellHeight = 46;

@interface MEAIDataHomeActiveHomeCell : UITableViewCell

- (void)setUIWithType:(MEAIDataHomeActiveHomeCellType)type count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END

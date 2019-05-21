//
//  MEBrandAiCell.h
//  ME时代
//
//  Created by hank on 2019/3/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  MEBrandAISortModel;
const static CGFloat kMEBrandAiCellHeight = 65;

@interface MEBrandAiCell : UITableViewCell

- (void)setUIWithModel:(MEBrandAISortModel *)model sortNum:(NSInteger)sortNum;
- (void)setSortUIWithModel:(MEBrandAISortModel *)model sortNum:(NSInteger)sortNum;

@end

NS_ASSUME_NONNULL_END

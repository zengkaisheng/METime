//
//  MEBdataColumnCell.h
//  ME时代
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEBdataColumnCellHeight = 265;

@interface MEBdataColumnCell : UITableViewCell

- (void)setUiWithModel:(NSArray *)model Xtitle:(NSArray *)Xtitle title:(NSString *)title company:(NSString*)company;
- (void)setUiWithModel:(NSArray *)model title:(NSString *)title company:(NSString*)company;
- (void)setUiGoodNumWithModel:(NSArray *)model title:(NSString *)title company:(NSString*)company;
@end

NS_ASSUME_NONNULL_END

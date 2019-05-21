//
//  MEBdataPieCell.h
//  ME时代
//
//  Created by hank on 2019/3/20.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEBdataPieCellHeight = 265;

@interface MEBdataPieCell : UITableViewCell

- (void)setUiWithModel:(NSArray *)model Xtitle:(NSArray*)Xtitle title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END

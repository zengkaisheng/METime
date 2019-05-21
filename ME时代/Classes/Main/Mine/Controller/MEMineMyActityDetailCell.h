//
//  MEMineMyActityDetailCell.h
//  ME时代
//
//  Created by hank on 2019/1/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEMineMyActityDetailCellHeight = 62;

@class  MEMineActiveLeveModel;
@interface MEMineMyActityDetailCell : UITableViewCell

- (void)setUIWIthModel:(MEMineActiveLeveModel *)model finish:(BOOL)finish nowNum:(NSString*)nowNum;

@end

NS_ASSUME_NONNULL_END

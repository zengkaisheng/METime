//
//  MEPAVistorCell.h
//  ME时代
//
//  Created by hank on 2019/4/4.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


const static CGFloat kMEPAVistorCellHeight = 70;
@class MEVistorUserModel;
@interface MEPAVistorCell : UITableViewCell

- (void)setUIWithModel:(MEVistorUserModel *)model;

@end

NS_ASSUME_NONNULL_END

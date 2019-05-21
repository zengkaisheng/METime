//
//  MeCoupleFilterLeftCell.h
//  ME时代
//
//  Created by hank on 2018/12/24.
//  Copyright © 2018 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kLeftTableViewWidth (93*kMeFrameScaleX())
#define kLeftTableViewHeight (45*kMeFrameScaleX())

@interface MeCoupleFilterLeftCell : UITableViewCell

@property (nonatomic, strong) UILabel *name;

@end

NS_ASSUME_NONNULL_END

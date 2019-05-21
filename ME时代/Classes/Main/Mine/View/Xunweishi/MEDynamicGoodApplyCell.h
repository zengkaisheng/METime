//
//  MEDynamicGoodApplyCell.h
//  SunSum
//
//  Created by hank on 2019/3/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEDynamicGoodApplyModel;
const static CGFloat kMEDynamicGoodApplyCellHeight = 538;

@interface MEDynamicGoodApplyCell : UITableViewCell

- (void)setUIWithModel:(MEDynamicGoodApplyModel *)model;
@property (nonatomic,assign) BOOL canEdit;
//        selectImgBlock:(kMeBasicBlock)selectImgBlock;

@end

NS_ASSUME_NONNULL_END

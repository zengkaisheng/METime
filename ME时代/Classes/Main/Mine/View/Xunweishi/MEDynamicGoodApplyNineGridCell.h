//
//  MEDynamicGoodApplyNineGridCell.h
//  SunSum
//
//  Created by hank on 2019/3/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBynamicPublishGridModel;
typedef void (^kMeGridModelBlock)(MEBynamicPublishGridModel *object);
const static CGFloat kMEGridViewMagin = 15;
const static CGFloat kMEGridViewPadding = 6;
#define kMEGridViewOneHeight ((SCREEN_WIDTH - (kMEBynamicPublishGridViewMagin *2) - (kMEBynamicPublishGridViewPadding *2))/3)

@interface MEDynamicGoodApplyNineGridCell : UITableViewCell
- (void)setUIWithArr:(NSMutableArray *)arrModel;
- (void)setUIWithUrlArr:(NSMutableArray *)arrModel;

+ (CGFloat)getCellHeightWithArr:(NSMutableArray *)arrModel;

@property (nonatomic, copy) kMeGridModelBlock selectBlock;
@property (nonatomic, copy) kMeIndexBlock selectIndexBlock;
@property (nonatomic, copy) kMeIndexBlock delBlock;
@property (nonatomic, strong) NSMutableArray *arrImageView;

@end

NS_ASSUME_NONNULL_END

//
//  MEBynamicPublishGridView.h
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBynamicPublishGridModel;
typedef void (^kMePublishGridModelBlock)(MEBynamicPublishGridModel *object);
const static CGFloat kMEBynamicPublishGridViewMagin = 15;
const static CGFloat kMEBynamicPublishGridViewPadding = 6;
#define kMEBynamicPublishGridViewOneHeight ((SCREEN_WIDTH - (kMEBynamicPublishGridViewMagin *2) - (kMEBynamicPublishGridViewPadding *2))/3)

@interface MEBynamicPublishGridView : UIView

+ (CGFloat)getViewHeightWIth:(NSArray *)arr;
- (void)setUIWithArr:(NSArray *)arr;
@property (nonatomic, copy) kMePublishGridModelBlock selectBlock;
@property (nonatomic, copy) kMeIndexBlock delBlock;
@property (nonatomic, strong) NSMutableArray *arrImageView;
@end

NS_ASSUME_NONNULL_END

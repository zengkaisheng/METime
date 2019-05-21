//
//  MEBrandStoryHeaderView.h
//  ME时代
//
//  Created by hank on 2019/4/26.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MEBrandStoryHeaderViewDelegate <NSObject>

- (void)uploadVideo;
- (void)tapTimeAction;
- (void)tapTelAction;
- (void)tapAddressAction;
- (void)tapdetailAddressAction;
- (void)addActionWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEBrandStoryHeaderViewHeight = 580;

@interface MEBrandStoryHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<MEBrandStoryHeaderViewDelegate> deleate;
- (void)clearSelect;
@end

NS_ASSUME_NONNULL_END

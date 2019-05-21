//
//  MEBynamicCommentView.h
//  ME时代
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEBynamicCommentView : UIView

+ (CGFloat )getViewHeightWithArrLike:(NSArray *)arrLike Arrcomment:(NSArray*)arrcomment;
- (void)setUIWithArrLike:(NSArray *)arrLike Arrcomment:(NSArray*)arrcomment;

@end

NS_ASSUME_NONNULL_END

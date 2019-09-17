//
//  MEPersonalCourseHeader.h
//  ME时代
//
//  Created by gao lei on 2019/9/12.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEPersonalCourseHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) kMeBasicBlock tapBlock;

- (void)setUIWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END

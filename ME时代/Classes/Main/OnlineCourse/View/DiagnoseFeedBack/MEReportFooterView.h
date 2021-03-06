//
//  MEReportFooterView.h
//  志愿星
//
//  Created by gao lei on 2019/8/19.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEReportFooterView : UIView

@property (nonatomic, copy) kMeBasicBlock tapBlock;

- (void)setUIWithContent:(NSString *)content phone:(NSString *)phone;
+ (CGFloat)getHeightWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END

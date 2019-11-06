//
//  MEEyesightBottomCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/5.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEEyesightBottomCell : UITableViewCell

- (void)setUIWithContent:(NSString *)content;

+ (CGFloat)getHeightWithContentHeight:(CGFloat)contentHeight;

@end

NS_ASSUME_NONNULL_END

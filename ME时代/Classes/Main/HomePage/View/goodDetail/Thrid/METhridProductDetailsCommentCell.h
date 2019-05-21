//
//  METhridProductDetailsCommentCell.h
//  ME时代
//
//  Created by hank on 2019/1/22.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEThridProductDetailsCommentCellHeight = 177;

@interface METhridProductDetailsCommentCell : UITableViewCell

- (void)setUIWithArr:(NSArray *)arrModel commentNum:(NSString *)commentNum goodNUm:(NSString*)goodNUm;

@end

NS_ASSUME_NONNULL_END

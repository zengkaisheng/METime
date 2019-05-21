//
//  MEArticleAdCell.h
//  ME时代
//
//  Created by hank on 2019/4/25.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEArticleAdCellWdith (SCREEN_WIDTH - 20)
const static CGFloat kMMEArticleAdCellheight = 0.1;



@interface MEArticleAdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;


@end

NS_ASSUME_NONNULL_END

//
//  MEActiveCell.h
//  ME时代
//
//  Created by hank on 2018/10/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMEActiveCellHeight ((180 * kMeFrameScaleY())+24)

@interface MEActiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@end

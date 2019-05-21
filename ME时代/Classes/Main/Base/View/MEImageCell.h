//
//  MEImageCell.h
//  ME时代
//
//  Created by hank on 2018/9/25.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MEImageCellHeight ((SCREEN_WIDTH * 240)/790)
#define MEImageMenberCellHeight ((SCREEN_WIDTH * 1334)/750)
@interface MEImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagePic;;

@end


//
//  MEDistrbutionCell.h
//  ME时代
//
//  Created by hank on 2018/9/11.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMEDistrbutionCellHeight 88
#define kMEDistrbutionCellMargin 1
#define kMEDistrbutionCellWdith ((SCREEN_WIDTH - (kMEDistrbutionCellMargin*2))/3)



@interface MEDistrbutionCell : UICollectionViewCell

- (void)setUIWithtype:(MEDistrbutionCellStyle)type subtitle:(NSString *)subTitle;

@end

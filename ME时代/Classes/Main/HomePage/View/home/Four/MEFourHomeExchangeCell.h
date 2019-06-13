//
//  MEFourHomeExchangeCell.h
//  ME时代
//
//  Created by gao lei on 2019/6/13.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEFourHomeExchangeCellheight     (((SCREEN_WIDTH - 18) * 44)/357)+5

@interface MEFourHomeExchangeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@end

NS_ASSUME_NONNULL_END

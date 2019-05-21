//
//  METhridHomeExchangeCell.h
//  ME时代
//
//  Created by hank on 2019/5/17.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEThridHomeExchangeCellheight     (((SCREEN_WIDTH - 18) * 44)/357)+5

@interface METhridHomeExchangeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPic;

@end

NS_ASSUME_NONNULL_END

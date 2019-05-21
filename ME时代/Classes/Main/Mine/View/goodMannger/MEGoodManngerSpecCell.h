//
//  MEGoodManngerSpecCell.h
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEGoodManngerGoodSpec;
typedef void (^kMeGoodSpeBlock)(MEGoodManngerGoodSpec *model);

@interface MEGoodManngerSpecCell : UITableViewCell

+ (CGFloat)getCellHeightWithArr:(NSArray *)arr;
- (void)setUIWihtArr:(NSArray *)arr;

@property (nonatomic, copy) kMeGoodSpeBlock addBlock;
@property (nonatomic, copy) kMeGoodSpeBlock divBlock;

@end

NS_ASSUME_NONNULL_END

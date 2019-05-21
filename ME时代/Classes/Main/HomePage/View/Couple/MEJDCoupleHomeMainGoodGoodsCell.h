//
//  MEJDCoupleHomeMainGoodGoodsCell.h
//  ME时代
//
//  Created by hank on 2019/2/18.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEJDCoupleHomeMainGoodGoodsCell : UITableViewCell

- (void)setUIWithArr:(NSArray*)arr;
+ (CGFloat)getCellHeightWithArr:(NSArray*)arr;
@property (nonatomic, copy) kMeIndexBlock selectBlock;

@end

NS_ASSUME_NONNULL_END

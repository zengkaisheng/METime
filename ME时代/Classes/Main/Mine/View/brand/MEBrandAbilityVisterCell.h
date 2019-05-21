//
//  MEBrandAbilityVisterCell.h
//  ME时代
//
//  Created by hank on 2019/3/12.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBrandAbilityVisterModel;
const static CGFloat kMEBrandAbilityVisterCellHeight = 78;

@interface MEBrandAbilityVisterCell : UITableViewCell

- (void)setUiWithModel:(MEBrandAbilityVisterModel *)model;

@end

NS_ASSUME_NONNULL_END

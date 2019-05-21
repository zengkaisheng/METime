//
//  MEGoodManngerSpecBasicCell.h
//  ME时代
//
//  Created by hank on 2019/3/28.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEGoodManngerAddSpecModel;
const static CGFloat kMEGoodManngerSpecBasicCellHeight = 358;

@interface MEGoodManngerSpecBasicCell : UITableViewCell

- (void)setUiWihtModel:(MEGoodManngerAddSpecModel*)model;
@property (weak, nonatomic) IBOutlet UIImageView *imgGood;
@property (nonatomic,copy) kMeBasicBlock touchImgBlock;
@property (strong, nonatomic) MEGoodManngerAddSpecModel *model;
- (void)reloadUI;
@end

NS_ASSUME_NONNULL_END

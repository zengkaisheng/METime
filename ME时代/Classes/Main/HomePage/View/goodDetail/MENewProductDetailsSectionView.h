//
//  MENewProductDetailsSectionView.h
//  ME时代
//
//  Created by hank on 2019/1/9.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMENewProductDetailsSectionViewHeight = 55;

@interface MENewProductDetailsSectionView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;

@end

NS_ASSUME_NONNULL_END

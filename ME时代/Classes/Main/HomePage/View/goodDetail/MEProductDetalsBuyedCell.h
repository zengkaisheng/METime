//
//  MEProductDetalsBuyedCell.h
//  ME时代
//
//  Created by hank on 2018/9/8.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEStoreDetailModel;
const static CGFloat kMEProductDetalsBuyedNewCellHeight = 212;
const static CGFloat kMEProductDetalsBuyedCellHeight = 200;

@interface MEProductDetalsBuyedCell : UITableViewCell


- (void)setUIWithArr:(NSArray *)arrModel;
- (void)setServiceUIWithArr:(NSArray *)arrModel;
- (void)setServiceUIWithArr:(NSArray *)arrModel storeDetailModel:(MEStoreDetailModel *)storeDetailModel;

@end

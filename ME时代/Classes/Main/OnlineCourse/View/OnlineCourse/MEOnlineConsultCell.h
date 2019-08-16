//
//  MEOnlineConsultCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEDiagnoseProductModel;

#define kMEOnlineConsultCellHeight 73

@interface MEOnlineConsultCell : UITableViewCell

- (void)setUIWithDict:(NSDictionary *)dict;

- (void)setUIWithModel:(MEDiagnoseProductModel *)model;

@end

NS_ASSUME_NONNULL_END

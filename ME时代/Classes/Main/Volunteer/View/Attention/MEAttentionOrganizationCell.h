//
//  MEAttentionOrganizationCell.h
//  ME时代
//
//  Created by gao lei on 2019/11/8.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MEVolunteerInfoModel;
@class MEAttentionOrganizationsModel;

@interface MEAttentionOrganizationCell : UITableViewCell

@property (nonatomic, copy) kMeBasicBlock tapBlock;
- (void)setOrganizationUIWithModel:(MEAttentionOrganizationsModel *)model;

- (void)setVolunteerUIWithModel:(MEVolunteerInfoModel *)model;

@end

NS_ASSUME_NONNULL_END

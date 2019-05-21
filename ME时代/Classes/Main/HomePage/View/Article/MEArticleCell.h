//
//  MEArticleCell.h
//  ME时代
//
//  Created by hank on 2018/11/27.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEArticelModel;
const static CGFloat kMEArticleCellheight = 111;

@interface MEArticleCell : UITableViewCell

- (void)setUIWithModel:(MEArticelModel *)model;
- (void)setUIWithModel:(MEArticelModel *)model withKey:(NSString *)key;
@end

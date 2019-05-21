//
//  MEOrderSelectStoreCell.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEOrderSelectStoreCellHeight = 73;

@interface MEOrderSelectStoreCell : UITableViewCell

- (void)setUIWithSubtitle:(NSString *)subtitle title:(NSString *)title;

@end

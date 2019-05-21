//
//  METhridHomeTimeSecionView.h
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEThridHomeTimeSecionViewHeight = 55;

@interface METhridHomeTimeSecionView : UITableViewHeaderFooterView

- (void)setUIWithArr:(NSArray *)arrModel selectIndex:(NSInteger)selextIndex selectBlock:(kMeIndexBlock)selectBlock;

@end

NS_ASSUME_NONNULL_END

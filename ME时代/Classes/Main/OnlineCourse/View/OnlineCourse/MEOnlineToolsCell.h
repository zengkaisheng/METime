//
//  MEOnlineToolsCell.h
//  ME时代
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEOnlineToolsCellHeight 198

@interface MEOnlineToolsCell : UITableViewCell

@property (nonatomic,copy) kMeIndexBlock selectedBlock;

- (void)setUIWithHiddenRunData:(BOOL)hidenRunData;

@end

NS_ASSUME_NONNULL_END

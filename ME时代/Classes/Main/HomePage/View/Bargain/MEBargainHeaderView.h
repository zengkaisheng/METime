//
//  MEBargainHeaderView.h
//  志愿星
//
//  Created by gao lei on 2019/6/26.
//  Copyright © 2019年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MEBargainHeaderViewHeight 185

@interface MEBargainHeaderView : UIView

@property (weak, nonatomic) IBOutlet SDCycleScrollView *sdView;
@property (nonatomic,copy) kMeIndexBlock selectedBlock;

- (void)setUIWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

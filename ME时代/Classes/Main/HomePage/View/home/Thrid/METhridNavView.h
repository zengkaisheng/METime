//
//  METhridNavView.h
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMEThridNavViewHeight ((kMeStatusBarHeight)+45)

@interface METhridNavView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewForBack;

@end

NS_ASSUME_NONNULL_END

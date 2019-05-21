//
//  MEAddTbView.h
//  ME时代
//
//  Created by hank on 2019/4/30.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MEAddTbView : UIView

@property (nonatomic, copy) kMeBOOLBlock finishBlock;
@property (nonatomic, copy) NSString *url;
- (void)show;

@end

NS_ASSUME_NONNULL_END

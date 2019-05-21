//
//  MEBynamicPublishGridContentView.h
//  ME时代
//
//  Created by hank on 2019/3/7.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEBynamicPublishGridModel;
@interface MEBynamicPublishGridContentView : UIView

- (void)setUIWithModel:(MEBynamicPublishGridModel*)model;
- (void)setUIWIthUrl:(NSString *)url;
@property (nonatomic, copy) kMeBasicBlock block;
@property (nonatomic,strong)UIImageView *imageVIew;
@end

NS_ASSUME_NONNULL_END

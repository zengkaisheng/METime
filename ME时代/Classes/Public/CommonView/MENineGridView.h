//
//  MENineGridView.h
//  志愿星
//
//  Created by hank on 2019/1/23.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface MENineGridView : UIView


+ (CGFloat)getViewHeightWIth:(NSArray *)arr;
+ (CGFloat)getDymmaincViewHeightWIth:(NSArray *)arr;
- (void)setImageViewWithArr:(NSArray *)arr;
- (void)setImageDymamicViewWithArr:(NSArray *)arr;

- (void)setImagePublicShowWithArr:(NSArray *)arr;
+ (CGFloat)getPublicShowViewHeightWithArr:(NSArray *)arr;

@property (nonatomic, copy)NSMutableArray *arrImageView;
@property (nonatomic, copy) kMeIndexBlock selectBlock;
@end

NS_ASSUME_NONNULL_END

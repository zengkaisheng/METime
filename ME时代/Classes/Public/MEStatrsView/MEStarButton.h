//
//  MEStarButton.h
//  ME时代
//
//  Created by hank on 2018/9/7.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEStarButton : UIButton

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, assign) CGFloat fractionPart;
- (instancetype)initWithSize:(CGSize)size;
- (CGFloat)fractionPartOfPoint:(CGPoint)point;

@end

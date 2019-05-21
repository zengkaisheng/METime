//
//  MEHomeSearchView.h
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kMEHomeSearchViewHeight = 50;

@interface MEHomeSearchView : UIView

@property (nonatomic, copy) kMeBasicBlock searchBlock;
@property (nonatomic, copy) kMeBasicBlock filetBlock;

@end

//
//  MEFilterGoodVC.h
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEFilterGoodVC : MEBaseVC

- (instancetype)initWithcategory_id:(NSString *)category_id title:(NSString *)title;
@property (nonatomic,assign) BOOL isHome;
@end

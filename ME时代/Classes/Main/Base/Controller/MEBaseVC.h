//
//  MEBaseVC.h
//  ME时代
//
//  Created by hank on 2018/9/5.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEBaseVC : UIViewController

/**
 是否隐藏nav
 */
@property (nonatomic, assign)BOOL navBarHidden;
@property (nonatomic, assign) NSInteger recordType;//1、首页 2、优选 3、动态 4、推送 5、搜索

- (void)saveClickRecordsWithType:(NSString *)type params:(NSDictionary *)params;

@end

//
//  MEAiCustomerTagVC.h
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MEAiCustomerTagVC : MEBaseVC

@property (nonatomic , copy)kMeBasicBlock finishBlock;
- (instancetype)initWithArrId:(NSArray *)arrId uid:(NSString*)uid;

@end

NS_ASSUME_NONNULL_END

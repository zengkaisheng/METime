//
//  METickTimerTool.h
//  志愿星
//
//  Created by hank on 2018/9/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TickBlock)(NSTimeInterval);
typedef void (^TickFinishBlock)(void);

@interface METickTimerTool : NSObject


-(void)tickTime:(NSTimeInterval)time tickBlock:(TickBlock)tickBlock finishBlock:(TickFinishBlock) finishBlock;

-(void)stopTick;

@end

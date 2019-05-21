//
//  METickTimerTool.m
//  ME时代
//
//  Created by hank on 2018/9/15.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "METickTimerTool.h"

@interface METickTimerTool ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation METickTimerTool

- (void)dealloc{
    [self stopTick];
}

-(void)tickTime:(NSTimeInterval)time tickBlock:(TickBlock)tickBlock finishBlock:(TickFinishBlock) finishBlock{
    __block NSTimeInterval timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    kMeWEAKSELF
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(weakSelf.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                kMeCallBlock(finishBlock);
                if(finishBlock){
                    finishBlock();
                }
            });
        }else{
            timeout--;
            dispatch_async(dispatch_get_main_queue(), ^{
                kMeCallBlock(tickBlock,timeout);
            });
        }
    });
    dispatch_resume(_timer);
}

-(void)stopTick{
    dispatch_source_cancel(_timer);
}

@end

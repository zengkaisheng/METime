//
//  MEAlertView.h
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEAlertView : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,readonly) NSInteger numberOfButtons;

// create an alert view
- (id)initWithTitle:(NSString *)title message:(NSString *)message;

// add buttons
- (void)addButtonWithTitle:(NSString *)title block:(kMeBasicBlock)block;
- (void)addButtonWithTitle:(NSString *)title;
- (void)show;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

// perform common delegate tasks
- (void)setWillDismissBlock:(kMeBasicBlock)block;
- (void)setDidDismissBlock:(kMeBasicBlock)block;
- (void)setWillPresentBlock:(kMeBasicBlock)block;
- (void)setDidPresentBlock:(kMeBasicBlock)block;

@end

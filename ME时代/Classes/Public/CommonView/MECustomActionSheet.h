//
//  MECustomActionSheet.h
//  ME时代
//
//  Created by hank on 2018/9/14.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

# define kCancelBtnTag 1000

@interface MECustomActionSheet : UIView

@property (nonatomic,assign) CGFloat margin_top;
@property (nonatomic,assign) CGFloat margin_x;
@property (nonatomic,assign) CGFloat margin_betweenBtns;
@property (nonatomic,assign) CGFloat margin_bottom;
@property (nonatomic,assign) CGFloat margin_cancelBtn;
@property (nonatomic,assign) CGSize btnSize;

@property (nonatomic,strong) kMeIndexBlock blockBtnTapHandle;

-(id)initWithTitles:(NSArray *)arrTitles;

-(id)initWithTitle:(NSString *)title btnTitles:(NSArray *)arrTitles;

-(void)show;

@end

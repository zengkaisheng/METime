//
//  MESNewHomePageView.h
//  ME时代
//
//  Created by hank on 2018/11/29.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MESNewHomePageViewDelegate <NSObject> // 代理传值方法
- (void)toNoticeVC;
- (void)toVisterVC;
- (void)toProdectVC;
- (void)toServiceVC;
- (void)toPosterVC;
- (void)toArticelVC;
- (void)toCoupleVC;
- (void)toGiftVC;
- (void)tapBackGround;
- (void)didSdSelectItemAtIndex:(NSInteger)index;
- (void)didAdvdSelectItemAtIndex:(NSInteger)index;
@end

@interface MESNewHomePageView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblNotice;
@property (weak, nonatomic) IBOutlet UILabel *lblVistor;
@property (weak, nonatomic) IBOutlet UILabel *lblPoster;
@property (weak, nonatomic) IBOutlet UILabel *lblArticle;

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;


@property (weak, nonatomic) IBOutlet UIImageView *imgShop;
@property (weak, nonatomic) IBOutlet UIImageView *imgTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgStore;
@property (weak, nonatomic) IBOutlet UIImageView *imgPoster;
@property (weak, nonatomic) IBOutlet UIImageView *imgArticle;
@property (weak, nonatomic) IBOutlet UIImageView *imgCouple;
@property (weak, nonatomic) IBOutlet UIImageView *imgGift;


+ (CGFloat)getViewHeight;
- (void)setSdViewWithArr:(NSArray *)array;
- (void)setAdWithArr:(NSArray *)arr;
@property (nonatomic, weak) id<MESNewHomePageViewDelegate> deleate;

@end

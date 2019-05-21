//
//  METhridHomeNavView.h
//  ME时代
//
//  Created by hank on 2019/1/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kHomeCategoryViewHeight = 39;


NS_ASSUME_NONNULL_BEGIN

@class MEStoreModel;

//const static CGFloat kImgStoreMargin = 5;
//const static CGFloat kImgStore = 44;
//#define kMEThridHomeNavViewHeight (((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 76 : 65)+kImgStore+(k5Margin*4))
#define kMEThridHomeNavViewHeight (((IS_iPhoneX==YES||IS_IPHONE_Xr==YES||IS_IPHONE_Xs==YES||IS_IPHONE_Xs_Max==YES) ? 129 : 107))

@interface METhridHomeNavView : UIView

//- (void)setStroeBackAlpha:(CGFloat)alpha;
//- (void)setBackAlpha:(CGFloat)alpha;
- (void)setRead:(BOOL)read;
//- (void)setStoreInfoWithModel:(MEStoreModel *)model;

//@property (nonatomic ,copy) kMeBasicBlock toStoreBlock;
@property (nonatomic ,copy) kMeIndexBlock selectIndexBlock;
@property (nonatomic ,copy) kMeBasicBlock searchBlock;
@end

NS_ASSUME_NONNULL_END

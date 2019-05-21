//
//  MEStoreApplyView.h
//  ME时代
//
//  Created by hank on 2019/3/21.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MEStoreApplyViewImgBusinnessType = 0,
    MEStoreApplyViewImgMaskType = 1,
    MEStoreApplyViewImgMaskInfoType = 2,
} MEStoreApplyViewImgType;

@class MEStoreApplyParModel;
const static CGFloat kMEStoreApplyViewHeight = 1198;

@interface MEStoreApplyView : UIView

//- (instancetype)initWithFrame:(CGRect)frame Model:(MEStoreApplyParModel *)model;
@property (nonatomic, copy) kMeIndexBlock selectImgBlock;
@property (weak, nonatomic) IBOutlet UIImageView *imgbusiness;
@property (weak, nonatomic) IBOutlet UIImageView *imgMask;
@property (weak, nonatomic) IBOutlet UIImageView *imgMaskInfo;
@property (strong, nonatomic) MEStoreApplyParModel *model;

- (void)reloadUI;
@property (nonatomic, copy) kMeBasicBlock locationBlock;
@property (nonatomic, copy) kMeBasicBlock applyBlock;

@end

NS_ASSUME_NONNULL_END

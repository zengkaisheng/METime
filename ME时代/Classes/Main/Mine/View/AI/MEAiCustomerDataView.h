//
//  MEAiCustomerDataView.h
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MEAiCustomerDataModel;
const static CGFloat kMEAiCustomerDataViewHeight = 773;

@interface MEAiCustomerDataView : UIView

@property (nonatomic, copy) kMeBasicBlock saveBlock;
@property (nonatomic, strong) MEAiCustomerDataModel *model;
- (void)reloadUI;
@end

NS_ASSUME_NONNULL_END

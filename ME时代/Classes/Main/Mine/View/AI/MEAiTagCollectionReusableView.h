//
//  MEAiTagCollectionReusableView.h
//  ME时代
//
//  Created by hank on 2019/4/11.
//  Copyright © 2019 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

const static CGFloat kMEAiTagCollectionReusableViewHeight = 50;


@interface MEAiTagCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

NS_ASSUME_NONNULL_END

//
//  MESkuByReusableView.h
//  ME时代
//
//  Created by Hank on 2018/9/10.
//  Copyright © 2018年 hank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMESkuByReusableViewHeight  54

@interface MESkuByReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIView *topVIew;

@end

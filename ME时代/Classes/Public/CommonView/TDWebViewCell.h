//
//  TDWebViewCell.h
//  TDEarthVillage
//
//  Created by Hank on 2017/7/11.
//  Copyright © 2017年 Hank. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTDWebViewCellDidFinishLoad @"TDWebViewCellDidFinishLoad"
#define kTDWebViewCellDidFinishLoadNotification  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadWebViewHeight) name:kTDWebViewCellDidFinishLoad object:nil];
#define kTDWebViewCellDidFinishLoadNotificationCancel [[NSNotificationCenter defaultCenter] removeObserver:self];
//#define kTDWebViewCellDidFinishLoadNotificationMethod -(void)reloadWebViewHeight{[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];[MBProgressHUD hideHUDForView:self.view];}

#define kTDWebViewCellDidFinishLoadNotificationMethod -(void)reloadWebViewHeight{[self.tableView reloadData];[MBProgressHUD hideHUDForView:self.view];}

@interface TDWebViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;
    
@end

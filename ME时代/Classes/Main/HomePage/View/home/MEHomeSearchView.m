//
//  MEHomeSearchView.m
//  ME时代
//
//  Created by hank on 2018/11/1.
//  Copyright © 2018年 hank. All rights reserved.
//

#import "MEHomeSearchView.h"
#import "MEMidelButton.h"

@interface MEHomeSearchView ()

@property (weak, nonatomic) IBOutlet UIView *viewForSearch;

@end

@implementation MEHomeSearchView

- (void)awakeFromNib{
    [super awakeFromNib];
    _viewForSearch.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tuchSearchView:)];
    [_viewForSearch addGestureRecognizer:ges];
}

- (void)tuchSearchView:(UITapGestureRecognizer *)ges{
    kMeCallBlock(_searchBlock);
}

- (IBAction)filtAction:(MEMidelButton *)sender {
    kMeCallBlock(_filetBlock);
}


@end

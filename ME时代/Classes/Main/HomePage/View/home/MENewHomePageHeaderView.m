//
//  MENewHomePageHeaderView.m
//  ME时代
//
//  Created by hank on 2018/11/5.
//  Copyright © 2018年 hank. All rights reserved.
//  

#import "MENewHomePageHeaderView.h"
#import "MEAdModel.h"
#import "MEMidelButton.h"
#import "MEProductSearchVC.h"
#import "MENewHomePage.h"
#import "MEFilterVC.h"
//#import "MENoticeVC.h"
#import "MENoticeTypeVC.h"
#import "MERCConversationListVC.h"

@interface MENewHomePageHeaderView ()<JXCategoryViewDelegate>{
    NSArray *_arrModel;
    UIButton *_oldBtn;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arrBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

//@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end
@implementation MENewHomePageHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
//    self.categoryView.lineStyle = JXCategoryLineStyle_None;
//    self.categoryView.titles = @[@"推荐",@"活动",@"产品",@"服务"];
//    self.categoryView.delegate = self;
//    self.categoryView.titleSelectedColor = kMEPink;
    [_arrBtn enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = kMeViewBaseTag + idx;

    }];
    _oldBtn = _arrBtn[0];
    _oldBtn.selected = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)];
    _searchView.userInteractionEnabled = YES;
    [_searchView addGestureRecognizer:ges];
//    [_btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
}

- (void)returnCommon{
    _oldBtn.selected = NO;
    _oldBtn = _arrBtn[0];
     _lineView.centerX = _oldBtn.centerX;
    _oldBtn.selected = YES;
//    self.categoryView.defaultSelectedIndex = 0;
//    [self.categoryView reloadDatas];
//    [self.categoryView selectItemWithIndex:0];
//    [self.categoryView reloadDatas];
}

//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
//    kMeCallBlock(_selectMemuBlock,index);
//    NSLog(@"%@",@(index));
//}

- (IBAction)selectAction:(UIButton *)sender {
    _oldBtn.selected = NO;
    sender.selected = YES;
    _oldBtn = sender;
    NSInteger tag = sender.tag-kMeViewBaseTag;
    _lineView.centerX = sender.centerX;
    kMeCallBlock(_selectMemuBlock,tag);
}


- (void)searchAction:(UITapGestureRecognizer *)ges{
    MENewHomePage *home = (MENewHomePage *)[MECommonTool getVCWithClassWtihClassName:[MENewHomePage class] targetResponderView:self];
    if(home){
        MEProductSearchVC *svc = [[MEProductSearchVC alloc]init];
        [home.navigationController pushViewController:svc animated:NO];
    }

}

- (IBAction)messageAction:(UIButton *)sender {
    MENewHomePage *home = (MENewHomePage *)[MECommonTool getVCWithClassWtihClassName:[MENewHomePage class] targetResponderView:self];
    if(home){
        [home.navigationController popViewControllerAnimated:YES];
    }
//    if([MEUserInfoModel isLogin]){
//        [self toChat];
//    }else{
//        kMeWEAKSELF
//        [MEWxLoginVC presentLoginVCWithSuccessHandler:^(id object) {
//            kMeSTRONGSELF
//            [strongSelf toChat];
//        } failHandler:nil];
//    }
}

- (void)toChat{
    MENewHomePage *home = (MENewHomePage *)[MECommonTool getVCWithClassWtihClassName:[MENewHomePage class] targetResponderView:self];
    if([kCurrentUser.mobile isEqualToString:AppstorePhone]){
        MERCConversationListVC *svc = [[MERCConversationListVC alloc]init];
        [home.navigationController pushViewController:svc animated:YES];
    }else{
        if(home){
            MENoticeTypeVC *svc = [[MENoticeTypeVC alloc]init];
            [home.navigationController pushViewController:svc animated:YES];
        }
    }
}

- (IBAction)filterAction:(MEMidelBigImageButton *)sender {
    MENewHomePage *home = (MENewHomePage *)[MECommonTool getVCWithClassWtihClassName:[MENewHomePage class] targetResponderView:self];
    if(home){
        MEFilterVC *svc = [[MEFilterVC alloc]init];
        [home.navigationController pushViewController:svc animated:YES];
    }

}


@end

//
//  MEAudioCourseVC.m
//  志愿星
//
//  Created by gao lei on 2019/8/1.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEAudioCourseVC.h"
#import "MEAudioCourseBaseVC.h"
#import "MEourseClassifyModel.h"

@interface MEAudioCourseVC ()<JXCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong)NSMutableArray *arrType;
@property (nonatomic, strong)NSMutableArray *arrModel;

@end

@implementation MEAudioCourseVC

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (_type) {
        case 0:
        {
            self.title = @"在线视频";
            [self getVideoTypeWithNetworking];
        }
            break;
        case 1:
        {
            self.title = @"在线音频";
            [self getAudioTypeWithNetworking];
        }
            break;
        case 2:
            self.title = @"收费频道";
            break;
        case 3:
            self.title = @"免费频道";
            break;
        default:
            break;
    }
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
}

- (void)setupUI {
    CGFloat categoryViewHeight = kCategoryViewHeight;
    if (self.arrModel.count < 2) {
        categoryViewHeight = 0.1;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kMeNavBarHeight+kCategoryViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-categoryViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *_arrType.count, SCREEN_HEIGHT-kMeNavBarHeight-categoryViewHeight);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _arrType.count; i++) {
        MEAudioCourseBaseVC *VC = [[MEAudioCourseBaseVC alloc] initWithType:self.type index:i materialArray:[_arrModel copy]];
        VC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        VC.view.frame = CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, SCREEN_HEIGHT-kMeNavBarHeight-categoryViewHeight);
        [self addChildViewController:VC];
        [self.scrollView addSubview:VC.view];
    }
    
    [self.view addSubview:self.scrollView];
    
    //1、初始化JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kMeNavBarHeight, SCREEN_WIDTH, categoryViewHeight)];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 30 *kMeFrameScaleX();
    lineView.indicatorLineViewColor = kMEPink;
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    
    self.categoryView.titles = _arrType;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = kMEPink;
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titleColor =  [UIColor colorWithHexString:@"999999"];
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = 0;
}

#pragma mark ---- Networking
//视频分类
- (void)getVideoTypeWithNetworking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetVideoClassifyWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.arrModel = [MEourseClassifyModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            MEourseClassifyModel *model = [[MEourseClassifyModel alloc] init];
            model.video_type_name = @"推荐";
            model.idField = 0;
            [strongSelf.arrModel insertObject:model atIndex:0];
            
            [strongSelf->_arrModel enumerateObjectsUsingBlock:^(MEourseClassifyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                [strongSelf.arrType addObject:model.video_type_name];
            }];
        }
        [strongSelf setupUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//音频分类
- (void)getAudioTypeWithNetworking {
    kMeWEAKSELF
    [MEPublicNetWorkTool postGetAudioClassifyWithSuccessBlock:^(ZLRequestResponse *responseObject) {
        kMeSTRONGSELF
        if ([responseObject.data isKindOfClass:[NSArray class]]) {
            strongSelf.arrModel = [MEourseClassifyModel mj_objectArrayWithKeyValuesArray:responseObject.data];
            MEourseClassifyModel *model = [[MEourseClassifyModel alloc] init];
            model.audio_type_name = @"推荐";
            model.idField = 0;
            [strongSelf.arrModel insertObject:model atIndex:0];
            
            [strongSelf->_arrModel enumerateObjectsUsingBlock:^(MEourseClassifyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                [strongSelf.arrType addObject:model.audio_type_name];
            }];
        }
        [strongSelf setupUI];
    } failure:^(id object) {
        kMeSTRONGSELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)pushlishAction:(UIButton *)btn{
    
}

#pragma MARK - Setter
- (UIButton *)btnRight{
    if(!_btnRight){
        _btnRight= [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRight setImage:[UIImage imageNamed:@"icon_push"] forState:UIControlStateNormal];
        [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnRight.cornerRadius = 2;
        _btnRight.clipsToBounds = YES;
        _btnRight.frame = CGRectMake(0, 0, 30, 30);
        _btnRight.titleLabel.font = kMeFont(15);
        [_btnRight addTarget:self action:@selector(pushlishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (NSMutableArray *)arrType {
    if (!_arrType) {
        _arrType = [[NSMutableArray alloc] init];
    }
    return _arrType;
}

- (NSMutableArray *)arrModel {
    if (!_arrModel) {
        _arrModel = [[NSMutableArray alloc] init];
    }
    return _arrModel;
}

@end

//
//  MEFourHomeNoticeHeaderView.m
//  ME时代
//
//  Created by gao lei on 2019/7/24.
//  Copyright © 2019年 hank. All rights reserved.
//

#import "MEFourHomeNoticeHeaderView.h"
#import "MEAdModel.h"

@interface MEFourHomeNoticeHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *topTitles;
@property (nonatomic, strong) NSMutableArray *bottomTitles;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;

@end

@implementation MEFourHomeNoticeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUIWithArray:(NSArray *)array leftBanner:(MEAdModel *)leftBanner{
    kSDLoadImg(_leftImageV, kMeUnNilStr(leftBanner.ad_img));
    if (self.topTitles.count > 0) {
        [self.topTitles removeAllObjects];
    }
    if (self.bottomTitles.count > 0) {
        [self.bottomTitles removeAllObjects];
    }
    _sdView.contentMode = UIViewContentModeScaleAspectFill;
    _sdView.clipsToBounds = YES;
    
//    __block NSMutableArray *arrTitles = [NSMutableArray array];
//    [array enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        [arrTitles addObject:kMeUnNilStr(model.ad_name)];
//    }];
//        [tempArr enumerateObjectsUsingBlock:^(MEAdModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (idx%2 == 0) {
//                [arrTitles addObject:kMeUnNilStr(model.ad_name)];
//            }else {
//                [arrTitles1 addObject:kMeUnNilStr(model.ad_name)];
//            }
    
//        }];
    
    for (int i = 0; i < array.count; i++) {
        MEAdModel *model = array[i];
//        NSLog(@"name:%@====下标：%d",model.ad_name,i);
        if (i%2 == 0) {
            [self.topTitles addObject:kMeUnNilStr(model.ad_name)];
        }else {
            [self.bottomTitles addObject:kMeUnNilStr(model.ad_name)];
        }
        if (i == array.count - 1) {
            if (i%2 == 0) {
                [self.bottomTitles addObject:@"  "];
            }
        }
    }
    
    _sdView.titlesGroup = self.topTitles;
    _sdView.onlyDisplayText = YES;
    _sdView.delegate = self;
    _sdView.titleLabelBackgroundColor = [UIColor whiteColor];
    _sdView.backgroundColor = [UIColor whiteColor];
    _sdView.scrollDirection = UICollectionViewScrollDirectionVertical;
    _sdView.titleLabelTextFont = [UIFont systemFontOfSize:13];
    _sdView.titleLabelTextColor = kME333333;
    _sdView.titleLabelHeight = 15;
    _sdView.titleLabelTextAlignment = NSTextAlignmentLeft;
    
    _sdView.infiniteLoop = YES;
    _sdView.autoScroll = YES;
    _sdView.autoScrollTimeInterval = 4;
    
    
    _sdView1.titlesGroup = self.bottomTitles;
    _sdView1.onlyDisplayText = YES;
    _sdView1.delegate = self;
    _sdView1.titleLabelBackgroundColor = [UIColor whiteColor];
    _sdView1.backgroundColor = [UIColor whiteColor];
    _sdView1.scrollDirection = UICollectionViewScrollDirectionVertical;
    _sdView1.titleLabelTextFont = [UIFont systemFontOfSize:13];
    _sdView1.titleLabelTextColor = kME333333;
    _sdView1.titleLabelHeight = 15;
    _sdView1.titleLabelTextAlignment = NSTextAlignmentLeft;
    
    _sdView1.infiniteLoop = YES;
    _sdView1.autoScroll = YES;
    _sdView1.autoScrollTimeInterval = 4;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView == _sdView) {
        kMeCallBlock(_selectedIndexBlock,index*2);
    }else if (cycleScrollView == _sdView1) {
        NSString *string = self.bottomTitles[index];
        if (![string isEqualToString:@"  "]) {
            kMeCallBlock(_selectedIndexBlock,index*2+1);
        }
    }
}

- (NSMutableArray *)topTitles {
    if (!_topTitles) {
        _topTitles = [[NSMutableArray alloc] init];
    }
    return _topTitles;
}

- (NSMutableArray *)bottomTitles {
    if (!_bottomTitles) {
        _bottomTitles = [[NSMutableArray alloc] init];
    }
    return _bottomTitles;
}

@end

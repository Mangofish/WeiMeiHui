//
//  ArtShareSheetView.m
//  LWShareView
//
//  Created by LeeWong on 2018/1/9.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import "LWShareSheetView.h"
#import "LWShareContentView.h"
#import "UIColor+LW.h"
//#import <Masonry.h>

@interface LWShareSheetView ()
@property (nonatomic, strong) LWShareContentView *contentView;

@end

@implementation LWShareSheetView

+(instancetype)shareSheetViewWithType:(NSUInteger)type{
    
    LWShareSheetView *instance = [[LWShareSheetView alloc]init];
    instance.type = type;
    [instance buildUI];
    
    return instance;
    
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor clearColor];
//        [self buildUI];
//    }
//    return self;
//}
//
//+(instancetype)shareSheetViewWithType{
//
//    LWShareSheetView *instance = [[LWShareSheetView alloc]init];
//    return instance;
//
//}


- (void)buildUI
{
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@50);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
}


- (void)setShareBtnClickBlock:(void (^)(NSUInteger))shareBtnClickBlock
{
    _shareBtnClickBlock = shareBtnClickBlock;
    self.contentView.shareBtnClickBlock = shareBtnClickBlock;

}

+ (NSInteger)sectionCount
{
    NSInteger count = 0;
    if ([LWShareSheetView topMenus].count > 0) {
        count += 1;
    }
    if ([LWShareSheetView bottomMenus].count > 0) {
        count += 1;
    }
    return count;
}

#pragma mark - Lazy Load


- (LWShareContentView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[LWShareContentView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 12;
        _contentView.layer.masksToBounds = YES;
        _contentView.topMenus = [LWShareSheetView topMenus];
    
        [self addSubview:_contentView];
    }
    
    if (_type == 2) {
        _contentView.bottomMenus = [LWShareSheetView bottomMenusTwo];
    }else{
        _contentView.bottomMenus = [LWShareSheetView bottomMenus];
    }
    return _contentView;
}

- (UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelBtn.layer.cornerRadius = 12;
        _cancelBtn.layer.masksToBounds = YES;
        [self addSubview:_cancelBtn]; 
    }
    return _cancelBtn;
}

+ (NSArray *)topMenus
{
    return @[@{kShareIcon:@"朋友圈",kShareTitle:@""},@{kShareIcon:@"分享微信",kShareTitle:@""},@{kShareIcon:@"分享新浪微博",kShareTitle:@""},@{kShareIcon:@"QQ",kShareTitle:@""}];
}

+ (NSArray *)bottomMenus
{
    return @[@{kShareIcon:@"分享QQ空间",kShareTitle:@""},
             @{kShareIcon:@"复制链接",kShareTitle:@""},@{kShareIcon:@"举报",kShareTitle:@""}];
    
}

+ (NSArray *)bottomMenusTwo
{
    return @[@{kShareIcon:@"分享QQ空间",kShareTitle:@""},
             @{kShareIcon:@"复制链接",kShareTitle:@""}];
    
}


@end

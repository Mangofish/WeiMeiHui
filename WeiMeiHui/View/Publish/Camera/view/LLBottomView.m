//
//  LLBottomView.m
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/9/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "LLBottomView.h"
#import "LLAnimationRecordView.h"
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface LLBottomView()

@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) LLAnimationRecordView *recordBtnView;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *switchBtn;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation LLBottomView

- (instancetype)init
{
    if (self = [super init]) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    self.backgroundColor = [UIColor clearColor];
    [self.recordBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(120));
        make.bottom.equalTo(self).offset(-28.);
        make.centerX.equalTo(self);
    }];
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.recordBtnView.mas_top);
        make.centerX.equalTo(self.recordBtnView);
    }];
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:WEIVIDEO] boolValue]) {
        
        self.tipLabel.hidden = YES;
    }
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recordBtnView);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtnView);
        make.right.equalTo(self.mas_right).offset(-58);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtnView);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtnView);
        make.bottom.equalTo(self).offset(-79.);
        make.left.equalTo(self.mas_left).offset(58);
    }];
    
    WEAKSELF(weakSelf);
    self.recordBtnView.startRecord = ^(){
        if (weakSelf.startRecord) {
            weakSelf.startRecord();
        }
        [weakSelf hideBtn];
    };
    
    self.recordBtnView.completeRecord = ^(CFTimeInterval recordTime){
        if (weakSelf.stopRecord) {
            weakSelf.stopRecord(recordTime);
        }
        [weakSelf remakeBtnLayout];
    };
    
//    self.recordBtnView.startPhotos = ^{
//        if (weakSelf.startPhoto) {
//            weakSelf.startPhoto();
//        }
//        [weakSelf remakeBtnLayout];
//    };
    
//    拍照完成
    self.recordBtnView.completePhoto = ^{
        if (weakSelf.photoComplete) {
            weakSelf.photoComplete();
        }
        [weakSelf remakeBtnLayout];
        [weakSelf hideBtn];
    };
    
}

- (void)remakeBtnLayout
{
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(75));
        make.right.equalTo(self).offset(-37.);
        make.bottom.equalTo(self).offset(-55.);
    }];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(75));
        make.left.equalTo(self).offset(37.);
        make.bottom.equalTo(self.sendBtn);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtnView);
        make.right.equalTo(self.mas_right).offset(-58);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
//        [self layoutIfNeeded];
        self.sendBtn.alpha = 1.;
        self.cancelBtn.alpha = 1.;
        self.switchBtn.alpha = 0;
        self.recordBtnView.alpha = 0.;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)resetBtnLayout
{
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recordBtnView);
    }];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recordBtnView);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtnView);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
//        [self layoutIfNeeded];
        self.sendBtn.alpha = 0.;
        self.cancelBtn.alpha = 0.;
        self.switchBtn.alpha = 0;
        self.recordBtnView.alpha = 1.;
    }];
}

- (void)showBtn
{
    self.backBtn.hidden = NO;
    self.tipLabel.hidden = NO;
    self.tipLabel.alpha = 1.0;
    [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tipLabel.alpha = 0.;
    } completion:^(BOOL finished) {
        self.tipLabel.hidden = YES;
    }];
}

- (void)hideBtn {
    self.backBtn.hidden = YES;
    self.tipLabel.hidden = YES;
}

//MARK: lazy

- (LLAnimationRecordView *)recordBtnView
{
    if(!_recordBtnView){
        _recordBtnView = [[LLAnimationRecordView alloc] init];
         
        [self addSubview:_recordBtnView];
    }
    
    
    return _recordBtnView;
}

- (UIButton *)sendBtn
{
    if(!_sendBtn){
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setImage:[UIImage imageNamed:@"record_finish"] forState:UIControlStateNormal];
        
        [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _sendBtn.alpha = 0.;
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}

- (UIButton *)switchBtn
{
    if(!_switchBtn){
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setImage:[UIImage imageNamed:@"切换镜头"] forState:UIControlStateNormal];
        
        [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        _switchBtn.alpha = 0.;
        [self addSubview:_switchBtn];
    }
    return _switchBtn;
}

- (void)switchAction:(UIButton *)sender{
    
    WEAKSELF(weakSelf)
    if (weakSelf.switchComplete) {
        weakSelf.switchComplete();
    }
    
}

- (void)sendAction:(UIButton *)sender{
    
    WEAKSELF(weakSelf)
    if (weakSelf.sendComplete) {
        weakSelf.sendComplete();
    }
    
}

- (UIButton *)cancelBtn
{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"record_cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];

        _cancelBtn.alpha = 0.;
        [self addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (void)cancelAction:(UIButton *)sender{
        WEAKSELF(weakSelf)
    
        [weakSelf showBtn];
        [weakSelf resetBtnLayout];
        if (weakSelf.cancelComplete) {
            weakSelf.cancelComplete();
            }
}

- (UIButton *)backBtn
{
    if(!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(1, 1);
        shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
        shadow.shadowBlurRadius = 6;
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc]initWithString:@"取 消" attributes:@{
                                                                                                              NSFontAttributeName:[UIFont boldSystemFontOfSize:15.],
                                                                                                              NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                              NSShadowAttributeName:shadow
                                                                                                              }];
        [_backBtn setAttributedTitle:one forState:UIControlStateNormal];
//        WEAKSELF(weakSelf)
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}

- (void)backAction:(UIButton *)sender{
    
    WEAKSELF(weakSelf)
    if (weakSelf.backComplete) {
        weakSelf.backComplete();
    }
    
}

- (UILabel *)tipLabel
{
    if(!_tipLabel){
        _tipLabel = [[UILabel alloc] init];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(1, 1);
        shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
        shadow.shadowBlurRadius = 6;
        
        NSMutableAttributedString *one;
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:WEIVIDEO] boolValue]) {
            
            one = [[NSMutableAttributedString alloc]initWithString:@"轻触拍照" attributes:@{
                                                                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:15.],
                                                                                               NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                               NSShadowAttributeName:shadow
                                                                                               }];
            
        }else{
            
            one = [[NSMutableAttributedString alloc]initWithString:@"长按开始录制,轻触拍照" attributes:@{
                                                                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:15.],
                                                                                               NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                               NSShadowAttributeName:shadow
                                                                                               }];
            
        }
        
        _tipLabel.attributedText = one;
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end

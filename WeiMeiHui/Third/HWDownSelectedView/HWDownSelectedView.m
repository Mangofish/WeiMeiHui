//
//  HWDownSelectedView.m
//  HWDownSelectedTF
//
//  Created by HanWei on 15/12/15.
//  Copyright © 2015年 AndLiSoft. All rights reserved.
//

#import "HWDownSelectedView.h"

/// 动画的时间
NSTimeInterval const animationDuration = 0.2f;

/// 分割线的颜色
#define kLineColor [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1]

CGFloat angleValue(CGFloat angle) {
    return (angle * M_PI) / 180;
}

@interface HWDownSelectedView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField *contentLabel;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *arrowImgBgView;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, assign) BOOL isOpen;


@property (nonatomic, strong) UIView *maskView;

/// 执行打开关闭动画是否结束
@property (nonatomic, assign) BOOL beDone;

@end

@implementation HWDownSelectedView

#pragma mark - life cycle 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commintInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _commintInit];
    }
    return self;
}

#pragma mark - private
- (void)_commintInit
{
    /// 默认设置
    //self.backgroundColor = [UIColor whiteColor];
    
    _font = [UIFont systemFontOfSize:14.f];
    _textColor = [UIColor blackColor];
    _textAlignment = NSTextAlignmentLeft;
    _selectedIndex = 0;
    /// 默认不展开
    _isOpen = NO;
    
    /// 默认是完成动画的
    _beDone = YES;
    
    /// 初始化UI
    
    
//    [self.arrowImgBgView addSubview:self.arrowImgView];
    [self addSubview:self.arrowImgBgView];
//    [self addSubview:self.contentLabel];
    [self addSubview:self.clickBtn];
    
}


-(UIView *)maskView{
    
    if (!_maskView) {
        
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.origin.y+self.frame.size.height, kWidth, kHeight)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [_maskView addGestureRecognizer:tap];
        
    }
    
    return _maskView;
}

#pragma mark - action
- (void)clickBtnClicked
{
    //NSLog(@"btn clicked");
    
    if (!_beDone) return;
    
    /// 关闭页面上其他下拉控件
    for (UIView *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[HWDownSelectedView class]] && subview != self) {
            HWDownSelectedView *donwnSelectedView = (HWDownSelectedView *)subview;
            if (donwnSelectedView.isOpen) {
                [donwnSelectedView close];
            }
        }
    }

    if (_isOpen) {
        [self close];
    } else {
        [self show];
    }
}

#pragma mark - public
- (void)show
{
    if (_isOpen || _listArray.count == 0) return;

    _beDone = NO;
    
    [self.superview addSubview:self.maskView];
    [self.superview addSubview:self.listTableView];
    /// 避免被其他子视图遮盖住
    [self.superview bringSubviewToFront:self.listTableView];
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.superview.frame), 0);
    [self.listTableView setFrame:frame];
    self.listTableView.rowHeight = 44;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
    
                         if (self.listArray.count > 0) {
                             [self.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                       atScrollPosition:UITableViewScrollPositionTop
                                                               animated:YES];
                         }
                         
                         CGRect frame = self.listTableView.frame;
                         NSInteger count = self.listArray.count;
                         frame.size.height = count * 44;
                         
                         /// 防止超出屏幕
                         if (frame.origin.y + frame.size.height > [UIScreen mainScreen].bounds.size.height) {
                             frame.size.height -= frame.origin.y + frame.size.height - [UIScreen mainScreen].bounds.size.height;
                         }
                         [self.listTableView setFrame:frame];
                         
                         self.arrowImgView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {

                         _beDone = YES;
                         _isOpen = YES;

                     }
     ];
}

- (void)close
{
    if (!_isOpen) return;
    
    _beDone = NO;
    [self.maskView removeFromSuperview];
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.listTableView.frame;
                         frame.size.height = 0.f;
                         [self.listTableView setFrame:frame];
                         
//                         self.arrowImgView.transform = CGAffineTransformRotate(self.arrowImgView.transform, angleValue(-180));
                     }
                     completion:^(BOOL finished) {
                         
                         [self.listTableView setContentOffset:CGPointZero animated:NO];
                         if (self.listTableView.superview) [self.listTableView removeFromSuperview];
                         
                         _beDone = YES;
                         _isOpen = NO;
                         
                     }
     ];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
        contentLable.tag = 1000;
        contentLable.textColor = FontColor;
        contentLable.font = [UIFont systemFontOfSize:14];
        [cell addSubview:contentLable];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kLineColor;
        lineView.frame = CGRectMake(0, 44-0.5, kWidth, 0.5);
        [cell addSubview:lineView];
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"确定"]];
        img.frame = CGRectMake(kWidth-14-Space, 20, 12, 8);
        [cell addSubview:img];
        img.tag = 66;
        img.hidden = YES;
    }
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:1000];
    contentLabel.text = _listArray[indexPath.row];
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:66];
    
    if (indexPath.row == _selectedIndex) {
        contentLabel.textColor = MainColor;
        img.hidden = NO;
    }else{
        contentLabel.textColor = FontColor;
        img.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.clickBtn setTitle:[_listArray objectAtIndex:indexPath.row] forState:UIControlStateNormal ];
    _selectedIndex = indexPath.row;
    [self.listTableView reloadData];
    
    [self close];
    if ([self.delegate respondsToSelector:@selector(downSelectedView:didSelectedAtIndex:)]) {
        [self.delegate downSelectedView:self didSelectedAtIndex:indexPath];
    }
}


#pragma mark - Public

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.contentLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.contentLabel.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    self.contentLabel.textAlignment = textAlignment;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.contentLabel.placeholder = placeholder;
}

- (void)setListArray:(NSArray *)listArray
{
    _listArray = listArray;
//    改frame
//   CGFloat clickWidth = [listArray[_selectedIndex] textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:14].lineHeight)].width;
//    self.clickBtn.frame = CGRectMake(self.clickBtn.frame.origin.x, self.clickBtn.frame.origin.y, clickWidth, self.clickBtn.frame.size.height);
//
    
    [self.clickBtn setTitle:listArray[_selectedIndex] forState:UIControlStateNormal];
    [self.clickBtn setImage:[UIImage imageNamed:@"向下2"] forState:UIControlStateNormal];
    [self.clickBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [self.listTableView reloadData];
}

- (NSString *)text
{
    return self.contentLabel.text;
}

#pragma mark - getter

- (UITextField *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UITextField new];
        _contentLabel.placeholder = @"点击进行选择";
        _contentLabel.enabled = NO;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = _textColor;
        _contentLabel.font = _font;
        _contentLabel.textAlignment = _textAlignment;
    }
    return _contentLabel;
}

- (UIButton *)clickBtn
{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.backgroundColor = [UIColor clearColor];
        [_clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(clickBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _clickBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _clickBtn;
}

- (UIImageView *)arrowImgView
{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = [UIImage imageNamed:@"向下2"];
//        _arrowImgView.transform = CGAffineTransformRotate(self.arrowImgView.transform, angleValue(-180));
    }
    return _arrowImgView;
}

- (UIView *)arrowImgBgView
{
    if (!_arrowImgBgView) {
        _arrowImgBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _arrowImgBgView.backgroundColor = [UIColor clearColor];
    }
    return _arrowImgBgView;
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.layer.borderWidth = 0.5;
        _listTableView.layer.borderColor = kLineColor.CGColor;
        _listTableView.scrollsToTop = NO;
        _listTableView.bounces = NO;
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = kLineColor;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _listTableView;
}

#pragma mark - Layout

- (void)updateConstraints
{
    //NSLog(@"updateConstraints");
    
    // 箭头
//    self.arrowImgView.translatesAutoresizingMaskIntoConstraints = NO;
//    [NSLayoutConstraint activateConstraints:@[
//                                              [NSLayoutConstraint constraintWithItem:self.arrowImgView
//                                                                           attribute:NSLayoutAttributeCenterX
//                                                                           relatedBy:NSLayoutRelationEqual
//                                                                              toItem:self.arrowImgBgView
//                                                                           attribute:NSLayoutAttributeCenterX
//                                                                          multiplier:1.0
//                                                                            constant:-10],
//                                              [NSLayoutConstraint constraintWithItem:self.arrowImgView
//                                                                           attribute:NSLayoutAttributeCenterY
//                                                                           relatedBy:NSLayoutRelationEqual
//                                                                              toItem:self.arrowImgBgView
//                                                                           attribute:NSLayoutAttributeCenterY
//                                                                          multiplier:1.0
//                                                                            constant:0.0]
//                                              ]];
    
    self.arrowImgBgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.arrowImgBgView
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.arrowImgBgView
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.arrowImgBgView
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:self.arrowImgBgView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:30]
                                              ]];
    
    
    self.clickBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [NSLayoutConstraint constraintWithItem:self.clickBtn
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0
                                                                            constant:-20],
                                              [NSLayoutConstraint constraintWithItem:self.clickBtn
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:self.clickBtn
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              [NSLayoutConstraint constraintWithItem:self.clickBtn
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0
                                                                            constant:0.0],
                                              ]];
    [self.clickBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [super updateConstraints];
}

@end

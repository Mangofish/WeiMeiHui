//
//  CustomSegmentControl.m
//  SwipeTableView
//
//  Created by Roy lee on 16/5/28.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "CustomSegmentControl.h"

#define RGBColor(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface CustomSegmentControl ()

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) UIView * line;

@end

@implementation CustomSegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        if (items.count > 0) {
            self.items = items;
        }
    }
    return self;
}

- (void)commonInit {
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_contentView];
    _font = [UIFont systemFontOfSize:15];
    _textColor = RGBColor(50, 50, 50);
    _selectedTextColor = RGBColor(0, 0, 0);
    _selectionIndicatorColor = RGBColor(150, 150, 150);
    _items = @[@"Segment0",@"Segment1"];
    _selectedSegmentIndex = 0;
    
    _line = [UIView new];
    _line.frame = CGRectMake(0, 0, 20, 2);
    _line.backgroundColor = [UIColor redColor];
     [self addSubview:_line];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _contentView.frame = self.bounds;
    for (int i = 0; i < _items.count; i ++) {
        UIButton * itemBt = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBt.tag = 666 + i;
        [itemBt setBackgroundColor: [UIColor whiteColor]];
        [itemBt setTitleColor:_textColor forState:UIControlStateNormal];
        [itemBt setTitleColor:_selectedTextColor forState:UIControlStateSelected];
        [itemBt setTitle:_items[i] forState:UIControlStateNormal];
        [itemBt.titleLabel setFont:_font];
        CGFloat itemWidth = self.st_width/_items.count;
        itemBt.st_size = CGSizeMake(itemWidth, 44);
        itemBt.st_x    = itemWidth * i;
        itemBt.st_y    = 10;
        if (i == _selectedSegmentIndex) {
            itemBt.selected = YES;
            
            _line.frame = CGRectMake(CGRectGetMidX(itemBt.frame) - 10, 45, 20, 2);
            
        }
        [itemBt addTarget:self action:@selector(didSelectedSegment:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:itemBt];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    UIButton * oldItemBt      = [_contentView viewWithTag:666 + _selectedSegmentIndex];

    oldItemBt.selected        = NO;
    
    UIButton * itemBt      = [_contentView viewWithTag:666 + selectedSegmentIndex];

    itemBt.selected        = YES;
    _selectedSegmentIndex  = selectedSegmentIndex;
    
    [UIView animateWithDuration:0.5 animations:^{
        self->_line.frame = CGRectMake(CGRectGetMidX(itemBt.frame) - 10, 45, 20, 2);
    }];
}

- (void)didSelectedSegment:(UIButton *)itemBt {
    UIButton * oldItemBt      = [_contentView viewWithTag:666 + _selectedSegmentIndex];
    oldItemBt.selected        = NO;
    itemBt.selected        = YES;
    _selectedSegmentIndex  = itemBt.tag - 666;
    if (self.IndexChangeBlock) {
        self.IndexChangeBlock(_selectedSegmentIndex);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    [UIView animateWithDuration:0.5 animations:^{
        self->_line.frame = CGRectMake(CGRectGetMidX(itemBt.frame) - 10, 45, 20, 2);
    }];
}

@end






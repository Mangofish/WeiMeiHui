//
//  MyOrderListTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyOrderListTableViewCell.h"
#import "NormalContentLabel.h"

@interface MyOrderListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *taglab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceLab;
@property (weak, nonatomic) IBOutlet UIView *orderBg;

@property (weak, nonatomic) IBOutlet UIView *contenBg;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;

@property (strong, nonatomic)  NormalContentLabel *contentAttributedLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation MyOrderListTableViewCell

+(instancetype)myOrderListTableViewCell{
    return [[NSBundle mainBundle]loadNibNamed:@"MyOrderListTableViewCell" owner:nil options:nil][0];
}

- (void)configLocation{
    
    _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
    _contentAttributedLabel.text = _order.content;
    [self.contenBg addSubview:_contentAttributedLabel];
    _contenBg.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+10+15+20+15);
    
    [_taglab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contenBg.mas_left).offset(Space);
        make.top.equalTo(_contenBg.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contenBg.mas_right).offset(-Space);
        make.top.equalTo(_contenBg.mas_top).offset(Space);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    
    [_serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contenBg.mas_left).offset(Space);
        make.bottom.equalTo(_contenBg.mas_bottom).offset(-15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(kWidth-Space*2));
    }];
    
    _cellHeight = 90 + CGRectGetHeight(_contenBg.frame);
    
}

- (void)setOrder:(MyOrderList *)order{
    _order = order;
    _orderNum.text = [NSString stringWithFormat:@"订单编号：%@",order.order_number];
    _taglab.text = _order.service_type;
   
    
    switch ([order.status integerValue]) {
        case 0:
             _state.text = @"待接单";
            _state.textColor = MainColor;
            _bottomText.textColor = MJRefreshColor(51, 51, 51);;
            break;
        case 1:
            _state.text = @"已接单";
            _state.textColor = MJRefreshColor(90, 111, 230);
            _bottomText.textColor = MainColor;
            break;
        case 2:
            _state.text = @"已支付";
            _state.textColor = MJRefreshColor(46, 160, 242);
            _bottomText.textColor = MJRefreshColor(51, 51, 51);;
            break;
        case 3:
            _state.text = @"待评价";
            _state.textColor = MJRefreshColor(242, 177, 46);
            _bottomText.textColor = MJRefreshColor(51, 51, 51);;
            break;
        case 4:
            _state.text = @"已评价";
            _state.textColor = MJRefreshColor(51, 51, 51);
            _bottomText.textColor = MJRefreshColor(51, 51, 51);;
            break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 14:
            _state.text = @"已取消";
            _state.textColor = MJRefreshColor(153, 153, 153);
            _bottomText.textColor = MJRefreshColor(153, 153, 153);
            break;
           
        case 9:
            _state.text = @"退款中";
            _state.textColor = MJRefreshColor(153, 153, 153);
            _bottomText.textColor = MJRefreshColor(153, 153, 153);
            break;
        case 10:
            _state.text = @"退款驳回";
            _state.textColor = MJRefreshColor(153, 153, 153);
            _bottomText.textColor = MJRefreshColor(153, 153, 153);
            break;
        case 11:
        case 12:
            _state.text = @"退款成功";
            _state.textColor = MJRefreshColor(153, 153, 153);
            _bottomText.textColor = MJRefreshColor(153, 153, 153);
            break;
        case 13:
            _state.text = @"退款失败";
            _state.textColor = MJRefreshColor(153, 153, 153);
            _bottomText.textColor = MJRefreshColor(153, 153, 153);
            break;
        case 15:
            _state.text = @"已被其他手艺人服务";
            _state.textColor = MJRefreshColor(153, 153, 153);
            _bottomText.textColor = MJRefreshColor(153, 153, 153);
            break;
        default:
            break;
    }
    
    _priceLab.text = order.price;
    _serviceLab.text = [NSString stringWithFormat:@"服务区域：%@",order.area];;
    _bottomText.text = order.author_time;
    [self configLocation];
    
}

- (void)setOrderDetail:(MyOrderList *)orderDetail{
    _order = orderDetail;
    _orderNum.text = [NSString stringWithFormat:@"订单编号：%@",orderDetail.order_number];
    _taglab.text = _order.service_type;
    _state.hidden = YES;
    _bottomView.hidden = YES;
     [self configLocation];
    
     _cellHeight = 44 + CGRectGetHeight(_contenBg.frame);
}

@end

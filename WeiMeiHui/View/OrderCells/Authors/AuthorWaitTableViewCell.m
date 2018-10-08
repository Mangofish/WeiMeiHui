//
//  AuthorWaitTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorWaitTableViewCell.h"
#import "AuthorWorkCollectionViewCell.h"
#import "NormalContentLabel.h"
#import "LHPhotoBrowser.h"

@interface AuthorWaitTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSInteger _second;
    NSInteger _secondPay;
}

@property (strong, nonatomic)  UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIView *introBg;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic)  UILabel *serviceLab;

//yet
@property (weak, nonatomic) IBOutlet UILabel *yetOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *yetPrice;
@property (weak, nonatomic) IBOutlet UILabel *yetTag;
@property (weak, nonatomic) IBOutlet UIView *introYet;

//other
@property (weak, nonatomic) IBOutlet UILabel *cancelOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *introCancel;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cancelTag;
@property (weak, nonatomic) IBOutlet UILabel *cancelPrice;
//

@property (weak, nonatomic) IBOutlet UILabel *orderNumPayBack;

@property (weak, nonatomic) IBOutlet UILabel *namePayBack;
@property (weak, nonatomic) IBOutlet UILabel *pricePayBack;

@property (weak, nonatomic) IBOutlet UIImageView *iconPayBack;
@property (weak, nonatomic) IBOutlet UILabel *tagPayBack;
@property (weak, nonatomic) IBOutlet UIView *introPayBack;

@property (strong, nonatomic)  NormalContentLabel *contentAttributedLabel;
@property (weak, nonatomic) IBOutlet UIView *paybackBottom;



@property (strong, nonatomic)  NSTimer *timer;
@property (strong, nonatomic)  NSTimer *timerPay;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIButton *messageYet;
@property (weak, nonatomic) IBOutlet UIButton *messageCancel;
@property (weak, nonatomic) IBOutlet UIButton *confirmPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *messagePayBtn;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation AuthorWaitTableViewCell

+(instancetype)authorWaitTableViewCellWait{
    
    AuthorWaitTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorWaitTableViewCell" owner:nil options:nil][0];
    
    return instance;
}

+(instancetype)authorWaitTableViewCellYet{
    
    AuthorWaitTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorWaitTableViewCell" owner:nil options:nil][1];
    
    return instance;
}

+(instancetype)authorWaitTableViewCellCancel{
    
    AuthorWaitTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorWaitTableViewCell" owner:nil options:nil][2];
    
    return instance;
}

+(instancetype)authorWaitTableViewCellPayback{
    
    AuthorWaitTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorWaitTableViewCell" owner:nil options:nil][3];
    
    return instance;
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    AuthorWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.workImg sd_setImageWithURL:[NSURL URLWithString:_order.pics[indexPath.item]]];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        return _order.pics.count;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorWorkCollectionViewCell *cell = (AuthorWorkCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = @[cell.workImg];
    bc.imgUrlsArray = @[ _order.pics[indexPath.item] ];
    bc.tapImgIndex = 0;
    bc.hideStatusBar = NO;
    [bc show];
    
}


- (void)configLocation{
    
    CGFloat itemW = (kWidth-Space*2-30)/4;
    _orderNum.text = _order.order_number;
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introBg.mas_left).offset(Space);
        make.top.equalTo(_introBg.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    
    _tagLab.text = _order.service_name;
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_introBg.mas_right).offset(-Space);
        make.top.equalTo(_introBg.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    _priceLab.text = _order.price;
    
    if (_order.pics.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [_introBg addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _introBg.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+25+itemW+10);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        
    }else{
        _introBg.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+25);
        
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        
        
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _contentAttributedLabel.text = _order.content;
    [self.introBg addSubview:_contentAttributedLabel];
    _confirmBtn.tag = self.tag;
    _iconBtn.tag = self.tag;
}

- (void)setConfigWithSecond:(NSInteger)second {
    _second = second;
    if (_second > 0) {
        self.countDownLab.text = [self ll_timeWithSecond:_second];
    }
    else {
        self.countDownLab.text = @"00:00";
    }
}

- (void)setConfigWithSecondPay:(NSInteger)second{
    _secondPay = second;
    if (_secondPay > 0) {
        self.countLab.text = [self ll_timeWithSecond:_secondPay];
    }
    else {
        self.countLab.text = @"00:00";
    }
}

- (void)timerRun:(NSTimer *)timer {
    
    if (_second > 0) {
        self.countDownLab.text = [self ll_timeWithSecond:_second];
        _second -= 1;
    }
    else {
        self.countDownLab.text = @"00:00";
    }
}

- (void)timerRunPay:(NSTimer *)timer {
    
    if (_secondPay > 0) {
        self.countLab.text = [self ll_timeWithSecond:_secondPay];
        _secondPay -= 1;
    }
    else {
        self.countLab.text = @"00:00";
    }
}


- (void)removeFromSuperview {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [super removeFromSuperview];
}

//将秒数转换为字符串格式
- (NSString *)ll_timeWithSecond:(NSInteger)second
{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"%02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",second/3600,(second-second/3600*3600)/60,second%60];
        }
    }
    return time;
}




//已接单
- (void)configLocation2{
    
     CGFloat itemW = (kWidth - 30- Space*2)/4;
    [_yetTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introYet.mas_left).offset(Space);
        make.top.equalTo(_introYet.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    _yetOrderNum.text = _orderYet.order_number;
    _yetTag.text = _orderYet.service_name;
    _yetPrice.text = [NSString stringWithFormat:@"%@",_orderYet.price];;
    [_yetPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_introYet.mas_right).offset(-Space);
        make.top.equalTo(_introYet.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    
    if (_order.pics.count) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [_introYet addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
         _introYet.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+30+itemW);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
    }else{
        
         _introYet.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+20);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(10,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
    }
    
    
    _contentAttributedLabel.text = _order.content;
    [self.introYet addSubview:_contentAttributedLabel];
    
    _cellHeight = 89 + CGRectGetHeight(_introYet.frame);
    _messageYet.tag = self.tag;
    _iconBtn.tag = self.tag;
}

//已取消
- (void)configLocation3{
    
    CGFloat itemW = (kWidth - 30- Space*2)/4;
    
    [_icon sd_setImageWithURL:[NSURL urlWithNoBlankDataString:_order.image]];
    _name.text = _order.nickname;
    
    [_cancelTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introCancel.mas_left).offset(Space);
        make.top.equalTo(_introCancel.mas_top).offset(Space);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    _cancelOrderNum.text = _order.order_number;
    _cancelTag.text = _order.service_name;
    _cancelPrice.text = [NSString stringWithFormat:@"%@",_order.price];
    [_cancelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_introCancel.mas_right).offset(-Space);
        make.top.equalTo(_introCancel.mas_top).offset(Space);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    
    if (_order.pics.count) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [_introCancel addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _introCancel.frame = CGRectMake(0, 100, kWidth, _order.contentHeight+15+24+35+itemW);
         _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        
    }else{
        _introCancel.frame = CGRectMake(0, 100, kWidth, _order.contentHeight+15+24+20);
         _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(10,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        
    }
    
    _delBtn.tag = self.tag;
    _iconBtn.tag = self.tag;
    _messageCancel.tag = self.tag;
    _contentAttributedLabel.text = _order.content;
    [self.introCancel addSubview:_contentAttributedLabel];
    _iconBtn.tag = self.tag;
    _cellHeight = 145 + CGRectGetHeight(_introCancel.frame);
   
}

//退款
- (void)configLocation4{
    
    CGFloat itemW = (kWidth - 30- Space*2)/4;
    
    [_tagPayBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introPayBack.mas_left).offset(Space);
        make.top.equalTo(_introPayBack.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    _orderNumPayBack.text = _order.order_number;
    _tagPayBack.text = _order.service_name;
    _pricePayBack.text = [NSString stringWithFormat:@"%@",_order.price];;
    [_pricePayBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_introPayBack.mas_right).offset(-Space);
        make.top.equalTo(_introPayBack.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    
    [_iconPayBack sd_setImageWithURL:[NSURL urlWithNoBlankDataString:_order.image]];
    _namePayBack.text = _order.nickname;
    _iconPayBack.tag = self.tag;
    _iconBtn.tag = self.tag;
    
    if (_order.pics.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [_introPayBack addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _introPayBack.frame = CGRectMake(0, 100, kWidth, _order.contentHeight+15+24+20+itemW+Space);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        
    }else{
        _introPayBack.frame = CGRectMake(0, 100, kWidth, _order.contentHeight+15+24+20+Space);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(10,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
    }
    
    
    _contentAttributedLabel.text = _order.content;
    [_introPayBack addSubview:_contentAttributedLabel];
    
    _timerPay = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRunPay:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
    [[NSRunLoop currentRunLoop] addTimer:_timerPay forMode:NSRunLoopCommonModes];
    
    _cellHeight = 144 + CGRectGetHeight(_introPayBack.frame);
 
    _confirmPayBtn.tag = self.tag;
    _messagePayBtn.tag = self.tag;
    
}



//选择其他手艺人
- (void)setOrderchooseOther:(AuthorOrdersModel *)orderchooseOther{
    
    _order = orderchooseOther;
    _bottomView.hidden = YES;
    [self configLocation];
    _cellHeight = 45  + CGRectGetHeight(_introBg.frame);
    
    _tagLab.backgroundColor = MJRefreshColor(153, 153, 153);
    _status.text = @"已选择其他手艺人";
    _status.textColor = [UIColor darkGrayColor];
    _priceLab.textColor = FontColor;
    _priceLab.text= [NSString stringWithFormat:@"%@",orderchooseOther.price];
    
}

//订单已取消
-(void)setOrderCancel:(AuthorOrdersModel *)orderCancel{
    _order = orderCancel;
    
    _bottomView.hidden = YES;
    [self configLocation];
    _cellHeight = 45  + CGRectGetHeight(_introBg.frame);
    
    _tagLab.backgroundColor = MJRefreshColor(153, 153, 153);
    _status.text = @"订单已取消";
    _status.textColor = [UIColor darkGrayColor];
    _priceLab.textColor = FontColor;
    _priceLab.text= [NSString stringWithFormat:@"%@",orderCancel.price];
    
}

//已支付
- (void)setOrderPay:(AuthorOrdersModel *)orderPay{
    
    _orderPay = orderPay;
    _order = orderPay;
    _paybackBottom.hidden = YES;
    _statusPayBack.text = @"已支付";
     [self configLocation4];
    _cellHeight = 100  + CGRectGetHeight(_introPayBack.frame);
    _iconBtn.tag = self.tag;
    
    
}

//待接单
- (void)setOrder:(AuthorOrdersModel *)order{
    _order = order;
    [self configLocation];
    _cellHeight = 89 + CGRectGetHeight(_introBg.frame);
}

//已接单
- (void)setOrderYet:(AuthorOrdersModel *)orderYet{
    _order = orderYet;
    _orderYet = orderYet;
    [self configLocation2];
}

//已完成
-(void)setOrderFinish:(AuthorOrdersModel *)orderFinish{
    
    _order = orderFinish;
    _orderFinish = orderFinish;
    [self configLocation3];
    
    
}

//用户申请退款
-(void)setOrderPayBack:(AuthorOrdersModel *)orderPayBack{
    
    _order = orderPayBack;
    _orderPayBack = orderPayBack;
    [self configLocation4];
    
}

//退款完成
- (void)setOrderPayBackFinish:(AuthorOrdersModel *)orderPayBackFinish{
    
    _order = orderPayBackFinish;
    _orderPayBack = orderPayBackFinish;
    [self configLocation4];
    _paybackBottom.hidden = YES;
    _statusPayBack.text = @"退款完成";
    _cellHeight = 100 + CGRectGetHeight(_introPayBack.frame);
}

//拒绝退款
- (void)setOrderPayBackReject:(AuthorOrdersModel *)orderPayBackReject{
    _order = orderPayBackReject;
    _orderPayBack = orderPayBackReject;
    [self configLocation4];
    _paybackBottom.hidden = YES;
    _statusPayBack.text = @"拒绝退款";
    _cellHeight = 100 + CGRectGetHeight(_introPayBack.frame);
}

-(void)setOrderPayBackAllow:(AuthorOrdersModel *)orderPayBackAllow{
    _order = orderPayBackAllow;
    _orderPayBack = orderPayBackAllow;
    [self configLocation4];
    _paybackBottom.hidden = YES;
    _statusPayBack.text = @"退款中";
    _cellHeight = 100 + CGRectGetHeight(_introPayBack.frame);
}

-(void)setOrderDetail:(AuthorOrdersModel *)orderDetail{
    
    _order = orderDetail;
    _bottomView.hidden = YES;
    [self configLocationDetail];
    
}

- (void)setMainOrder:(MainOrderStatusWait *)mainOrder{
    
    _mainOrder = mainOrder;
    _bottomView.hidden = YES;
    [self configLocationDetail];
    
}

- (void)configLocationMainDetail{
    
    CGFloat itemW = (kWidth-Space*2-30)/4;
//    _orderNum.text = _mainOrder.order_number;
    _status.hidden = YES;
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introBg.mas_left).offset(Space);
        make.top.equalTo(_introBg.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    
    _tagLab.text = _order.service_name;
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_introBg.mas_right).offset(-Space);
        make.top.equalTo(_introBg.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    _priceLab.text = [NSString stringWithFormat:@"%@-%@",_order.min_price,_order.max_price];
    
    if (_order.pics.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [_introBg addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _introBg.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+25+itemW+24+Space);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        _serviceLab = [[UILabel alloc]init];
        _serviceLab.text = _order.dumps_name;
        _serviceLab.textColor = LightFontColor;
        _serviceLab.font = [UIFont systemFontOfSize:14];
        _serviceLab.frame = CGRectMake(Space, CGRectGetMaxY(_contentAttributedLabel.frame)+Space, kWidth-Space*2, 24);
        [self.introBg addSubview:_serviceLab];
        
    }else{
        _introBg.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+25+24+Space);
        
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        _serviceLab = [[UILabel alloc]init];
        _serviceLab.text = _order.dumps_name;
        _serviceLab.textColor = LightFontColor;
        _serviceLab.font = [UIFont systemFontOfSize:14];
        _serviceLab.frame = CGRectMake(Space, CGRectGetMaxY(_contentAttributedLabel.frame)+Space, kWidth-Space*2, 24);
        [self.introBg addSubview:_serviceLab];
        
    }
    
    
    _contentAttributedLabel.text = _order.content;
    [self.introBg addSubview:_contentAttributedLabel];
    _cellHeight = 44 + CGRectGetHeight(_introBg.frame);
}

- (void)configLocationDetail{
    
    CGFloat itemW = (kWidth-Space*2-30)/4;
    _orderNum.text = _order.order_number;
    _status.hidden = YES;
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introBg.mas_left).offset(Space);
        make.top.equalTo(_introBg.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    
    _tagLab.text = _order.service_name;
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_introBg.mas_right).offset(-Space);
        make.top.equalTo(_introBg.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    _priceLab.text = [NSString stringWithFormat:@"%@元-%@元",_order.min_price,_order.max_price];
    
    if (!_order.min_price) {
        _priceLab.text = [NSString stringWithFormat:@"%@",_order.price];
    }
    
    if (_order.pics.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [_introBg addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _introBg.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+25+itemW+24+Space);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        
        _serviceLab = [[UILabel alloc]init];
        _serviceLab.text = _order.dumps_name;
        
        _serviceLab.textColor = LightFontColor;
        _serviceLab.font = [UIFont systemFontOfSize:14];
        _serviceLab.frame = CGRectMake(Space, CGRectGetMaxY(_contentAttributedLabel.frame)+Space, kWidth-Space*2, 24);
        [self.introBg addSubview:_serviceLab];
        
    }else{
        _introBg.frame = CGRectMake(0, 45, kWidth, _order.contentHeight+15+24+25+24+Space);
        
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        _serviceLab = [[UILabel alloc]init];
        _serviceLab.text = _order.dumps_name;
        _serviceLab.textColor = LightFontColor;
        _serviceLab.font = [UIFont systemFontOfSize:14];
        _serviceLab.frame = CGRectMake(Space, CGRectGetMaxY(_contentAttributedLabel.frame)+Space, kWidth-Space*2, 24);
        [self.introBg addSubview:_serviceLab];
        
    }
    
    
    _contentAttributedLabel.text = _order.content;
    [self.introBg addSubview:_contentAttributedLabel];
    _cellHeight = 44 + CGRectGetHeight(_introBg.frame);
}

-(void)setOrderPayDetail:(AuthorOrdersModel *)orderPayDetail{
    
    _orderPayDetail = orderPayDetail;
    _order = orderPayDetail;
    _paybackBottom.hidden = YES;
    
    if ([orderPayDetail.status integerValue] == 2 ) {
        _statusPayBack.text = @"已支付";
    }
    
    if ([orderPayDetail.status integerValue] == 3 || [orderPayDetail.status integerValue] == 4) {
        _statusPayBack.text = @"已完成";
    }
    
    [self configLocationDetailPay];
    _cellHeight = 100  + CGRectGetHeight(_introPayBack.frame);
    
}

- (void)configLocationDetailPay{
    
    CGFloat itemW = (kWidth-Space*2-30)/4;
    _orderNumPayBack.text = _order.order_number;
    _status.hidden = YES;
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introPayBack.mas_left).offset(Space);
        make.top.equalTo(_introPayBack.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(43));
    }];
    
    _tagLab.text = _order.service_name;
    
    [_pricePayBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_introPayBack.mas_right).offset(-Space);
        make.top.equalTo(_introPayBack.mas_top).offset(15);
        make.height.equalTo(@(24));
        make.width.equalTo(@(200));
    }];
    
    _pricePayBack.text = _order.price;
    
    [_iconPayBack sd_setImageWithURL:[NSURL urlWithNoBlankDataString:_order.image]];
    _namePayBack.text = _order.nickname;
    _iconPayBack.tag = self.tag;
    
    if (_order.pics.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [_introPayBack addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _introPayBack.frame = CGRectMake(0, 100, kWidth, _order.contentHeight+15+24+25+itemW+24+Space);
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        _serviceLab = [[UILabel alloc]init];
        _serviceLab.text = [NSString stringWithFormat:@"服务区域：%@",_order.service_area];
        _serviceLab.textColor = LightFontColor;
        _serviceLab.font = [UIFont systemFontOfSize:14];
        _serviceLab.frame = CGRectMake(Space, CGRectGetMaxY(_contentAttributedLabel.frame)+Space, kWidth-Space*2, 24);
        [self.introPayBack addSubview:_serviceLab];
        
    }else{
        _introPayBack.frame = CGRectMake(0, 100, kWidth, _order.contentHeight+15+24+25+24+Space);
        
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,50,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
        _serviceLab = [[UILabel alloc]init];
        _serviceLab.text =[NSString stringWithFormat:@"服务区域：%@",_order.service_area];
        _serviceLab.textColor = LightFontColor;
        _serviceLab.font = [UIFont systemFontOfSize:14];
        _serviceLab.frame = CGRectMake(Space, CGRectGetMaxY(_contentAttributedLabel.frame)+Space, kWidth-Space*2, 24);
        [self.introPayBack addSubview:_serviceLab];
        
    }
    
    _contentAttributedLabel.text = _order.content;
    [self.introPayBack addSubview:_contentAttributedLabel];
//    _cellHeight = 44 + CGRectGetHeight(_introPayBack.frame);
    
    
}


- (IBAction)confirmAction:(UIButton *)sender {
    [self.delegate didClickTakeOrder:sender.tag];
}

- (IBAction)messageAction:(UIButton *)sender {
    
    [self.delegate didClickMessageBtn:sender.tag];
    
}

- (IBAction)deleteAction:(UIButton *)sender {
    
    [self.delegate didClickDelOrder:sender.tag];
    
}


- (IBAction)chooseIcon:(UIButton *)sender {
    
    [self.delegate didClickIcon:sender.tag];
}

- (IBAction)allowAcion:(UIButton *)sender {
    
    [self.delegate didClickAllowOrder:sender.tag];
}
@end

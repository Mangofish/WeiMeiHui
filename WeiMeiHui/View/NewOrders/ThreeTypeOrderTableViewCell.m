//
//  ThreeTypeOrderTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ThreeTypeOrderTableViewCell.h"
#import "UIButton+WebCache.h"

@interface ThreeTypeOrderTableViewCell (){
    
    NSInteger _second;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *shopLan;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab;
@property (weak, nonatomic) IBOutlet UILabel *disPrice;
@property (weak, nonatomic) IBOutlet UILabel *orgPrice;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *restTime;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

//@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (strong, nonatomic)  NSTimer *timer;

@end

@implementation ThreeTypeOrderTableViewCell

+(instancetype)threeTypeOrderTableViewCell{
    
    ThreeTypeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeTypeOrderTableViewCell" owner:self options:nil][0];
    
    cell.rightBtn.frame = CGRectMake(kWidth-Space-60, 75, 60, 30);
    cell.leftBtn.frame = CGRectMake(kWidth-Space-80-60, 75, 60, 30);
    
    cell.leftBtn.layer.cornerRadius = 5;
    cell.leftBtn.layer.masksToBounds = YES;
    
    cell.rightBtn.layer.cornerRadius = 5;
    cell.rightBtn.layer.masksToBounds = YES;
    
    cell.gradeLab.layer.cornerRadius = 4;
    cell.gradeLab.layer.masksToBounds = YES;
    
    cell.iconBtn.layer.cornerRadius = 20;
    cell.iconBtn.layer.masksToBounds = YES;
    return cell;
    
}

+(instancetype)threeTypeOrderTableViewCellHeaderAuthor{
    
    ThreeTypeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeTypeOrderTableViewCell" owner:self options:nil][2];
    
    return cell;
    
}


+(instancetype)threeTypeOrderTableViewCellHeader{
    
    ThreeTypeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeTypeOrderTableViewCell" owner:self options:nil][3];
    
    return cell;
    
}


+(instancetype)threeTypeOrderTableViewCellTitle{
    
    ThreeTypeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeTypeOrderTableViewCell" owner:self options:nil][4];
    
    return cell;
    
}

+(instancetype)threeTypeOrderTableViewCellFooter{
    
    ThreeTypeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeTypeOrderTableViewCell" owner:self options:nil][1];
    
    return cell;
    
}

+(instancetype)threeTypeOrderTableViewCellFooterT{
    
    ThreeTypeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeTypeOrderTableViewCell" owner:self options:nil][5];
    
    return cell;
    
}

+(instancetype)threeTypeOrderTableViewCellFooterPay{
    
    ThreeTypeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ThreeTypeOrderTableViewCell" owner:self options:nil][6];
    
    return cell;
    
}

/**
 1.订制订单- 待接单
 */
- (void)setCusWaitOrder:(ThreeOrder *)cusWaitOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusWaitOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",cusWaitOrder.use_time];
    _shopLan.text = cusWaitOrder.content;
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",cusWaitOrder.price];
    _stateLab.text = @"待接单";
    _stateLab.textColor = MainColor;
    
    _restTime.hidden = YES;
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;
}

/**
 2.订制订单- 已接单
 */
- (void)setCusTakeOrder:(ThreeOrder *)cusTakeOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusTakeOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",cusTakeOrder.use_time];
    _shopLan.text = cusTakeOrder.content;
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",cusTakeOrder.price];
    _stateLab.text = @"已接单";
    _stateLab.textColor = MainColor;
    
    [_rightBtn setTitle:@" 去选择 " forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
    
    _leftBtn.hidden = YES;
    _gradeLab.hidden = YES;
    _orgPrice.hidden = YES;
    _restTime.hidden = YES;
}

/**
 3.订制订单- 已支付
 */
-(void)setCusPayOrder:(ThreeOrder *)cusPayOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusPayOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",cusPayOrder.use_time];
    _shopLan.text = cusPayOrder.content;
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",cusPayOrder.price];
    _stateLab.text = @"已支付";
    _stateLab.textColor = MainColor;
    
    if (cusPayOrder.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",cusPayOrder.grade_name];
    }
    
    [_rightBtn setTitle:@"  使用  " forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
    
    _leftBtn.hidden = YES;
    _restTime.hidden = YES;
    _orgPrice.hidden = YES;
    
}

/**
 4.订制订单- 待评价
 */
- (void)setCusCommentOrder:(ThreeOrder *)cusCommentOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusCommentOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"使用时间：%@",cusCommentOrder.use_time];
    _shopLan.text = cusCommentOrder.content;
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",cusCommentOrder.price];
    _stateLab.text = @"待评价";
    _stateLab.textColor = FontColor;
    
    if (cusCommentOrder.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",cusCommentOrder.grade_name];
    }
    
    [_leftBtn setTitle:@"再来一单" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _leftBtn.layer.borderColor = FontColor.CGColor;
    _leftBtn.layer.borderWidth = 1;
    
    [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = MainColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden= YES;
    _orgPrice.hidden = YES;
    _restTime.hidden = YES;
}

/**
 5.订制订单- 退款中
 */
- (void)setCusMoneyDuringOrder:(ThreeOrder *)cusMoneyDuringOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusMoneyDuringOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",cusMoneyDuringOrder.use_time];
    _shopLan.text = cusMoneyDuringOrder.content;
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",cusMoneyDuringOrder.price];
    _stateLab.text = @"退款中";
    _stateLab.textColor = LightFontColor;
    if (cusMoneyDuringOrder.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",cusMoneyDuringOrder.grade_name];
    }
    
    [_rightBtn setTitle:@"退款进度" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _restTime.hidden = YES;
}

/**
 6.订制订单- 已退款
 */
- (void)setCusMoneyPayBackOrder:(ThreeOrder *)cusMoneyPayBackOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusMoneyPayBackOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",cusMoneyPayBackOrder.use_time];
    _shopLan.text = cusMoneyPayBackOrder.content;
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",cusMoneyPayBackOrder.price];
    _stateLab.text = @"已退款";
    _stateLab.textColor = LightFontColor;
    
    if (cusMoneyPayBackOrder.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",cusMoneyPayBackOrder.grade_name];
    }
    
    
    
    [_rightBtn setTitle:@"退款进度" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _rightBtn.hidden = YES;
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _restTime.hidden = YES;
}


/**
 7.订制订单- 完成
 */
- (void)setCusFinishOrder:(ThreeOrder *)cusFinishOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusFinishOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",cusFinishOrder.use_time];
    _shopLan.text = cusFinishOrder.content;
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",cusFinishOrder.price];
    _stateLab.text = @"已完成";
    _stateLab.textColor = LightFontColor;
    
    if (cusFinishOrder.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",cusFinishOrder.grade_name];
    }
    
    
    [_rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _restTime.hidden = YES;
}

- (void)setCusRefuseOrder:(ThreeOrder *)cusRefuseOrder{
    
    [_iconBtn setImage:[UIImage imageNamed:@"定单"] forState:UIControlStateNormal];
    _titleLab.text = cusRefuseOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",cusRefuseOrder.use_time];
    _shopLan.text = cusRefuseOrder.content;
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",cusRefuseOrder.price];
    _stateLab.text = @"退款驳回";
    _stateLab.textColor = LightFontColor;
    
    if (cusRefuseOrder.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",cusRefuseOrder.grade_name];
    }
    
    
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _restTime.hidden = YES;
    
}

/**
 1.活动订单- 待支付
 */
- (void)setActivityWaitPayOrder:(ThreeOrder *)activityWaitPayOrder{
    
    if (activityWaitPayOrder.author_uuid.length) {
        
        _shopLan.text = [NSString stringWithFormat:@"匠人：%@",activityWaitPayOrder.content];
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:activityWaitPayOrder.image] forState:UIControlStateNormal];
        
    }else{
        
        _shopLan.text = @"匠人：未指定";
        [_iconBtn setImage:[UIImage imageNamed:@"1元"] forState:UIControlStateNormal];
        
    }
    
    
    _titleLab.text = activityWaitPayOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",activityWaitPayOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",activityWaitPayOrder.price];
    
    _stateLab.text = @"待付款";
    
    if ([activityWaitPayOrder.status integerValue] == 5) {
        _stateLab.text = @"退款中";
    }
    
    if ([activityWaitPayOrder.status  integerValue] == 6) {
        _stateLab.text = @"退款完成";
    }
    
    _stateLab.textColor = MainColor;
    
//    if ([activityWaitPayOrder.type integerValue] == 3) {
//
//        [self setConfigWithSecond: [activityWaitPayOrder.residue_time integerValue]];
//
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
//        //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
//        //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//
//    }else{
        _restTime.hidden = YES;
//    }
    
    
    

    [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
    
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;

}

/**
 2.活动订单- 待使用
 */
- (void)setActivityUseOrder:(ThreeOrder *)activityUseOrder{
    
  
    if (activityUseOrder.author_uuid.length) {
        
       
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:activityUseOrder.image] forState:UIControlStateNormal];
        
    }else{
        
        [_iconBtn setImage:[UIImage imageNamed:@"1元"] forState:UIControlStateNormal];
        
    }
    
    if (activityUseOrder.content.length) {
        _shopLan.text = [NSString stringWithFormat:@"匠人：%@",activityUseOrder.content];
    }else{
        _shopLan.hidden = YES;
    }
    
    _titleLab.text = activityUseOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",activityUseOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",activityUseOrder.price];
    _stateLab.text = @"待使用";
    _stateLab.textColor = MainColor;
    
    
    [_rightBtn setTitle:@"使用" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
    
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;
    _restTime.hidden = YES;
}

/**
 3.活动订单- 待评价
 */

- (void)setActivityCommentOrder:(ThreeOrder *)activityCommentOrder{
    
    if (activityCommentOrder.author_uuid.length) {
        
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:activityCommentOrder.image] forState:UIControlStateNormal];
        
    }else{
        
        [_iconBtn setImage:[UIImage imageNamed:@"1元"] forState:UIControlStateNormal];
        
    }
    _shopLan.text = [NSString stringWithFormat:@"匠人：%@",activityCommentOrder.content];
    _titleLab.text = activityCommentOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",activityCommentOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",activityCommentOrder.price];
    _stateLab.text = @"待评价";
    _stateLab.textColor = FontColor;
    
    
    
    [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = MainColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;
    _restTime.hidden = YES;
}


/**
 4.活动订单- 退款中
 */

-(void)setActivityMoneyDuringOrder:(ThreeOrder *)activityMoneyDuringOrder{
    
    if (activityMoneyDuringOrder.author_uuid.length) {
        
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:activityMoneyDuringOrder.image] forState:UIControlStateNormal];
        
    }else{
        
        [_iconBtn setImage:[UIImage imageNamed:@"1元"] forState:UIControlStateNormal];
        
    }
    _shopLan.text = [NSString stringWithFormat:@"匠人：%@",activityMoneyDuringOrder.content];
    _titleLab.text = activityMoneyDuringOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",activityMoneyDuringOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",activityMoneyDuringOrder.price];
    _stateLab.text = @"退款中";
    _stateLab.textColor = LightFontColor;
    
    
    
    [_rightBtn setTitle:@"退款进度" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;
    _restTime.hidden = YES;
}

/**
 5.活动订单- 已退款
 */
- (void)setActivityMoneyPayBackOrder:(ThreeOrder *)activityMoneyPayBackOrder{
    
    if (activityMoneyPayBackOrder.author_uuid.length) {
        
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:activityMoneyPayBackOrder.image] forState:UIControlStateNormal];
        
    }else{
        
        [_iconBtn setImage:[UIImage imageNamed:@"1元"] forState:UIControlStateNormal];
        
    }
    _shopLan.text = [NSString stringWithFormat:@"匠人：%@",activityMoneyPayBackOrder.content];
    _titleLab.text = activityMoneyPayBackOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",activityMoneyPayBackOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",activityMoneyPayBackOrder.price];
    _stateLab.text = @"已退款";
    _stateLab.textColor = FontColor;
    
    
    
    [_rightBtn setTitle:@"退款进度" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;
    _restTime.hidden = YES;
}

/**
 6.活动订单- 已完成
 */
-(void)setActivityFinishOrder:(ThreeOrder *)activityFinishOrder{
    
    if (activityFinishOrder.author_uuid.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:activityFinishOrder.image] forState:UIControlStateNormal];
        
    }else{
        
        [_iconBtn setImage:[UIImage imageNamed:@"1元"] forState:UIControlStateNormal];
        
    }
    _shopLan.text = [NSString stringWithFormat:@"匠人：%@",activityFinishOrder.content];
    _titleLab.text = activityFinishOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",activityFinishOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",activityFinishOrder.price];
    _stateLab.text = @"已完成";
    _stateLab.textColor = FontColor;
    
    
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;
    _restTime.hidden = YES;
    
}

/**
 1.拼团订单- 待支付
 */

- (void)setGroupWaitPayOrder:(ThreeOrder *)groupWaitPayOrder{
    
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupWaitPayOrder.image] forState:UIControlStateNormal];
    
    if (groupWaitPayOrder.pic.length) {
        
         [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupWaitPayOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupWaitPayOrder.content];
    
    _titleLab.text = groupWaitPayOrder.title;
    
    if ([groupWaitPayOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupWaitPayOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupWaitPayOrder.use_time];
    }
    
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",groupWaitPayOrder.price];
    
    if ([groupWaitPayOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupWaitPayOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    
    
     [self setConfigWithSecond: [groupWaitPayOrder.residue_time integerValue]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
   
    _stateLab.text = @"待付款";
    _stateLab.textColor = MainColor;
    
    
    [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
    
    _leftBtn.hidden = YES;
    
    _gradeLab.hidden = YES;
    
}

/**
 2.拼团订单- 未成团
 */
- (void)setGroupPeopleOrder:(ThreeOrder *)groupPeopleOrder{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupPeopleOrder.image] forState:UIControlStateNormal];
    
    if (groupPeopleOrder.pic.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupPeopleOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupPeopleOrder.content];
    
    _titleLab.text = groupPeopleOrder.title;
    
    if ([groupPeopleOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupPeopleOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupPeopleOrder.use_time];
    }
    
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",groupPeopleOrder.price];
    
//    直接购买
    if ([groupPeopleOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupPeopleOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    [self setConfigWithSecond: [groupPeopleOrder.residue_time integerValue]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    
    _stateLab.text = [NSString stringWithFormat:@"还差%@人成团",groupPeopleOrder.num];
    _stateLab.textColor = FontColor;
    
    
    [_rightBtn setTitle:@"邀请好友拼团" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = OrderColor;
    
    self.rightBtn.frame = CGRectMake(kWidth-Space-100, 75, 100, 30);
   
    _leftBtn.hidden = YES;
    
    _gradeLab.hidden = YES;
    
}

/**
 3.拼团订单- 待评价
 */
- (void)setGroupCommentOrder:(ThreeOrder *)groupCommentOrder{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupCommentOrder.image] forState:UIControlStateNormal];
    
    if (groupCommentOrder.pic.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupCommentOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupCommentOrder.content];
    
    _titleLab.text = groupCommentOrder.title;
    
    if ([groupCommentOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupCommentOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupCommentOrder.use_time];
    }
    
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",groupCommentOrder.price];
    
    if ([groupCommentOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupCommentOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    [self setConfigWithSecond: [groupCommentOrder.residue_time integerValue]];
    
    
    _stateLab.text = @"待评价";
    _stateLab.textColor = FontColor;
    
    
    [_leftBtn setTitle:@"再来一单" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _leftBtn.layer.borderColor = FontColor.CGColor;
    _leftBtn.layer.borderWidth = 1;
    
    [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = MainColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _restTime.hidden = YES;
    _leftBtn.hidden = YES;
    _gradeLab.hidden = YES;
    
}

/**
 4.拼团订单- 退款中
 */
- (void)setGroupMoneyDuringOrder:(ThreeOrder *)groupMoneyDuringOrder{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupMoneyDuringOrder.image] forState:UIControlStateNormal];
    
    if (groupMoneyDuringOrder.pic.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupMoneyDuringOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupMoneyDuringOrder.content];
    
    _titleLab.text = groupMoneyDuringOrder.title;
    
    if ([groupMoneyDuringOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupMoneyDuringOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupMoneyDuringOrder.use_time];
    }
    
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",groupMoneyDuringOrder.price];
    
    if ([groupMoneyDuringOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupMoneyDuringOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    _stateLab.text = @"退款中";
    _stateLab.textColor = LightFontColor;
    
    [_rightBtn setTitle:@"退款进度" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden = YES;
    _restTime.hidden = YES;
    _gradeLab.hidden = YES;
    
}

/**
 5.拼团订单- 已退款
 */

- (void)setGroupMoneyPayBackOrder:(ThreeOrder *)groupMoneyPayBackOrder{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupMoneyPayBackOrder.image] forState:UIControlStateNormal];
    
    if (groupMoneyPayBackOrder.pic.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupMoneyPayBackOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupMoneyPayBackOrder.content];
    
    _titleLab.text = groupMoneyPayBackOrder.title;
    
    if ([groupMoneyPayBackOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupMoneyPayBackOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupMoneyPayBackOrder.use_time];
    }
    
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",groupMoneyPayBackOrder.price];
    
    if ([groupMoneyPayBackOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupMoneyPayBackOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    
    _stateLab.text = @"已退款";
    _stateLab.textColor = FontColor;
    
    [_rightBtn setTitle:@"退款进度" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden = YES;
    _restTime.hidden = YES;
    _gradeLab.hidden = YES;
    
}

/**
 6.拼团订单- 完成
 */
- (void)setGroupFinishOrder:(ThreeOrder *)groupFinishOrder{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupFinishOrder.image] forState:UIControlStateNormal];
    
    if (groupFinishOrder.pic.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupFinishOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupFinishOrder.content];
    
    _titleLab.text = groupFinishOrder.title;
    
    if ([groupFinishOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupFinishOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupFinishOrder.use_time];
    }
    
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",groupFinishOrder.price];
    
    if ([groupFinishOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupFinishOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    _stateLab.text = @"已完成";
    _stateLab.textColor = FontColor;
    
    [_rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:FontColor forState:UIControlStateNormal];
    _rightBtn.layer.borderColor = FontColor.CGColor;
    _rightBtn.layer.borderWidth = 1;
    
    _leftBtn.hidden = YES;
    _restTime.hidden = YES;
    _gradeLab.hidden = YES;
    
}

- (void)setGroupUseOrder:(ThreeOrder *)groupUseOrder{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupUseOrder.image] forState:UIControlStateNormal];
    
    if (groupUseOrder.pic.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupUseOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupUseOrder.content];
    
    _titleLab.text = groupUseOrder.title;
    
    if ([groupUseOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupUseOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupUseOrder.use_time];
    }
    
    
    
    _disPrice.text = [NSString stringWithFormat:@"价格：¥%@",groupUseOrder.price];
    
    if ([groupUseOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupUseOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    
    _stateLab.text = @"待使用";
    _stateLab.textColor = MainColor;
    
    
    [_rightBtn setTitle:@"使用" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
    
    _leftBtn.hidden = YES;
    _restTime.hidden = YES;
    _gradeLab.hidden = YES;
    
}

- (void)setGroupFailOrder:(ThreeOrder *)groupFailOrder{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupFailOrder.image] forState:UIControlStateNormal];
    
    if (groupFailOrder.pic.length) {
        
        [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupFailOrder.pic] forState:UIControlStateNormal];
    }
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",groupFailOrder.content];
    
    _titleLab.text = groupFailOrder.title;
    
    if ([groupFailOrder.is_pay integerValue] == 1 ) {
        _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",groupFailOrder.use_time];
    }else{
        _timeLab.text = [NSString stringWithFormat:@"开团时间：%@",groupFailOrder.use_time];
    }
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",groupFailOrder.price];
    
    if ([groupFailOrder.is_pay integerValue] == 1) {
        
        _orgPrice.hidden = YES;
        
    }else{
        
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",groupFailOrder.org_price] attributes:attribtDic];
        // 赋值
        _orgPrice.attributedText = attribtStr;
        
    }
    
    if ([groupFailOrder.is_pay integerValue] == 1) {
        _stateLab.text = @"已过期";
        _rightBtn.hidden = YES;
    }else{
        _stateLab.text = @"未拼成";
        [_rightBtn setTitle:@"重新拼团" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.backgroundColor = MainColor;
    }
    
    _stateLab.textColor = FontColor;
    
    
   
    
    _leftBtn.hidden = YES;
    _restTime.hidden = YES;
    _gradeLab.hidden = YES;
    
}

-(void)setRealWaitPayOrder:(ThreeOrder *)realWaitPayOrder{
    
    _realWaitPayOrder = realWaitPayOrder;
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",realWaitPayOrder.shop_name];
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:realWaitPayOrder.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test"]];
    
    _titleLab.text = realWaitPayOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",realWaitPayOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",realWaitPayOrder.price];
    
    _stateLab.text = @"待付款";
    
   
    _stateLab.textColor = MainColor;
    _restTime.hidden = YES;
   
    [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
    
    _leftBtn.hidden = YES;
    _orgPrice.hidden = YES;
    _gradeLab.hidden = YES;
    
}

- (void)setRealUseOrder:(ThreeOrder *)realUseOrder{
    
    _realUseOrder = realUseOrder;
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",realUseOrder.shop_name];
    
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:realUseOrder.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test"]];
    
    _titleLab.text = realUseOrder.title;
    _timeLab.text = [NSString stringWithFormat:@"下单时间：%@",realUseOrder.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",realUseOrder.price];
    _stateLab.text = @"待使用";
    _stateLab.textColor = MainColor;
    _restTime.hidden = YES;
    
    [_rightBtn setTitle:@"去使用" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.backgroundColor = MainColor;
}

- (void)setRealAlreadyUse:(ThreeOrder *)realAlreadyUse{
    
    _shopLan.text = [NSString stringWithFormat:@"所属门店：%@",realAlreadyUse.shop_name];
    
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:realAlreadyUse.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test"]];
    
    _titleLab.text = realAlreadyUse.title;
    _timeLab.text = [NSString stringWithFormat:@"使用时间：%@",realAlreadyUse.use_time];
    
    _disPrice.text = [NSString stringWithFormat:@"价格：%@",realAlreadyUse.price];
    _stateLab.text = @"已使用";
    _stateLab.textColor = MainColor;
    _restTime.hidden = YES;
}




- (void)setConfigWithSecond:(NSInteger)second {
    _second = second;
    if (_second > 0) {
        self.restTime.text = [self ll_timeWithSecond:_second];
    }
    else {
        self.restTime.text = @"剩余 00:00";
    }
}


- (void)timerRun:(NSTimer *)timer {
    
    if (_second > 0) {
        self.restTime.text = [self ll_timeWithSecond:_second];
        _second -= 1;
    }
    else {
        self.restTime.text = @"剩余 00:00";
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
        time = [NSString stringWithFormat:@"剩余 00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"剩余 %02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"剩余 %02ld:%02ld:%02ld",second/3600,(second-second/3600*3600)/60,second%60];
        }
    }
    return time;
}


- (IBAction)moreAction:(UIButton *)sender {
    [self.delegate selectMoreAction];
}

- (IBAction)checkAllOrder:(UIButton *)sender {
    [self.delegate checkAllAction];
}


- (IBAction)fourAction:(UIButton *)sender {
    [self.delegate checkStates:sender.tag];
}


@end

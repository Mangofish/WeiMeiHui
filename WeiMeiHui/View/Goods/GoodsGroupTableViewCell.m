//
//  GoodsGroupTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GoodsGroupTableViewCell.h"
#import <JhtMarquee/JhtVerticalMarquee.h>

@interface GoodsGroupTableViewCell (){
    
    NSInteger _second;
    // 上下滚动的跑马灯
    JhtVerticalMarquee *_verticalMarquee;
    
}

@property (weak, nonatomic) IBOutlet UILabel *groupNum;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *alredyNum;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic)  NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *pinkBg;
@end

@implementation GoodsGroupTableViewCell

+ (instancetype)goodsGroupTableViewCellYellow{
    
    GoodsGroupTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsGroupTableViewCell" owner:nil options:nil][0];
    cell.joinBtn.layer.cornerRadius = 5;
    cell.joinBtn.layer.masksToBounds = YES;
    
    return cell;
}

+ (instancetype)goodsGroupTableViewCellPink{
    
    GoodsGroupTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsGroupTableViewCell" owner:nil options:nil][3];
    
    return cell;
}

+ (instancetype)goodsGroupTableViewCellTwo{
    
    GoodsGroupTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsGroupTableViewCell" owner:nil options:nil][1];
    
    return cell;
}

+ (instancetype)goodsGroupTableViewCellThree{
    
    GoodsGroupTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsGroupTableViewCell" owner:nil options:nil][2];
    
    
    return cell;
}

-(void)setGoodsDetail:(GoodsDetail *)goodsDetail{
    
    _goodsDetail = goodsDetail;
    _groupNum.text = [NSString stringWithFormat:@"已有%@人参与拼团",goodsDetail.in_group];
//    滚动
    // 开启跑马灯
      _verticalMarquee = [[JhtVerticalMarquee alloc]  initWithFrame:CGRectMake(kWidth/2-20, 0, kWidth/2 , 44)];
    _verticalMarquee.verticalTextFont = [UIFont systemFontOfSize:12];
    _verticalMarquee.verticalTextColor = FontColor;
    [self.pinkBg addSubview:_verticalMarquee];
    [_verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
    _verticalMarquee.sourceArray = goodsDetail.recent_in;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)setOrder:(RecentOrder *)order{
    
    [_icon sd_setImageWithURL:[NSURL urlWithNoBlankDataString:order.image] placeholderImage:[UIImage imageNamed:@"test2"]];
    _name.text = [NSString stringWithFormat:@"%@的团",order.nickname];
    
    _alredyNum.text = [NSString stringWithFormat:@"还差%@人成团",order.residue];;
    _groupNum.text = [NSString stringWithFormat:@"已有%@人参与拼团",_goodsDetail.in_group];
    
    
}



- (void)setConfigWithSecond:(NSInteger)second {
    _second = second;
    if (_second > 0) {
        self.time.text = [self ll_timeWithSecond:_second];
    }
    else {
        self.time.text = @"剩余 00:00";
    }
}


- (void)timerRun:(NSTimer *)timer {
    
    if (_second > 0) {
        self.time.text = [self ll_timeWithSecond:_second];
        _second -= 1;
    }
    else {
        self.time.text = @"剩余 00:00";
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


- (IBAction)ruleAction:(UIButton *)sender {
    
}

- (IBAction)inAction:(UIButton *)sender {
    [self.delegate didClickJoin];
}

@end

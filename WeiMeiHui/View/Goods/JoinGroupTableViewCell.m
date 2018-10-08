//
//  JoinGroupTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "JoinGroupTableViewCell.h"
#import "JoinUserIconCollectionViewCell.h"

@interface JoinGroupTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>



@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *pointOne;
@property (weak, nonatomic) IBOutlet UILabel *minuteLab;
@property (weak, nonatomic) IBOutlet UILabel *pointTwo;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (strong, nonatomic) UIView *iconBgView;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *failLab;





@property (strong, nonatomic) dispatch_source_t timer;

@end
@implementation JoinGroupTableViewCell

+ (instancetype)joinGroupTableViewCell{
    
    JoinGroupTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"JoinGroupTableViewCell" owner:nil options:nil][0];
    cell.joinBtn.layer.cornerRadius = 5;
    cell.joinBtn.layer.masksToBounds = YES;
    
    cell.secondLab.layer.cornerRadius = 5;
    cell.secondLab.layer.masksToBounds = YES;
    
    cell.minuteLab.layer.cornerRadius = 5;
    cell.minuteLab.layer.masksToBounds = YES;
    
    cell.hourLab.layer.cornerRadius = 5;
    cell.hourLab.layer.masksToBounds = YES;
    
    return cell;
}

-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}

- (void)setGoodsDetail:(GoodsDetail *)goodsDetail{
    
    _goodsDetail = goodsDetail;
    _titleLab.text = [NSString stringWithFormat:@"还差%@人拼团成功，剩余时间",goodsDetail.overplus];
    
    NSTimeInterval timeInterval = 0;
    
    if (goodsDetail.end_time) {
         timeInterval = [goodsDetail.end_time integerValue];
    }else{
        timeInterval = [goodsDetail.endtime integerValue];
    }
    
    
    
    
    if (self.timer == nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(self.timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(self.timer);
                    self.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.hourLab.text = @"00";
                        self.minuteLab.text = @"00";
                        self.secondLab.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (hours < 10) {
                            self.hourLab.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLab.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLab.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLab.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondLab.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLab.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout --;
                }
            });
            dispatch_resume(self.timer);
        }
    }
    
    NSUInteger count = [goodsDetail.group_num integerValue];
    
    CGFloat itemW = 40;
    CGFloat space = 20;
    CGFloat width = itemW*count +space *(count-1);
    CGFloat x = (kWidth-width)/2;
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(x, 64, width, itemW) collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[JoinUserIconCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    JoinUserIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.iconImg.layer.cornerRadius = 20;
    cell.titleLab.layer.cornerRadius = 7;
    cell.titleLab.layer.masksToBounds= YES;
    cell.iconImg.layer.masksToBounds= YES;
    
    
//   标签
    if (indexPath.item == 0) {
        
        cell.titleLab.hidden = NO;
//        cell.iconImg.image = [UIImage imageNamed:@"边框"];
        
    }else{
        
        cell.titleLab.hidden = YES;
        
    }
    
//    头像
//    NSUInteger count = [self.goodsDetail.group_num integerValue];
    NSUInteger inUser = self.goodsDetail.in_user.count;
    
    if (indexPath.item > inUser-1) {
        
        cell.iconImg.image = [UIImage imageNamed:@"边框"];
    
    }else{
        
        NSString *str =[_goodsDetail.in_user[indexPath.item] objectForKey:@"image"];
        cell.iconImg.layer.borderColor = MainColor.CGColor;
        cell.iconImg.layer.borderWidth = 1;
        [cell.iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:str]];
        
    }
    
    
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUInteger count = [self.goodsDetail.group_num integerValue];
    return count;
    
}

- (IBAction)joinAction:(UIButton *)sender {
    [self.delegate didSelectJoinGroup];
}


- (void)setGoodsWaitDetail:(GoodsDetail *)goodsWaitDetail{
    
    _goodsWaitDetail = goodsWaitDetail;
    _goodsDetail = goodsWaitDetail;
    _titleLab.text = [NSString stringWithFormat:@"支付剩余时间："];
    
    NSTimeInterval timeInterval = 0;
    
    if (goodsWaitDetail.end_time) {
        timeInterval = [goodsWaitDetail.end_time integerValue];
    }else{
        timeInterval = [goodsWaitDetail.endtime integerValue];
    }
    
    
    
    
    if (self.timer == nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(self.timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(self.timer);
                    self.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.hourLab.text = @"00";
                        self.minuteLab.text = @"00";
                        self.secondLab.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (hours < 10) {
                            self.hourLab.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            self.hourLab.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            self.minuteLab.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLab.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            self.secondLab.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            self.secondLab.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout --;
                }
            });
            dispatch_resume(self.timer);
        }
    }
    
    NSUInteger count = [goodsWaitDetail.group_num integerValue];
    
    CGFloat itemW = 40;
    CGFloat space = 20;
    CGFloat width = itemW*count +space *(count-1);
    CGFloat x = (kWidth-width)/2;
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(x, 64, width, itemW) collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[JoinUserIconCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}


-(void)setGoodFailDetail:(GoodsDetail *)goodFailDetail{
    
    _goodsDetail = goodFailDetail;
    _titleLab.text = [NSString stringWithFormat:@"还差%@人拼团成功，剩余时间",goodFailDetail.overplus];
    if (!goodFailDetail.group_num) {
        
        return;
    }
    NSUInteger count = [goodFailDetail.group_num integerValue];
    
    CGFloat itemW = 40;
    CGFloat space = 20;
    CGFloat width = itemW*count +space *(count-1);
    CGFloat x = (kWidth-width)/2;
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(x, 64, width, itemW) collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[JoinUserIconCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
   
    _failLab.text  = @"拼团失败";
    _failLab.frame = CGRectMake(22, CGRectGetMaxY(_collectionView.frame)+15, kWidth-44, 25);
    _failLab.hidden = NO;
    
    [_joinBtn setTitle:@"重新拼团" forState:UIControlStateNormal];
}
@end

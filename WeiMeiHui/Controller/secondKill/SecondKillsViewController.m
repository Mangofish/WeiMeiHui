//
//  SecondKillsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SecondKillsViewController.h"
#import "TimeStatusView.h"
#import "SeKillsCollectionViewCell.h"
#import <EventKit/EventKit.h>
#import "SecondKillsOrderViewController.h"
#import "GoodsDetailViewController.h"
#import "LWShareService.h"
#import "ShareService.h"


@interface SecondKillsViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SeKillsCollectionViewCellDelegate>

{
    NSString *phone;
    NSString *startTime;
    NSString *sessionID;
    NSString *itemID;
    NSUInteger reloadIndexs;
}

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic, strong)NSMutableArray *dataCollectionArray;
@property (nonatomic, copy)NSArray *dataArray;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *viewArray;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy)NSDictionary *dataDic;
@end

@implementation SecondKillsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.dataCollectionArray = [NSMutableArray array];
    self.viewArray = [NSMutableArray array];
    [self customUI];
    [self getData];
    
}

- (void)customUI{
    
    _img.frame = CGRectMake(0, 0, kWidth, kWidth*120/375);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
    //滚动时间ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kWidth*120/375, kWidth, 44)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 43, kWidth / 4, 2)];
    [self.scrollView addSubview:_lineView];
    _lineView.backgroundColor = MainColor;
}

- (void)configTimeView{
    
//    时间滚动View
    for (int i = 0; i < self.dataCollectionArray.count; i++) {
        
        TimeStatusView *timeView = [[TimeStatusView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * i, 0, SCREEN_WIDTH / 4, self.scrollView.frame.size.height)];
        timeView.timeLabel.text = [[self.dataCollectionArray objectAtIndex:i] objectForKey:@"session_time"];
        timeView.statusLabel.text = [[self.dataCollectionArray objectAtIndex:i] objectForKey:@"status_name"];
        timeView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected:)];
        [timeView addGestureRecognizer:tap];
        //有一个View 就添加到viewArray数组中
        [self.viewArray addObject:timeView];
        [self.scrollView addSubview:timeView];
        
        if (i == 0) {
            timeView.timeLabel.textColor = MainColor;
            timeView.statusLabel.textColor =  MainColor;
        }
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.dataCollectionArray.count*kWidth/4, 0);
    
//    下方显示
    //collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kWidth*120/375 - 44);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 左右
    flowLayout.minimumInteritemSpacing = 0;
    // 上下
    flowLayout.minimumLineSpacing = 0;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44+kWidth*120/375, SCREEN_WIDTH, SCREEN_HEIGHT -44-kWidth*120/375 ) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    
    self.collectionView.pagingEnabled = YES;
    
    //分别注册 多个不同重用标示的Cell
    for (NSInteger i = 0; i < 4 ; i++) {
        
        NSString * stringID = [NSString stringWithFormat:@"SeKillsCollectionViewCell%ld",i];
        [self.collectionView registerClass:[SeKillsCollectionViewCell class] forCellWithReuseIdentifier:stringID];
        
    }
    
    
//    [self.collectionView registerClass:[SeKillsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    // collectionView偏移量（没有空字符串了，所以 j 是几就 SCREEN_WIDTH * j）
//    self.collectionView.contentOffset = CGPointMake(kWidth * self.dataCollectionArray.count, 0);
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self getData];
//    }];
}

//滚动时间表点击事件
- (void)selected:(UITapGestureRecognizer *)action{
    
        //self.scrollView.contentOffset 因为前两个空字符串 所以点击手势触发tag值 多两个， 要减掉SCREEN_WIDTH / 5 * 2
//        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH / 5 * action.view.tag, 0);
        self.collectionView.contentOffset = CGPointMake(SCREEN_WIDTH * action.view.tag, 0);
    
        //字体变黑
        TimeStatusView *timeView = [self.viewArray objectAtIndex:action.view.tag];
        timeView.timeLabel.textColor = MainColor;
        timeView.statusLabel.textColor =  MainColor;
        
        
        //点击的TimeStatusView存放起来
        UIView *view2 = [self.viewArray objectAtIndex:action.view.tag];
        
        //从数组中删除 点击的TimeStatusView
        [self.viewArray removeObjectAtIndex:action.view.tag];
        
        //数组中剩下的TimeStatusView For循环 全部变白
        for (TimeStatusView *timeView in self.viewArray) {
            timeView.backgroundColor = [UIColor whiteColor];
            timeView.timeLabel.textColor = FontColor;
            timeView.statusLabel.textColor = FontColor;
        }
        
        //最后把删除的TimeStatusView插入回来，放在之前的位置
        [self.viewArray insertObject:view2 atIndex:action.view.tag];
    
    
}

#pragma mark -- collectionView  的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataCollectionArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * stringID = [NSString stringWithFormat:@"SeKillsCollectionViewCell%ld",indexPath.row];
    
    SeKillsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringID forIndexPath:indexPath];
    
//    SeKillsCollectionViewCell *cell = [SeKillsCollectionViewCell alloc]in;
    
    cell.status = [[self.dataCollectionArray objectAtIndex:indexPath.row] objectForKey:@"status"];
    cell.dataTableArray = [[self.dataCollectionArray objectAtIndex:indexPath.row] objectForKey:@"goods_lists"];
    cell.delegate = self;
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
    
}

- (void)getData{
    
    //网络请求
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"city_id":city_id,@"uuid":uuid}];
    
    [YYNet POST:SecondKillList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        self.dataDic = dic;
        self->phone = dic[@"phone"];
        
        [self.img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
        
        if ([dic[@"lists"] isKindOfClass:[NSArray class]]) {
            [self.dataCollectionArray setArray: dic[@"lists"]];
        }
        
        
        [self configTimeView];
        
    } faild:^(id responseObject) {
        
//        MJWeakSelf
//        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
//            [weakSelf getData];
//        }];
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.collectionView) {
        
//            self.scrollView.contentOffset = CGPointMake(self.collectionView.contentOffset.x / 5, 0);
       
            //字体变黑
            float num = self.collectionView.contentOffset.x / SCREEN_WIDTH;
            int a;//四舍五入取整
            a = (int)(num + 0.5);
            TimeStatusView *timeView = [self.viewArray objectAtIndex:a];
            timeView.timeLabel.textColor = MainColor;
            timeView.statusLabel.textColor =  MainColor;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.lineView.frame = CGRectMake(timeView.frame.origin.x, 43, kWidth/4, 2);
        }];
        
        
            //点击的TimeStatusView存放起来
            UIView *view2 = [self.viewArray objectAtIndex:num];
            
            //从数组中删除 点击的TimeStatusView
            [self.viewArray removeObjectAtIndex:num];
            
            //数组中剩下的TimeStatusView For循环 全部变白
            for (TimeStatusView *timeView in self.viewArray) {
                timeView.backgroundColor = [UIColor whiteColor];
                timeView.timeLabel.textColor = FontColor;
                timeView.statusLabel.textColor = FontColor;
            }
            //最后把删除的TimeStatusView插入回来，放在之前的位置
            [self.viewArray insertObject:view2 atIndex:num];
        
        }
    
}

#pragma mark -代理方法

- (void)didClickMenuIndex:(NSInteger)index andData:(NSArray *)data
{
    
    if (![PublicMethods isLogIn]) {
        
        LoginViewController *logVC= [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        return;
    }
    
    SecondKillsOrderViewController *killVC= [[SecondKillsOrderViewController alloc]init];
    
    killVC.name = [data[index] objectForKey:@"goods_name"];
    killVC.sec_price = [data[index] objectForKey:@"sec_price"];
    killVC.ID = [data[index] objectForKey:@"id"];
    killVC.activity_id = [data[index] objectForKey:@"activity_id"];
    killVC.session_id = [data[index] objectForKey:@"session_id"];
    killVC.org_price = [data[index] objectForKey:@"org_price"];
    
    killVC.phone = phone;
    [self.navigationController pushViewController:killVC animated:YES];
}


- (void)didClickMenuIndex:(NSInteger)index andData:(NSArray *)data status:(NSString *)status{
    
    NSString *temp = [data[index] objectForKey:@"id"];
    
    GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
    detailVc.ID = temp;
    detailVc.isGroup = 2;
    detailVc.isSecKill = [status integerValue];
    detailVc.isSoldKill = [[data[index] objectForKey:@"inventory"] integerValue];
    detailVc.sessionID = [data[index] objectForKey:@"session_id"];
    [self.navigationController pushViewController:detailVc animated:YES];
    
    
}

- (void)didClickAlarmMenuIndex:(NSInteger)index andData:(NSArray *)data{
    
    NSUInteger reIndex = self.collectionView.contentOffset.x/kWidth;
    reloadIndexs = index;
    
    startTime = [self.dataCollectionArray[reIndex] objectForKey:@"start_time"];
    
    sessionID = [data[index] objectForKey:@"session_id"];
    itemID = [data[index] objectForKey:@"id"];
    
    NSMutableArray *temp = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:self->sessionID]) {
        
        [temp addObjectsFromArray: [[NSUserDefaults standardUserDefaults] valueForKey:self->sessionID]];
    }
    
    if ([temp containsObject:itemID]) {
        
        [temp removeObject:itemID];
        [[NSUserDefaults standardUserDefaults] setValue:temp forKey:self->sessionID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self cancelRemindData];
//        [self.collectionView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRemind" object:self userInfo:nil];
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:@"" message:@"秒杀提醒已取消，您可能会抢不到哟~" iconImage:[UIImage imageNamed:@"提醒"]];
        toast.titleTextColor = [UIColor whiteColor];
        toast.messageTextColor = [UIColor whiteColor];
        toast.toastType = FFToastTypeSuccess;
        toast.toastBackgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
    }else{
        //    获取秒杀时间
        [self saveEvent:nil];
    }
  
}

#pragma mark - 添加事件到日历
- (void)saveEvent:(id)sender {
    
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    //6.0及以上通过下面方式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误细心
                    // display error message here
                    NSLog(@"提醒事件：%@",error);
                }
                else if (!granted)
                {
                    //被用户拒绝，不允许访问日历
                    // display access denied error message here
                    NSLog(@"提醒事件：被用户拒绝，不允许访问日历");
                    
                    CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"" message:@"提醒功能未开启，无法成功提醒到您，请开启~"];
                    
                    CKAlertAction *action = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                        
                    } ];
                    CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                        
                       
                    } ];
                    
                    [cV addAction:action];
                    [cV addAction:action2];
                    
                    [self presentViewController:cV animated:YES completion:nil];
                    
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    
                    //事件保存到日历
                    
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = @"秒杀提醒";
                    event.location = @"";
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970: [self->startTime doubleValue]];
                    
                    event.startDate = myDate;
                    event.endDate   = [myDate dateByAddingTimeInterval:20.f];
//                    event.allDay = YES;
                    
                    //添加提醒
//                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -3.0f]];
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    
                    FFToast *toast = [[FFToast alloc]initToastWithTitle:@"设置成功" message:@"将在每日秒杀开抢前3分钟提醒" iconImage:[UIImage imageNamed:@"设置成功"]];
                    toast.titleTextColor = [UIColor whiteColor];
                    toast.messageTextColor = [UIColor whiteColor];
                    toast.toastType = FFToastTypeSuccess;
                    toast.toastBackgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
                    toast.toastPosition = FFToastPositionCentreWithFillet;
                    [toast show];
                    NSLog(@"保存成功");
                    
//                    NSUInteger reIndex = self.collectionView.contentOffset.x/kWidth;
                    
//                    NSIndexPath *path = [NSIndexPath indexPathForItem:reIndex inSection:0];
//                    [self.collectionView reloadItemsAtIndexPaths:@[path]];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRemind" object:self userInfo:nil];
//                    存储提醒信息
                    NSMutableArray *temp = [NSMutableArray array];
                    if ([[NSUserDefaults standardUserDefaults] valueForKey:self->sessionID]) {
                       
                        [temp addObjectsFromArray: [[NSUserDefaults standardUserDefaults] valueForKey:self->sessionID]];
                    }
                    
                    [temp addObject:self->itemID];
                    [[NSUserDefaults standardUserDefaults] setValue:temp forKey:self->sessionID];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
//                    请求数据
                    [self remindData];
                    
                }
            });
        }];
    }
    
}

#pragma mark - 提醒网络请求
- (void)remindData{
    
    //网络请求
    //    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    //    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
//    NSString *uuid = @"";
//    if ([PublicMethods isLogIn]) {
//        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
//    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":itemID,@"session_id":sessionID}];
    
    [YYNet POST:killReminds paramters:@{@"json":url} success:^(id responseObject) {
        
//        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        
    } faild:^(id responseObject) {
        
       
        
    }];
    
}

- (void)cancelRemindData{
    
    //网络请求
    //    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    //    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    //    NSString *uuid = @"";
    //    if ([PublicMethods isLogIn]) {
    //        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    //    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":itemID,@"session_id":sessionID}];
    
    [YYNet POST:cancelKillReminds paramters:@{@"json":url} success:^(id responseObject) {
        
//        NSDictionary *dict = [solveJsonData changeType:responseObject];
//        [self.collectionView reloadData];
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)shareAction:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"share_url"]];
//    NSUInteger shareType = [[self.dataDic objectForKey:@"type"] integerValue];
    NSString *title = [self.dataDic objectForKey:@"shareTitle"];
    NSString *pic =  [self.dataDic objectForKey:@"sharePic"];;
    NSString *content =  [self.dataDic objectForKey:@"shareContent"];
    
    
    [LWShareService shared].shareBtnClickBlock = ^(NSUInteger index) {
        NSLog(@"%lu",(unsigned long)index);
        [[LWShareService shared] hideSheetView];
        
        
        
        if ([PublicMethods isLogIn]) {
            
            //    分享界面
            SSDKPlatformType type = 0;
            
            switch (index) {
                case 0:
                    type = SSDKPlatformSubTypeWechatTimeline;
                    break;
                case 1:
                    type = SSDKPlatformSubTypeWechatSession;
                    break;
                case 2:
                    type = SSDKPlatformTypeSinaWeibo;
                    break;
                case 3:
                    type = SSDKPlatformSubTypeQQFriend;
                    break;
                case 4:
                    type = SSDKPlatformSubTypeQZone;
                    break;
                case 5:
                    type = SSDKPlatformTypeCopy;
                    break;
                
                default:
                    break;
            }
            
            
//            if (shareType == 2) {
                [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
//            }else{
//                [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeVideo copyUrl:url];
//            }
            
            
        }else{
            LoginViewController *log = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:log animated:YES];
        }
        
    };
    
    [[LWShareService shared] showInViewControllerTwo:self];
    
}
@end

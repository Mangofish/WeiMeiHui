//
//  MainViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MainViewController.h"

#import "NextFreeNewViewController.h"
#import "PublishViewController.h"
#import "UIButton+Badge.h"

#import "PopView.h"
#import <RongIMKit/RongIMKit.h>
#import "CustomImagePickerViewController.h"
#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import <AVFoundation/AVFoundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>

#import "JFCityViewController.h"
#import "VideoCutViewController.h"

#import "CustomizationPubViewController.h"
#import "LoginViewController.h"

#import "MainTitleView.h"
#import "SearchTagViewController.h"
#import "QRCodeViewController.h"

//新页面
#import "FamousShopTableViewCell.h"
#import "ActivityThreeTableViewCell.h"
#import "MainExclusiveTableViewCell.h"
#import "SDCycleScrollView.h"

#import "MainCouponAlertView.h"
#import "MyCouponsViewController.h"
#import "JSDropDownMenu.h"
#import "ShopViewController.h"
#import "ExclusiveSecViewController.h"
#import "SecondKillsViewController.h"
#import "MineConversationListViewController.h"
#import "GroupGoodsListsViewController.h"
#import "HNPopMenuManager.h"
#import "HNPopMenuModel.h"

//#import "KSGuaidViewManager.h"
#import "MyCardsListsViewController.h"

#define DefaultLocationTimeout  10
#define DefaultReGeocodeTimeout 10

#define DefaultHeaderHeight (kWidth*200/375)

@interface MainViewController ()<UIGestureRecognizerDelegate,MainTitleViewDelegate,AMapLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,JFCityViewControllerDelegate,MainCouponAlertViewDelegate,ActivityThreeTableViewCellDelegate,SDCycleScrollViewDelegate,JSDropDownMenuDelegate,JSDropDownMenuDataSource,MainExclusiveTableViewCellDelegate>
{
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    
    NSInteger _currentData1SelectedIndex;
    
    NSMutableArray *data1;
    NSMutableArray *data2;
    NSMutableArray *data3;
    
    NSString *order;
    NSString *dump_id;
    NSString *nearby;
    NSString *type;
    
}

@property (nonatomic,copy) NSArray *dataArr;

@property (strong, nonatomic)  NSMutableArray *nearbydataAry;
@property (strong, nonatomic)  NSMutableArray *servicedataAry;
@property (strong, nonatomic)  NSMutableArray *intelldataAry;
@property (nonatomic, strong) JSDropDownMenu *menu;
@property (strong, nonatomic)  UIView *dropView;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, copy) NSArray *couponAry;
@property (nonatomic, assign) NSUInteger messageIndex;
@property (nonatomic, copy) NSArray *messageAry;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) MainCouponAlertView *couponAlertView;
@property (nonatomic, strong) UIView *couponbgView;

@property (nonatomic, copy) NSArray *middleAry;
@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, copy) NSArray *tagAry;
@property (nonatomic, copy) NSDictionary *userDic;
@property (nonatomic, copy) NSDictionary *inviteDic;
@property (nonatomic, copy) NSDictionary *secondsDic;

@property (nonatomic, copy) NSString *groupBooking;
//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

//头部
@property (nonatomic,strong) MainTitleView *titleView;
//轮播
@property (nonatomic,strong) SDCycleScrollView *activityCycleView;


@property (nonatomic, copy) NSArray * imagesURLAry;
@property (nonatomic, strong) YMRefresh *ymRefresh;
@property (nonatomic, strong) YYHud *hud;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 0;
    _page = 1;
    _dataAry = [NSMutableArray array];
    
    self.nearbydataAry = [NSMutableArray array];
    self.intelldataAry = [NSMutableArray array];
    self.servicedataAry = [NSMutableArray array];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
 
    order = @"";
    nearby = @"";
    type = @"";
    dump_id = @"";
    
//    界面基本
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi]) {
         [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:WEIlngi];
    }
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:WEILat]) {
        [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:WEILat];
    }
    
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID]) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:WEILocationCITYID];
//    }
//
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:WEILOCATION]) {
//        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:WEILOCATION];
//    }
//
//    //    引导页
//    KSGuaidManager.images = @[[UIImage imageNamed:@"guid01"],
//                              [UIImage imageNamed:@"guid02"],
//                              [UIImage imageNamed:@"guid03"],
//                              [UIImage imageNamed:@"guid04"]];
//    CGSize size = [UIScreen mainScreen].bounds.size;
//
//    KSGuaidManager.dismissButtonImage = [UIImage imageNamed:@"hidden"];
//    KSGuaidManager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 80);
//    [KSGuaidManager begin];
    
    [self customUI];
    [self locationUI];
    [self getDataAtIndex:1];
    
    
    _imagesURLAry = [NSMutableArray array];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _dropView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaHeight, kWidth, 44)];
    _dropView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dropView];
    _dropView.hidden = YES;
}

- (void)addSelectedView{
    
    // 指定默认选中
    if (!_menu) {
        
        _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        [self.view addSubview:_menu];
        [_menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(self.dropView.mas_right).offset(0);
            make.top.mas_equalTo(self.dropView.mas_top).offset(0);
        }];
        _menu.textColor = FontColor;
        
        _menu.dataSource = self;
        _menu.delegate = self;
        _menu.hidden = YES;
        _currentData1Index = 0;
        _currentData1SelectedIndex = 0;
    }

}

#pragma mark - 下拉列表代理数据源
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    
    if (column==1) {
        
        return _currentData2Index;
    }
    
    if (column==2) {
        
        return _currentData3Index;
        
    }
    
    
    
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        
        if (leftOrRight==0) {
            
            return data1.count;
        } else{
            
            NSDictionary *menuDic = [data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
        
    } else if (column==1){
        
        return data2.count;
        
    } else{
        
        return data3.count;
    }
    
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    
    switch (column) {
        case 0: return [[data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            break;
        case 1: return data2[_currentData2Index];
            break;
        case 2: return data3[_currentData3Index];
            break;
            
        default:
            return nil;
            break;
    }
    
    
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        if (indexPath.leftOrRight==0) {
            
            NSDictionary *menuDic = [data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
            
        } else{
            
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
            
        }
        
    } else if (indexPath.column==1) {
        
        return data2[indexPath.row];
        
    } else {
        
        return data3[indexPath.row];
    }
    
}

#pragma mark- 点击选项刷新界面
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    if (indexPath.column == 0) {
        
//左边
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.leftRow;
            
            return;
            
        }else{
            
            _currentData1SelectedIndex = indexPath.row;
            
        }
        
        
        NSInteger leftRow = indexPath.leftRow;
        NSDictionary *menuDic = [self.nearbydataAry objectAtIndex:leftRow];
        
        NSString *ID = [[[menuDic objectForKey:@"dump_list"] objectAtIndex:_currentData1SelectedIndex] objectForKey:@"id"];
        
        if (leftRow == 0) {
            
            nearby = ID;
            dump_id = @"";
            
        }else{
            
            dump_id = ID;
            nearby = @"";
        }
        
    }else if (indexPath.column==1) {
        
        _currentData2Index = indexPath.row;
        
        order = [self.intelldataAry[indexPath.row] objectForKey:@"id"];
        
    } else {
        
        _currentData3Index = indexPath.row;
        type = [self.servicedataAry[indexPath.row] objectForKey:@"id"];
    }
    
    [self.mainTableView.mj_header beginRefreshing];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
     [super viewWillAppear:animated];
    //    改变发朋友圈状态
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIVIDEO];
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIPhoto];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tabBarController.tabBar.hidden = NO;
    
    if ([PublicMethods isLogIn]) {
        
        self.titleView.cameraBtn.shouldHideBadgeAtZero = YES;
        self.titleView.cameraBtn.badgeValue = [self getUnreadCount];
        self.titleView.cameraBtn.badgeBGColor = MainColor;
        
    }
    
    [self initCompleteBlock];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
//    [self getData];
   
}

#pragma mark - 界面
- (void)locationUI{
    
    //    获取位置
    [self configLocationManager];

}

#pragma mark - 设置定位要求
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

#pragma mark - Initialization，定位之后回调的方法
- (void)initCompleteBlock
{
    
    __weak MainViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error
            if (error.code == AMapLocationErrorLocateFailed)
            {
//                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:WEILat];
//                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:WEIlngi];
//                [[NSUserDefaults standardUserDefaults] setValue:@"长春市" forKey:WEILOCATION];
//                [[NSUserDefaults standardUserDefaults] setValue:@"220100" forKey:WEILocationCITYID];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
                
                if (!city.length) {
                    
                    CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"微美惠提示" message:@"当前定位不可用请前往进行城市选择"];
                    CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                        
                        [weakSelf chooseLocation:nil];
                        
                    } ];
                    
                    [cV addAction:action2];
                    
                    [weakSelf presentViewController:cV animated:YES completion:nil];
                    
                    
                    return;
                    
                }else{
                    
                    NSString *cityC = [[NSUserDefaults standardUserDefaults] valueForKey:WEICurrentCity];
                    [weakSelf.titleView.locationBtn setTitle:cityC forState:UIControlStateNormal];
                    
                }
                
                
            }
        }
        
        //得到定位信息，添加annotation
        if (location)
        {  
            if (regeocode)
            {
                //存当前位置
                [[NSUserDefaults standardUserDefaults] setValue:@(location.coordinate.latitude) forKey:WEILat];
                [[NSUserDefaults standardUserDefaults] setValue:@(location.coordinate.longitude) forKey:WEIlngi];
                [[NSUserDefaults standardUserDefaults] setValue:regeocode.city forKey:WEILOCATION];
                [[NSUserDefaults standardUserDefaults] setValue:regeocode.adcode forKey:WEILocationCITYID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (![[NSUserDefaults standardUserDefaults] valueForKey:WEICurrentCity] && (![[[NSUserDefaults standardUserDefaults] valueForKey:WEICurrentCity] isEqualToString:@"无权限"])) {
                    
                    [weakSelf.titleView.locationBtn setTitle:regeocode.city forState:UIControlStateNormal];
                    
                    CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"微美惠提示" message:@"当前定位不可用请前往进行城市选择"];
                    CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                        
                        [weakSelf chooseLocation:nil];
                        
                    } ];
                    
                    [cV addAction:action2];
                    
                    [weakSelf presentViewController:cV animated:YES completion:nil];
                    
                    
                }else{
                    
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:WEICurrentCity] isEqualToString:@"无权限"]) {
                        [weakSelf.titleView.locationBtn setTitle:regeocode.city forState:UIControlStateNormal];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:regeocode.city forKey:WEICurrentCity];
                        
                        CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"微美惠提示" message:@"当前定位不可用请前往进行城市选择"];
                        CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                            
                            [weakSelf chooseLocation:nil];
                            
                        } ];
                        
                        [cV addAction:action2];
                        
                        [weakSelf presentViewController:cV animated:YES completion:nil];
                        
                        
                        
                    }else{
                        
                        NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:WEICurrentCity];
                        [weakSelf.titleView.locationBtn setTitle:city forState:UIControlStateNormal];
                        
                        if (![regeocode.city isEqualToString:city] && ![[NSUserDefaults standardUserDefaults] valueForKey:ChangeCITY]) {
                            CKAlertViewController *cV =  [CKAlertViewController alertControllerWithTitle:@"微美惠提示" message:@"定位城市与当前城市不符是否立即切换？"];
                            
                            CKAlertAction *action = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:ChangeCITY];
                            } ];
                            CKAlertAction *action2 = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                                
                                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:ChangeCITY];
                                
                               [[NSUserDefaults standardUserDefaults] setValue:regeocode.adcode forKey:WEICITYID];
                               [[NSUserDefaults standardUserDefaults] setValue:regeocode.city forKey:WEICurrentCity];
                                
                                [weakSelf.titleView.locationBtn setTitle:regeocode.city forState:UIControlStateNormal];
                                [weakSelf getDataAtIndex:weakSelf.currentIndex];
                                
                            } ];
                            
                            [cV addAction:action];
                            [cV addAction:action2];
                            
                            [weakSelf presentViewController:cV animated:YES completion:nil];
                            
                        }
                        
                    }
                    
                }
                    
                
//                [weakSelf.titleView.locationBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
                
                NSLog(@"success%f,%f",location.coordinate.latitude, location.coordinate.longitude);
                
            }
            
        }
    };
}


- (void)customUI{
    

    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-48-SafeAreaBottomHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.mainTableView];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        _mainTableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        
    }
    
    
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    //    加刷新
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getDataAtIndex:1];
    }];
    _mainTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getDataAtIndex:1];
    }];
    
//    [_mainTableView.mj_header beginRefreshing];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.titleView];
   
   
    
}




#pragma mark- 添加筛选

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (self.dataAry.count == 0) {
        self->_titleView.backgroundColor = [UIColor whiteColor];
        self->_titleView.backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.dropView.hidden = NO;
        self.menu.hidden = NO;
        
        return;
    }
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    
    if (contentOffsetY > 20) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self->_titleView.backgroundColor = [UIColor whiteColor];
            self->_titleView.backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            self.dropView.hidden = NO;
            self.menu.hidden = NO;
        }completion:^(BOOL finished) {
            
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self->_titleView.backgroundColor = [UIColor clearColor];
           self->_titleView.backView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
            self.menu.hidden = YES;
            self.dropView.hidden = YES;
            
        }completion:^(BOOL finished) {
            
            
        }];
        
    }
   
    
}


#pragma mark - titleView
- (MainTitleView *)titleView{
    
    if (!_titleView) {
        _titleView = [MainTitleView mainTitleView];
    }
    _titleView.delegate = self;
    return _titleView;
    
}

#pragma mark - 优惠券
- (MainCouponAlertView *)couponAlertView{
    
    if (!_couponAlertView) {
        _couponAlertView = [MainCouponAlertView mainCouponAlertViewWithFrame:CGRectMake(0, 0, kWidth-60, 0.8*kHeight)];
        _couponAlertView.center = self.view.center;

        UIView *bg = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:bg];
        bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _couponbgView = bg;
    }
    _couponAlertView.delegate = self;
    
    return _couponAlertView;
    
}

- (void)didClickRecieve{
    
     [self dismiss];
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        return;
    }
    

    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    if (!uuid) {
        uuid = @"";
    }
    
    NSMutableArray *str = [NSMutableArray array];
    
    for (int i=0 ; i<_couponAry.count; i++) {
        [str addObject:_couponAry[i][@"id"]];
        

        
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"coupon_id":str}];
    
    [YYNet POST:IndexGetCoupon paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
//        领取成功
        if ([dict[@"success"] boolValue]) {
            
//            跳转
            
            MyCouponsViewController *outVC = [[MyCouponsViewController alloc]init];
            
            [self.navigationController pushViewController:outVC animated:YES];
            
        }else{
            
            
            
        }
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (void)dismiss{
    
    [self.couponAlertView removeFromSuperview];
    [self.couponbgView removeFromSuperview];
}

#pragma mark - 选择位置
- (void)chooseLocation:(UIButton *)sender{
    
        JFCityViewController *pubVC = [[JFCityViewController alloc]init];
        pubVC.delegate = self;

    [self.navigationController pushViewController:pubVC animated:YES];
    
}

#pragma mark - 选择菜单
- (void)menuAlertAction:(UIButton *)sender{
    
    [HNPopMenuManager showPopMenuWithView:self.view items:self.dataArr action:^(NSInteger row) {
        
        NSLog(@"第%ld行被点击了",row);
        
//        会员卡
        if (row == 2) {
            
            if (![PublicMethods isLogIn]) {
                
                LoginViewController *logVc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:logVc animated:YES];
            }
            
            MyCardsListsViewController *pubVC = [[MyCardsListsViewController alloc]init];
            [self.navigationController pushViewController:pubVC animated:YES];
            
        }
        
        if (row == 0) {
            
            NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
            lists.url = [self.inviteDic objectForKey:@"url"];
            [self.navigationController pushViewController:lists animated:YES];
            
        }
        
        if (row == 1) {
            
            QRCodeViewController *myVC = [[QRCodeViewController alloc]init];
            [self.navigationController pushViewController:myVC animated:NO];
            
        }
        
    } dismissAutomatically:YES];
    
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        NSArray *titleArr = @[@"邀请好友", @"扫一扫",@"我的会员卡"];
        for (int i = 0; i < titleArr.count; i++) {
            HNPopMenuModel *model = [[HNPopMenuModel alloc] init];
            model.title = titleArr[i];
            model.imageName = titleArr[i];
            [tempArr addObject:model];
        }
        _dataArr = [tempArr mutableCopy];
    }
    return _dataArr;
}

#pragma mark - 搜索
- (void)chooseSearch:(UIButton *)sender{
    
    SearchTagViewController *tagVC= [[SearchTagViewController alloc]init];
    tagVC.type = 2;
    [self.navigationController pushViewController:tagVC animated:YES];
}

#pragma mark - 选择消息
-(void)chooseCamera:(UIButton *)sender{

    if (![PublicMethods isLogIn]) {
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
        return;
    }
    
    MineConversationListViewController *tagVC= [[MineConversationListViewController alloc]init];
    [self.navigationController pushViewController:tagVC animated:YES];
    
}

#pragma mark - 获取消息未读数
-(NSString *)getUnreadCount{
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[ @(ConversationType_PRIVATE) ]];
    
    return [NSString stringWithFormat:@"%d",unreadMsgCount];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (self.dataAry.count == 0 ) {
        return 5;
    }
    
    return self.dataAry.count+4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (section == 3) {
        
        if (!self.userDic) {
            return 0;
        }
        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
        [cell.contentView addSubview:self.activityCycleView];
        return cell;
    }
    
    if (indexPath.section == 1) {
        MainExclusiveTableViewCell *cell = [[MainExclusiveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainExclusiveTableViewCell"];
        cell.goodsAry = self.tagAry;
        cell.delegete = self;
        return cell;
    }
    
    if (indexPath.section == 2) {
        
        ActivityThreeTableViewCell *cell = [ActivityThreeTableViewCell activityThreeTableViewCellThreeMain];
        
        [cell.leftImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.secondsDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"] options:(SDWebImageRetryFailed)];
        
        [cell.rightOne sd_setImageWithURL:[NSURL urlWithNoBlankDataString:self.groupBooking] placeholderImage:[UIImage imageNamed:@"test2"] options:(SDWebImageRetryFailed)];
        
        [cell.rightTwo sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.inviteDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"] options:(SDWebImageRetryFailed)];
        
        cell.delegate = self;
        
        return cell;
        
    }
    
    if (indexPath.section == 3) {
        ActivityThreeTableViewCell *cell = [ActivityThreeTableViewCell activityThreeTableViewCellSingleMain];
        [cell.singleImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.userDic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"] options:(SDWebImageRefreshCached)];
        return cell;
        
    }else{
        
        
        if (self.dataAry.count == 0) {
            
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
           
            cell.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"筛选结果" titleStr:@"" detailStr:@"" btnTitleStr:@"" btnClickBlock:^{
                ;
            }];
            
            return cell;
        }
        
        FamousShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main"];
        
        if (!cell) {
            cell = [FamousShopTableViewCell famousShopTableViewCellMain];
        }
        
        cell.authorMain = [ShopAndAuthor shopAuthorWithDict:self.dataAry[indexPath.section-4]];
        return cell;
        
    }
        
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return kWidth*200/375;
    }
    
    if (indexPath.section == 1) {
        return 80;
    }
    
    if (indexPath.section == 2) {
       return   kHeight*135/667 +Space*2;
    }
    
    if (indexPath.section == 3) {
        return   80;
    }
    
    return 189*(kWidth-20)/355+80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section == 2 || section == 1  || section == 0) {
        return 0.00001;
    }
    
    if (section == 3 && !self.userDic) {
        return 0.00001;
    }
    
    return Space;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return nil;
}

#pragma mark - cycleView
- (SDCycleScrollView *)activityCycleView{
    
    if (!_activityCycleView) {
        
        _activityCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, kWidth*200/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        _activityCycleView.currentPageDotImage = [UIImage imageNamed:@"dot"];
        _activityCycleView.pageDotImage = [UIImage imageNamed:@"dot2"];
//        _activityCycleView.autoScroll = YES;
    }
    
    return _activityCycleView;
}

//轮播回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if (_imagesURLAry.count == 0) {
        return;
    }
    
    NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
    adVC.url = [_imagesURLAry[index] objectForKey:@"url"];
    [self.navigationController pushViewController:adVC animated:YES];
    
}


-(void)setImagesURLAry:(NSArray *)imagesURLAry{
    
    _imagesURLAry = imagesURLAry;
    if (_imagesURLAry.count == 0) {
        
        _activityCycleView.localizationImageNamesGroup = @[@"test2"];
        
    }else{
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *obj in _imagesURLAry) {
            [temp addObject:obj[@"banner_pic"]];
        }
        
        _activityCycleView.imageURLStringsGroup = temp;
//        _activityCycleView.autoScroll = YES;
        _activityCycleView.delegate = self;
    }
    
}



#pragma mark - 获取数据
- (void)getDataAtIndex:(NSUInteger)tag{
    
    _currentIndex = tag;
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
         city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
         city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    if (!uuid) {
        uuid = @"";
    }
    
    if (!city_id.length) {
        city_id = @"";
    }
    self.hud = [[YYHud alloc]init];
    [self.hud showInView:self.view];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":type,@"lat":lat,@"lng":lng,@"page":@(_page),@"order":order,@"dump_id":dump_id,@"nearby":nearby}];
    
    [YYNet POST:INDEXList paramters:@{@"json":url} success:^(id responseObject) {
        
        [self.hud dismiss];
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        self.groupBooking = dic[@"groupBooking"];
        
        NSUInteger type = [[dic objectForKey:@"type"] integerValue];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(type) forKey:WEIPUBLISH];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"about_wmh"] forKey:AboutAppUrl];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"share_wmh"] forKey:ShareAppUrl];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"shareContent"] forKey:ShareAppContent];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"shareTitle"] forKey:ShareAppTitle];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"sharePic"] forKey:ShareAppPic];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"plusPic"] forKey:PlusAppPic];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([dic[@"banner_data"] isKindOfClass:[NSArray class]]) {
            
            self.imagesURLAry = dic[@"banner_data"];
            
        }
        
        if ([dic[@"new_user"] isKindOfClass:[NSDictionary class]]) {
            
            self.userDic = dic[@"new_user"];
            
        }
        
        if ([dic[@"secondsKill"] isKindOfClass:[NSDictionary class]]) {
            
            self.secondsDic = dic[@"secondsKill"];
            
        }
        
        
        if ([dic[@"inviteFriends"] isKindOfClass:[NSDictionary class]]) {
            
            self.inviteDic = dic[@"inviteFriends"];
            
        }
        
        if ([dic[@"tag_data"] isKindOfClass:[NSArray class]]) {
            
            self.tagAry = dic[@"tag_data"];
            
        }
        
        if ([dic[@"shop_list"] isKindOfClass:[NSArray class]]) {
            
            if (self.page == 1) {
                
                  [self.dataAry setArray:dic[@"shop_list"]];
                
            }else{
                
                  [self.dataAry addObjectsFromArray:dic[@"shop_list"]];
                
            }
            
        }
        
        if ([[dic objectForKey:@"dump_data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *allData = [dic objectForKey:@"dump_data"];
            [self.nearbydataAry setArray:allData];
            
            self->data1 = [NSMutableArray array];
            //            [self->data1 removeAllObjects];
            for (NSDictionary *obj in allData) {
                
                NSString *title = obj[@"area_name"];
                NSArray *ary = obj[@"dump_list"];
                
                NSMutableArray *rightTemp = [NSMutableArray array];
                
                for (int j=0 ; j<ary.count ; j++) {
                    
                    NSString *fullName = @"";
                    
                    if ([[[ary objectAtIndex:j] objectForKey:@"shop_count"] integerValue] == 0) {
                        
                        fullName = [NSString stringWithFormat:@"%@",ary[j][@"name"]];
                    }else{
                        fullName = [NSString stringWithFormat:@"%@（%@）",ary[j][@"name"],ary[j][@"shop_count"]];
                    }
                    
                    
                    [rightTemp addObject:fullName];
                    
                }
                
                [self->data1 addObject:@{@"title":title, @"data":rightTemp}];
                
            }
            
            
            
        }
        
        if ([[dic objectForKey:@"cut_data"] isKindOfClass:[NSArray class]]) {
            
            [self.servicedataAry setArray:[dic objectForKey:@"cut_data"]];
            
            self->data3 = [NSMutableArray array];
            
            for (NSDictionary *obj in self.servicedataAry) {
                [self->data3 addObject:obj[@"name"]];
            }
            
            
            
        }
        
        if ([[dic objectForKey:@"intelligent"] isKindOfClass:[NSArray class]]) {
            
            [self.intelldataAry setArray:[dic objectForKey:@"intelligent"]];
            
            self->data2 = [NSMutableArray array];
            
            for (NSDictionary *obj in self.intelldataAry) {
                [self->data2 addObject:obj[@"name"]];
            }
            
            
        }
        
        [self addSelectedView];
        
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        
        if (self.dataAry.count == 0) {
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }

    } faild:^(id responseObject) {
        
         [self.hud dismiss];
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getDataAtIndex:0];
        }];
        
        
    }];
    
}



#pragma mark - 城市选择回调
- (void)cityName:(NSString *)name{
    
    if ([name isEqualToString:@"未开启定位权限"]) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"未开启定位权限,请检查定位权限！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
        return;
    }
    
    [self.titleView.locationBtn setTitle:name forState:UIControlStateNormal];
  
    self.page = 1;
    
    [self getDataAtIndex:_currentIndex];
    
}



#pragma mark - 获取数据
- (void)getData{
    
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = @"";
    
    if ([PublicMethods isLogIn]) {
        uuid  = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    if (!city_id.length) {
        city_id = @"";
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@(1),@"lat":lat,@"lng":lng}];
    
    [YYNet POST:INDEXList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        NSUInteger type = [[dic[@"order_data"] objectForKey:@"type"] integerValue];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(type) forKey:WEIPUBLISH];
         [[NSUserDefaults standardUserDefaults] setValue:dic[@"about_wmh"] forKey:AboutAppUrl];
         [[NSUserDefaults standardUserDefaults] setValue:dic[@"share_wmh"] forKey:ShareAppUrl];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"shareContent"] forKey:ShareAppContent];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"shareTitle"] forKey:ShareAppTitle];
        [[NSUserDefaults standardUserDefaults] setValue:dic[@"sharePic"] forKey:ShareAppPic];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        BOOL isCoupon = [[[NSUserDefaults standardUserDefaults] valueForKey:WEICoupon] boolValue];
        
        if ([dic[@"is_receive"] integerValue] == 2 && isCoupon) {
            
            [self.view addSubview:self.couponAlertView];
            
            self.couponAry = dic[@"coupon_list"];
            self.couponAlertView.dataAry = dic[@"coupon_list"];
            self.couponAlertView.imgUrl = dic[@"coupon_image"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:WEICoupon];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    一元
    if (indexPath.section == 3) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.userDic objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
    }
    
    if (indexPath.section >= 4) {
        ShopViewController *shopVC = [[ShopViewController alloc]init];
        shopVC.ID = [self.dataAry[indexPath.section-4] objectForKey:@"id"];
        [self.navigationController pushViewController:shopVC animated:YES];
    }
    
}
- (void)didSelectedAtIndex:(NSUInteger)index{
    
    NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
    lists.url = [self.imagesURLAry[index] objectForKey:@"url"];
    [self.navigationController pushViewController:lists animated:YES];
    
}


#pragma mark -专区
- (void)didClickMenuIndex:(NSInteger)index{
    
    
    ExclusiveSecViewController *exVC = [[ExclusiveSecViewController alloc]init];
    NSString *ID = [self.tagAry[index] objectForKey:@"id"];
    NSString *name = [self.tagAry[index] objectForKey:@"name"];
    
    exVC.ID = ID;
    exVC.name = name;
    
    [self.navigationController pushViewController:exVC animated:YES];
    
}

- (void)selectImg:(NSUInteger)index{
    
    //    秒杀
    if (index == 1) {
        
        SecondKillsViewController *lists = [[SecondKillsViewController alloc]init];
        [self.navigationController pushViewController:lists animated:YES];
        
    }
    
    if (index == 2) {
        
        GroupGoodsListsViewController *lists = [[GroupGoodsListsViewController alloc]init];
        [self.navigationController pushViewController:lists animated:YES];
        
    }
    
    if (index == 3) {
        
        NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
        lists.url = [self.inviteDic objectForKey:@"url"];
        [self.navigationController pushViewController:lists animated:YES];
        
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [HNPopMenuManager dismiss];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
@end

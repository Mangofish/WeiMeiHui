//
//  MyWaitOrderViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyWaitOrderViewController.h"
#import "NormalContentLabel.h"
#import "AlertView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "TYTextContainer.h"

@interface MyWaitOrderViewController ()<AMapSearchDelegate,MAMapViewDelegate,AlertViewDelegate>{
     NormalContentLabel *_contentAttributedLabel;//自身内容
    TYTextContainer * textContainer;
    AlertView *alert;
    UIView *bgTapView;
    NSDictionary *dataDic;
}

@property (nonatomic, strong) AMapSearchAPI *POISearchManager;     //POI检索引擎
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong)NSMutableArray *locations;           //全部的经纬度


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *orderNumBg;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UIView *introBg;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *rangeLan;

@property (weak, nonatomic) IBOutlet UIView *mapBg;
@property (weak, nonatomic) IBOutlet UILabel *pushLab;

@end

@implementation MyWaitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    [self getData];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//懒加载
-(NSMutableArray *)locations{
    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}


- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
//    订单
    [_orderNumBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(Space);
    }];
    
    [_orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.orderNumBg.mas_top).offset(0);
    }];
    
//内容
    
    //创建POI检索引擎
    _POISearchManager = [[AMapSearchAPI alloc] init];
    _POISearchManager.delegate = self;
    
    //创建行政区查询请求
    AMapDistrictSearchRequest *districtSearchRequest = [[AMapDistrictSearchRequest alloc] init];
    districtSearchRequest.keywords           =  @"朝阳区";
    districtSearchRequest.requireExtension   =  YES;
    districtSearchRequest.showBusinessArea   =  YES;
    
    //发起请求,开始POI的行政区检索
    [_POISearchManager AMapDistrictSearch:districtSearchRequest];
}

#pragma mark - <AMapSearchDelegate>
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//收集检索到的行政区目标
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response{
    if (response.count==0) return;
    
    [response.districts enumerateObjectsUsingBlock:^(AMapDistrict * _Nonnull district, NSUInteger idx, BOOL * _Nonnull stop) {
        [self drawDistrictOverLayr:district.polylines];
        [self AddPinAnnotation:district];
        self->_mapView.frame = CGRectMake(Space, Space, kWidth-Space*2, kWidth-Space*2);
    }];
}

//绘制行政区边界
-(void)drawDistrictOverLayr:(NSArray<NSString *> *)polylines{
    
    //获取所有的边界坐标
    [polylines enumerateObjectsUsingBlock:^(NSString * _Nonnull coordinateLngLatObj, NSUInteger idx, BOOL * _Nonnull stop) {
        //截取(目前所有的经纬度是一个连接的整字符串)
        NSArray *all = [coordinateLngLatObj componentsSeparatedByString:@";"];
        [all enumerateObjectsUsingBlock:^(NSString *LngLatObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //再一次截取(将单个经纬度字符串截取出来)
            CLLocationDegrees lng =[[[LngLatObj componentsSeparatedByString:@","]firstObject] doubleValue];
            CLLocationDegrees lat = [[[LngLatObj componentsSeparatedByString:@","]lastObject] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            [self.locations addObject:location];
        }];
    }];
    
    //构造折线数据对象(经纬度)
    CLLocationCoordinate2D commonPolylineCoords[self.locations.count];
    for (int i=0; i<self.locations.count; i++) {
        CLLocation *location = self.locations[i];
        commonPolylineCoords[i].latitude  = location.coordinate.latitude;
        commonPolylineCoords[i].longitude = location.coordinate.longitude;
    }
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.locations.count];
    
    //在地图上添加折线对象
    [_mapView addOverlay:commonPolyline];
    _mapView.frame = CGRectMake(Space, Space, kWidth-Space*2, kWidth-Space*2);
}

//显示行政区中心，并显示大头针
-(void)AddPinAnnotation:(AMapDistrict *)district{
    
    //创建大头针
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(district.center.latitude,district.center.longitude);
    pointAnnotation.title = district.name;
    pointAnnotation.subtitle = district.adcode;
    
    //将大头针添加到地图中
    [_mapView addAnnotation:pointAnnotation];
    
    //默认选中气泡
    [_mapView selectAnnotation:pointAnnotation animated:YES];
    
//    主线程刷新
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        //Update UI in UI thread here
//
//        self->_mapView.frame = CGRectMake(Space, Space, kWidth-Space*2, kWidth-Space*2);
//
//    });
    _mapView.frame = CGRectMake(Space, Space, kWidth-Space*2, kWidth-Space*2);
    
    
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData{
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:MyWaitOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *temp = dict[@"data"];
        self->dataDic = temp;
        self->_priceLab.text = [NSString stringWithFormat:@"%@",temp[@"price"]];
        self->_rangeLan.text = [NSString stringWithFormat:@"服务区域：%@",temp[@"area"]];
        self->_tagLab.text = [NSString stringWithFormat:@"%@",temp[@"service_type"]];
        self->_orderNum.text = [NSString stringWithFormat:@"订单编号：%@",temp[@"order_number"]];
        [self calculateHegihtAndAttributedString:temp[@"content"]];
        [self changeFrame];
        
        
        //字体大小、颜色不统一，全部改变
        NSString *pushString = [NSString stringWithFormat:@"已推送%@个手艺人    %@个手艺人已查看",temp[@"send_num"],temp[@"send_num_yet"]];
        
        NSString *s1 = temp[@"send_num"];
        NSString *s2 = temp[@"send_num_yet"];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:pushString];
        
        [str addAttributes:@{NSForegroundColorAttributeName:MainColor, NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(3, s1.length)];
        [str addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(s1.length+11, s2.length)];
        self->_pushLab.attributedText = str;
        
    
        
    } faild:^(id responseObject) {
        
        
    }];
}


- (void)changeFrame{
    
    _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame: CGRectMake(Space, 54, kWidth-Space*2, textContainer.textHeight)];
    
    if (textContainer.textHeight>46) {
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame: CGRectMake(Space, 54, kWidth-Space*2, 46)];
    }
    
    
  
    _contentAttributedLabel.text = dataDic[@"content"];
    
    _introBg.frame = CGRectMake(0, 45+SafeAreaHeight+Space, kWidth, 100+CGRectGetHeight(_contentAttributedLabel.frame));
    [self.introBg addSubview:_contentAttributedLabel];
    
    [_tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.introBg.mas_top).offset(Space*2);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.top.mas_equalTo(self.introBg.mas_top).offset(Space*2);
    }];
    
    [_rangeLan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(24);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.introBg.mas_bottom).offset(-15);
    }];
    
    [_mapBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(kWidth);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.introBg.mas_bottom).offset(1);
    }];
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(Space, Space, kWidth - Space*2, kWidth - Space*2)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:12.0f animated:YES];
    [_mapBg addSubview:_mapView];
    
    
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"转圈@3x" ofType:@"gif"];
    //将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //创建一个webView，添加到界面
    UIWebView *webView = [[UIWebView alloc] init];
    [self.mapBg  addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-35);
        make.height.mas_equalTo(kWidth-35);
        make.center.mas_equalTo(self.mapBg).offset(0);
    }];
    
    webView.scalesPageToFit = YES;
    webView.scrollView.scrollEnabled = NO;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = 0;
    //加载数据
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    [self configNavView];
    
}

- (IBAction)cancelOrderAction:(UIButton *)sender {
    
    bgTapView = [[UIView alloc]initWithFrame:self.view.bounds];
    bgTapView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:bgTapView];
    
    AlertView *alertView = [AlertView alertViewWithFrame:CGRectMake(Space, kHeight-131-20, kWidth-Space*2, 131)];
    alertView.delegate = self;
    alert = alertView;
    [self.view addSubview:alertView];
    
}



- (void)didClickMenuIndex:(NSInteger)index{
    //          移除
        [UIView animateWithDuration:0.3 animations:^{
            self->alert.frame  =  CGRectMake(Space, kHeight, kWidth-Space*2, 131);
            self->bgTapView.hidden  = YES;
        }completion:^(BOOL finished) {
            [self->bgTapView removeFromSuperview];
            [self->alert removeFromSuperview];
        }];
//          取消订单
    if (index == 1) {
        [self cancelNet];
    }
}

- (void)cancelNet{
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"custom_id":dataDic[@"id"],@"type":@"2"}];
    
    [YYNet POST:CancelOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已取消！" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } faild:^(id responseObject) {
        
        
        
    }];
}

#pragma 计算高度
-(void)calculateHegihtAndAttributedString:(NSString *)content
{
    
    textContainer = [[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=6;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(51, 51, 51);
    
    textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
    
    
}
@end

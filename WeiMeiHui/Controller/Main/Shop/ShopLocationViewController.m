//
//  ShopLocationViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/12.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>

#import "ShopAlertView.h"


#define DefaultLocationTimeout  20
#define DefaultReGeocodeTimeout 20

@interface ShopLocationViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate,AMapSearchDelegate,UIAlertViewDelegate,ShopAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) ShopAlertView *shopalertView;
@property (nonatomic, strong) UIView *shopalertbgView;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) CLLocation *shopLocation;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标

@end

@implementation ShopLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mapView.showsUserLocation = YES;
    
//    [self initCompleteBlock];
    
    [self configLocationManager];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
}

#pragma mark-初始化地图

- (MAMapView *)mapView{
    
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        [_mapView setDelegate:self];
        
        [self.view insertSubview:_mapView belowSubview:_backBtn];
    }
    
    return _mapView;
}



#pragma mark - Initialization
- (void)initCompleteBlock
{
    __weak ShopLocationViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error，则不进行annotation的添加
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //得到定位信息，添加annotation
        if (location)
        {
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setCoordinate:location.coordinate];
            
            if (regeocode)
            {
                [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            }
            else
            {
                [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
                [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
            }
            
            ShopLocationViewController *strongSelf = weakSelf;
            [strongSelf addAnnotationToMapView:annotation];
        }
    };
}

#pragma  - mark- 在地图上添加大头针
- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:15.1 animated:YES];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
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


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    NSLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    CLLocation *location = [[CLLocation alloc]initWithLatitude:_la longitude:_lo];
    [self initActionFromShopLocation:location];
}


- (void)initActionFromShopLocation:(CLLocation *)location{
    if (location) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        [self.search AMapReGoecodeSearch:request];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    //    self.mapView.showsUserLocation = NO;
    //    NSLog(@"%@",response.regeocode.addressComponent.city);
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.mapView.frame = CGRectMake(0, 0, kWidth, kHeight);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    annotation.title = self.name;
    annotation.subtitle = self.address;
    [self addAnnotationToMapView:annotation];
    self.mapView.showsUserLocation = NO;
    
}

#pragma mark - MAMapView Delegate，大头针显示信息
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"L 1-1"];
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        //        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}

- (void)jumpToMap{
    //系统版本高于8.0，使用UIAlertController
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //            NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.la, self.lo) addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //                NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",self.la,self.lo]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting] options:@{} completionHandler:nil];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //                NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting] options:@{} completionHandler:nil];
            
        }]];
    }
    
//    腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://map/"]]) {
        
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
        NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *QQParameterFormat = @"qqmap://map/routeplan?type=drive&fromcoord=%f, %f&tocoord=%f,%f&coord_type=1&policy=0&refer=%@";
            NSString *urlString = [[NSString stringWithFormat: QQParameterFormat, lat, lng, self.la, self.lo, @"微美惠"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }]];
        
    }
    
    
   
    
    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //起点
//        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//        CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake(self.la, self.lo);
//        //终点
//        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCorrdinate addressDictionary:nil]];
//        //默认驾车
//        [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}]; }]];
    
        
       
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
    
    //    }
    //    else {  //系统版本低于8.0，则使用UIActionSheet
    //
    ////        UIActionSheet * actionsheet = [[UIActionSheet alloc] initWithTitle:@"导航到设备" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"自带地图", nil];
    ////
    ////        //如果安装高德地图，则添加高德地图选项
    ////        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
    ////
    ////            [actionsheet addButtonWithTitle:@"高德地图"];
    ////
    ////        }
    ////
    ////        //如果安装百度地图，则添加百度地图选项
    ////        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
    ////
    ////            [actionsheet addButtonWithTitle:@"百度地图"];
    ////        }
    ////
    ////        [actionsheet showInView:self.view];
    //
    //
    //    }
}


- (ShopAlertView *)shopalertView{
    
    if (!_shopalertView) {
        _shopalertView = [ShopAlertView shopAlertViewWithFrame:CGRectMake(60, kHeight/3, kWidth-120, kHeight/3)];
        
        UIView *bg = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:bg];
        bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _shopalertbgView = bg;
        _shopalertView.dataAry = _matterAry;
    }
    _shopalertView.delegate = self;
    
    return _shopalertView;
    
}

- (void)didClickMenuIndex:(NSInteger)index{
    
    NSString *wID = [[self.matterAry objectAtIndex:index] objectForKey:@"id"];
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"id":wID,@"shop_id":_ID}];
    
    [YYNet POST:ShopError paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"status"] integerValue] == 1) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"反馈成功" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            [self dismiss];
//            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"反馈失败，请重试" iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (void)dismiss{
    
    [self.shopalertView removeFromSuperview];
    [self.shopalertbgView removeFromSuperview];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)matterAction:(UIButton *)sender {
    
    [self.view addSubview:self.shopalertView];
    
}


- (IBAction)turnToLocal:(UIButton *)sender {
    [self jumpToMap];
}




@end

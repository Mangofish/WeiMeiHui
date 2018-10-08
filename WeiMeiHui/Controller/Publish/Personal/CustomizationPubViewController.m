//
//  CustomizationPubViewController.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CustomizationPubViewController.h"
#import "PersonalTableViewCell.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"
#import "CustomImagePickerViewController.h"
#import "ZYKeyboardUtil.h"
#import "PriceSelectView.h"
#import "HotAreaViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>

#import "AllMineOrderListsViewController.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SureGuideView.h"
#import "NextFreeNewViewController.h"

#define DefaultLocationTimeout  20
#define DefaultReGeocodeTimeout 20

@interface CustomizationPubViewController ()<UITableViewDelegate, UITableViewDataSource,PersonalTableViewCellDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate,PriceSelectViewDelegate,AMapLocationManagerDelegate>
{
    NSMutableArray *menName;
    NSMutableArray *womenName;
    NSArray *manSelect;
    NSArray *womenSelect;
    NSArray *newerAry;
    NSArray *finalSelectAry;
    NSMutableArray *selectedImgAry;
    NSMutableArray *selectedAsset;
    float cellheight;
    NSMutableArray *areaAry;
    NSMutableArray *nameAry;
    NSString *areaName;
    NSString *priceRange;
//    参数
    NSString *sex;
    NSString *serviceID;
    NSUInteger minPrice ;
    NSUInteger maxPrice;
    NSString *typeLimit;
    NSString *dumps_name;
    NSString *areaLocationID;
    YYHud *hud;
}

//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;
@property (strong, nonatomic)  UITableView *mainTableView;
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;
@property (nonatomic,copy) NSString  *code;
@property (nonatomic,copy) NSString  *areaId;
@property (strong, nonatomic)  UITextField *cellTexTF;
@property (strong, nonatomic)  UITextField *cellPriceTF;
@property (strong, nonatomic)  UITextView *cellNoteTF;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@property (strong, nonatomic)  UIView *bgMaskView;
@property (nonatomic,copy) NSString  *protocolUrl;

@property (nonatomic,strong) PriceSelectView *priceSelectView;
@end

@implementation CustomizationPubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    menName = [NSMutableArray array];
    womenName = [NSMutableArray array];
    selectedImgAry = [NSMutableArray array];
    selectedAsset = [NSMutableArray array];
    
    nameAry = [NSMutableArray array];
    areaAry = [NSMutableArray array];
    
    sex = @"1";
    serviceID = @"";
    areaName = @"";
    priceRange= @"";
    dumps_name = @"";
    cellheight = 0.0;
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) { //定位功能可用
        typeLimit = @"1";
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        typeLimit = @"2";
    }
    
//    if ([SureGuideView shouldShowGuider]) {
//        [SureGuideView sureGuideViewWithImageName:@"guide" imageCount:6];
//    }
    
    [self locationUI];
    [self configNavView];
    [self getData];
}

- (void)locationUI{
    
    //    获取位置
    [self configLocationManager];
    [self initCompleteBlock];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
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
    
    //    __weak PublishViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:WEILat];
                [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:WEIlngi];
                [[NSUserDefaults standardUserDefaults] setValue:@"长春市" forKey:WEILOCATION];
                [[NSUserDefaults standardUserDefaults] setValue:@"220100" forKey:WEILocationCITYID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return;
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
                self->typeLimit = @"1";
                self->dumps_name = regeocode.POIName;
                self->areaLocationID = regeocode.adcode;
                NSLog(@"success%f,%f",location.coordinate.latitude, location.coordinate.longitude);
                
            }
            
        }
    };
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
    
    [_pubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView =[[UITableView alloc]initWithFrame: CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space - Space*4) style:UITableViewStyleGrouped];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;

    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 发布
- (IBAction)pubAction:(UIButton *)sender {
    
    if (!sex.length) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请选择您的性别" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    if (!serviceID.length) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请选择想要的服务！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    if (!_code) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请补全服务区域！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    if (!priceRange.length) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请选择订制价格！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    
    if (selectedImgAry.count) {
        [self uploadPics];
    }else{
        [self sendNoPic];
    }
}

- (void)sendNoPic{
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *dumps_type = @"";
    
    if (_areaId.length == 0) {
        _areaId = areaLocationID;
        dumps_type = @"2";
    }else{
        dumps_type = @"1";
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"min_price":@(minPrice),@"content":_cellNoteTF.text,@"max_price":@(maxPrice),@"service_id":serviceID,@"area_id":_areaId,@"uuid":uuid,@"sex":sex,@"dumps_id":_code,@"lng":lng,@"lat":lat,@"dumps_name":dumps_name,@"dumps_type":dumps_type}];
    
    [YYNet POST:SendCustomization paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        [self->hud dismiss];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已发布" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            [self.navigationController popViewControllerAnimated:YES];
       
            AllMineOrderListsViewController *orderVC = [[AllMineOrderListsViewController alloc]init];
            orderVC.status = @"2";
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"发布失败" iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
           
            
        }
        
      
        
    } faild:^(id responseObject) {
        [self->hud dismiss];
    }];
    
}

#pragma mark- 上传图片
- (void)uploadPics{
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    //链接网络
    NSMutableArray *imgAry = [NSMutableArray array];
    for (int i=0; i<selectedImgAry.count; i++) {
        YYNetModel *model = [[YYNetModel alloc]init];
        model.fileData = [self imageToData:selectedImgAry[i]];
        model.fileName = [NSString stringWithFormat:@"%i.png",arc4random()%10];
        model.name = [NSString stringWithFormat:@"image%i",i+1];
        model.mimeType = @"image/png";
        [imgAry addObject:model];
    }
    
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *dumps_type = @"";
    
    if (_areaId.length == 0) {
        _areaId = areaLocationID;
        dumps_type = @"2";
    }else{
        dumps_type = @"1";
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"min_price":@(minPrice),@"content":_cellNoteTF.text,@"max_price":@(maxPrice),@"service_id":serviceID,@"area_id":_areaId,@"uuid":uuid,@"sex":sex,@"dumps_id":_code,@"lng":lng,@"lat":lat,@"dumps_name":dumps_name,@"dumps_type":dumps_type}];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:SendCustomization parameters:@{@"json":url} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (YYNetModel *model in imgAry) {
            [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         [self->hud dismiss];
        NSLog(@"上传图片成功返回：%@",dic);
        if ([dic[@"status"] integerValue] == 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            AllMineOrderListsViewController *orderVC = [[AllMineOrderListsViewController alloc]init];
            orderVC.status = @"2";
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }
        
        //            判断是否需要跳转分享界面
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         [self->hud dismiss];
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"网络连接超时" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
        
    }];
    
}

#pragma mark - 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Space;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
//        if (indexPath.row == 1) {
            return cellheight+44;
//        }
//        return 84;
        
    }
    
    if (indexPath.section == 1) {
        return 44;
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
                return 115+40;
            
        }
        
        if (indexPath.row == 1) {
            return 100;
        }
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PersonalTableViewCell *cell = [PersonalTableViewCell personalTableViewCellOne];
        if (indexPath.row == 0) {
            cell.titleLab.text = @"您的性别";
            cell.sextagAry = @[@"女",@"男"];
        }else{
            cell.titleLab.text = @"想要的服务";
            cell.tagAry = newerAry;
        }
        
        cellheight = cell.cellHeight;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 1) {
        
        PersonalTableViewCell *cell = [PersonalTableViewCell personalTableViewCellTwo];
        
        if (indexPath.row == 1) {
            cell.serviceLab.text = @"服务价格区间";
            cell.rangLab.text = priceRange;
            cell.rangLab.textColor = MainColor;
            
        }else{
            cell.serviceLab.text = @"服务区域";
            cell.rangLab.text = areaName;
            cell.rangLab.textColor = LightFontColor;
        }
        
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            PersonalTableViewCell *cell = [PersonalTableViewCell personalTableViewCellThreeWithString:@"上传您的照片或者想要造型的照片(0/4)"];
            cell.stateStr = @"上传您的照片或者想要造型的照片";
            cell.type = 0;
            cell.delegate = self;
            cell.selectedAry = selectedImgAry;
            return cell;
        }else{
            PersonalTableViewCell *cell = [PersonalTableViewCell personalTableViewCellFour];
             _cellNoteTF = cell.noteTF;
            [self addToolTab];
            self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:5];
            __weak CustomizationPubViewController *weakSelf = self;
            __block UITextView* blockTf = _cellNoteTF;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
            [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
                [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:blockTf, nil];
            }];
            [ZZLimitInputManager limitInputView:blockTf maxLength:120];
            return cell;
        }
        
        
    }
    
}

- (void)getData{
    
    //网络请求
    
    NSString *ciyid = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        ciyid = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        ciyid = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"city_id":ciyid,@"type":typeLimit}];
    
    [YYNet POST:GetServiceType paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.protocolUrl = [dic[@"data"] objectForKey:@"service_clause"];
        
        self->manSelect = [dic[@"data"] objectForKey:@"man"];
        self->womenSelect = [dic[@"data"] objectForKey:@"woman"];
        
        for (NSDictionary *obj in self->manSelect) {
            [self->menName addObject: [obj objectForKey:@"s_name"] ];
        }
        
        for (NSDictionary *obj in self->womenSelect) {
            [self->womenName addObject: [obj objectForKey:@"s_name"] ];
        }
        
        NSArray *temp =  [dic[@"data"] objectForKey:@"dump_lists"];
        for (NSDictionary *obj in temp) {
            [self->nameAry addObject:obj[@"area_name"]];
            
            NSArray *secTemp = obj[@"dump_list"];
            [self->areaAry addObject:secTemp];
            
        }
        
        self->minPrice = [[dic[@"data"] objectForKey:@"min_price"] integerValue];
        self->maxPrice = [[dic[@"data"] objectForKey:@"max_price"] integerValue];
        
        self->newerAry = self->womenName;
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
}

#pragma mark- 选择性别
- (void)chooseSex:(NSUInteger)index{
    if (index == 0) {
        newerAry = womenName;
        sex = @"1";
    }else{
        newerAry = menName;
        sex = @"0";
    }

    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)chooseServiceAry:(NSArray *)data{
    finalSelectAry = data;
    
    if (data.count == 0) {
        return;
    }
    NSString *temp = [data objectAtIndex:0];
    NSUInteger index = 0;
    if ([sex isEqualToString:@"1"]) {
        
         index = [womenName indexOfObject:temp];
        
    }else{
         index = [menName indexOfObject:temp];
    }
    
    serviceID = [manSelect[index] objectForKey:@"id"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            HotAreaViewController *hotVc = [[HotAreaViewController alloc]init];
            hotVc.categoryData = nameAry;
            hotVc.areaData = areaAry;
            hotVc.chooseComplete = ^(NSString *aName, NSString *areaid, NSString *cityid) {
              
                self->areaName = aName;
                self->_code = cityid;
                self->_areaId = areaid;
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
                [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
                
            };
            
            [self.navigationController pushViewController:hotVc animated:YES];
            
        }else{
            
            
            [UIView animateWithDuration:0.5 animations:^{
                self.priceSelectView.center = self.view.center;
            }];
            
        }
    }
}



- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        self->_priceSelectView.frame = CGRectMake(10, kHeight, kWidth-20, 160);
    } completion:^(BOOL finished) {
        
        self.bgMaskView.hidden = YES;
        
    }];
}

#pragma mark- 选择价格

-(PriceSelectView *)priceSelectView{
    
    if (!_priceSelectView) {
        
        _bgMaskView = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_bgMaskView];
        _bgMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_bgMaskView addGestureRecognizer:tap];
        _bgMaskView.hidden =  NO;
        
        _priceSelectView = [PriceSelectView priceSelectView];
        _priceSelectView.frame = CGRectMake(10, kHeight, kWidth-20, 160);
        _priceSelectView.layer.cornerRadius = 12;
        _priceSelectView.layer.masksToBounds = YES;
        _priceSelectView.delegate = self;
        
        [self.view addSubview:_priceSelectView];
        
    }
    _bgMaskView.hidden = NO;
    return _priceSelectView;
}

#pragma mark- 添加图片
- (void)chooseAddPic{
    
    [self pushTZImagePickerController];
    
}

#pragma mark- 跳转相册
- (void)pushTZImagePickerController {
    
    CustomImagePickerViewController *imagePickerVc = [[CustomImagePickerViewController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = selectedAsset;

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark- 图片选择回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    [selectedAsset setArray:assets];
    [selectedImgAry setArray: photos];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
    
    [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
    
}

#pragma mark- 压缩图像，裁剪图像
-(NSData *)imageToData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//3M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//1.5M-3M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-1.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    
    NSLog(@"图片压缩%lu",data.length/1024);
    
    return data;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 选择价格回调
- (void)chooseMax:(NSString *)maxValue min:(NSString *)minValue{
    
    NSUInteger minP = [minValue integerValue];
    NSUInteger maxP = [maxValue integerValue];
    
    if (minP > maxP) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请填写正确的价格区间！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    if (minP == 0 || maxP == 0) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请填写正确的价格区间！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    [self tapCover:nil];
    
    maxPrice = [maxValue integerValue];
    minPrice = [minValue integerValue];
    
    priceRange = [NSString stringWithFormat:@"%@-%@元",minValue,maxValue];
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)chooseDelPic:(NSUInteger)index{
    
    [selectedAsset removeObjectAtIndex:index];
    [selectedImgAry removeObjectAtIndex:index];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
    
    [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
    
}

- (void)addToolTab{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    //        [topView setBarStyle:UIBarStyleBlackTranslucent];//设置增加控件的基本样式，UIBarStyleDefault为默认样式。
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(doneWithIt) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"确定" forState:(UIControlStateNormal)];
    btn.backgroundColor = MainColor;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [_cellNoteTF setInputAccessoryView:topView];
    
}

- (void)doneWithIt{
    [self.view endEditing:YES];
    
}

- (void)chooseLookPic:(NSUInteger)index{
    
    id asset = selectedAsset[index];
    BOOL isVideo = NO;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
    }
    if (isVideo) { // perview video / 预览视频
        
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:selectedAsset selectedPhotos:selectedImgAry index:index];
        imagePickerVc.maxImagesCount = 4;
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self->selectedImgAry = [NSMutableArray arrayWithArray:photos];
            self->selectedAsset = [NSMutableArray arrayWithArray:assets];
            [self.mainTableView reloadData];
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([SureGuideView shouldShowGuider]) {
        [SureGuideView sureGuideViewWithImageName:@"guide" imageCount:6 viewController:self];
    }
    
}

- (IBAction)protocolAction:(UIButton *)sender {
    
    
    NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
    lists.url = self.protocolUrl;
    [self.navigationController pushViewController:lists animated:YES];
    
}


@end

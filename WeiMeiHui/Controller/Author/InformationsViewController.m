//
//  InformationsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "InformationsViewController.h"
#import "SPPageMenu.h"
#import "InformationBaseTableViewController.h"
#import "PopView.h"
#import "CustomImagePickerViewController.h"
#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "PublishViewController.h"
#import "VideoCutViewController.h"
#import "SearchTagViewController.h"

@interface InformationsViewController ()<SPPageMenuDelegate, UIScrollViewDelegate,PopViewDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UIButton *img;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (copy, nonatomic) NSArray *tagAry;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (weak, nonatomic) IBOutlet UIButton *realBtn;
@property (nonatomic, strong) YYHud *hud;

@end

@implementation InformationsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myChildViewControllers = [NSMutableArray array];
    [self configUI];
    
}

- (void)configUI{
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*3-40);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.top.mas_equalTo(self.bgView.mas_top).offset(SafeAreaTopHeight);
    }];
    _searchBgView.layer.cornerRadius = 18;
    _searchBgView.layer.masksToBounds = NO;
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.searchBgView.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.searchBgView.mas_centerY).offset(0);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*3-40);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(self.searchBgView.mas_left).offset(0);
        make.centerY.mas_equalTo(self.searchBgView.mas_centerY).offset(0);
    }];
    
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.searchBgView.mas_centerY).offset(0);
    }];
    
//    [_cameraBtn addTarget:self action:@selector(chooseCamera:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view  bringSubviewToFront:_cameraBtn];
   
    [_realBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*3-40);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.top.mas_equalTo(self.bgView.mas_top).offset(SafeAreaTopHeight);
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SafeAreaHeight+44, kWidth, kHeight-SafeAreaHeight-44-SafeAreaBottomHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    [self getData];
}


- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(1),@"type":@"1",@"city_id":city_id}];
    
    self.hud = [[YYHud alloc]init];
    [self.hud showInView:self.view];
    
    [YYNet POST:GroupList paramters:@{@"json":url} success:^(id responseObject) {
        [self.hud dismiss];
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([[dic[@"data"] objectForKey:@"type"] isKindOfClass:[NSArray class]]) {
            self.tagAry = [dic[@"data"] objectForKey:@"type"];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.tagAry) {
                [temp addObject:obj[@"name"]];
            }
            
            self.dataArr = temp;
            
            [self customUI];
            
        }
        
        
        
    } faild:^(id responseObject) {
        [self.hud dismiss];
    }];
    
}

- (void)customUI{
    
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, SafeAreaHeight, kWidth, 44) trackerStyle:SPPageMenuTrackerStyleLine];
    pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.dataArr selectedItemIndex:0];
    pageMenu.needTextColorGradients = NO;
    pageMenu.dividingLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 设置代理
    pageMenu.delegate = self;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        
        InformationBaseTableViewController *baseVc = [[InformationBaseTableViewController alloc] init];
        baseVc.type = [self.tagAry[i] objectForKey:@"id"];
        [self addChildViewController:baseVc];
        [self.myChildViewControllers addObject:baseVc];
        
    }
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        InformationBaseTableViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [self.scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(kWidth*self.pageMenu.selectedItemIndex, 0, kWidth, kHeight-SafeAreaHeight-44-49-SafeAreaBottomHeight);
        _scrollView.contentOffset = CGPointMake(kWidth*self.pageMenu.selectedItemIndex, 0);
        _scrollView.contentSize = CGSizeMake(self.dataArr.count*kWidth, 0);
    }
    
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(kWidth * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(kWidth * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(kWidth * toIndex, 0, kWidth,kHeight-SafeAreaHeight-44-49-SafeAreaBottomHeight);
    [_scrollView addSubview:targetViewController.view];
    
}


#pragma mark - 选择相机
- (void)chooseCamera:(UIButton *)sender{
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *userVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
        return;
    }
    
    UIView *bg = [[UIView alloc]initWithFrame:self.view.bounds];
    bg.tag = 100086;
    bg.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.5];
    [self.view addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [bg addGestureRecognizer:tap];
    
    PopView *view = [PopView popView];
    view.delegate = self;
    view.center = self.view.center;
    [bg addSubview:view];
    
}

-(void)didClickMenuIndex:(NSInteger)index{
    
    [[self.view viewWithTag:100086] removeFromSuperview];
    [self popOverViewDidClickMenuIndex:index];
    
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    [tap.view removeFromSuperview];
    
    
}

#pragma mark - 发朋友圈选项
- (void)popOverViewDidClickMenuIndex:(NSInteger)index
{
    
    //    相册
    if (index == 1) {
        
        CustomImagePickerViewController *imgVC= [[CustomImagePickerViewController alloc]initWithMaxImagesCount:9 delegate:self];
        [self presentViewController:imgVC animated:YES completion:nil];
        
    }else{
        //        相机
        CameraViewController *imgVC= [[CameraViewController alloc]init];
        imgVC.recordComplete = ^(NSString *aVideoUrl, NSString *aThumUrl) {
            
            //录制完的视频保存到相册
            
            if (iOS9Later) {
                __block NSString *createdAssetID =nil;
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    
                    createdAssetID = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL urlWithNoBlankDataString:aVideoUrl]].placeholderForCreatedAsset.localIdentifier;
                    
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"保存成功");
                        PHFetchResult *phFetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetID] options:nil];
                        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
                        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                        
                        [phFetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                PublishViewController *pubVC = [[PublishViewController alloc]init];
                                pubVC.assetLater = obj;
                                pubVC.selectedVideo = aVideoUrl;
                                [self.navigationController pushViewController:pubVC animated:YES];
                                
                            });
                            
                            
                            
                        }];
                        
                        
                    } if (error) {
                        
                        NSLog(@"%@",error);
                        
                    }
                    
                }];
                
                
                
            }else{
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                
                NSURL *url = [NSURL fileURLWithPath:aVideoUrl];
                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:url]) {
                    [library writeVideoAtPathToSavedPhotosAlbum:url
                                                completionBlock:^(NSURL *assetURL, NSError *error){
                                                    
                                                    [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                                        
                                                        PublishViewController *pubVC = [[PublishViewController alloc]init];
                                                        pubVC.selectedAsset = assetURL;
                                                        pubVC.selectedVideo = aVideoUrl;
                                                        pubVC.lib = library;
                                                        [self.navigationController pushViewController:pubVC animated:YES];
                                                        
                                                    } failureBlock:^(NSError *error) {
                                                        
                                                    }];
                                                    
                                                }];
                };
                
                
            }
            
            
        };
        
        //        拍照之后保存到相册
        imgVC.photoComplete = ^(NSData *aPhotoUrl) {
            
            UIImage *img = [UIImage imageWithData:aPhotoUrl];
            
            if (iOS8Later) {
                
                PublishViewController *pubVC = [[PublishViewController alloc]init];
                pubVC.selectedImg = aPhotoUrl;
                [self.navigationController pushViewController:pubVC animated:YES];
                
            }else{
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                
                [library writeImageToSavedPhotosAlbum:img.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    PublishViewController *pubVC = [[PublishViewController alloc]init];
                    pubVC.selectedAsset = assetURL;
                    pubVC.selectedImg = aPhotoUrl;
                    pubVC.lib = library;
                    [self.navigationController pushViewController:pubVC animated:YES];
                    
                }];
            }
            
            
        };
        
        [self presentViewController:imgVC animated:YES completion:nil];
        
    }
}

#pragma mark- 图片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    PublishViewController *pubVC = [[PublishViewController alloc]init];
    pubVC.selectedAssets = [NSMutableArray arrayWithArray:assets];
    pubVC.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    
    //    改变发朋友圈状态
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
    
    if (photos.count == 9) {
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIPhoto];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIPhoto];
    }
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    pubVC.publishComplete = ^(NSString *aUrl) {
        
    };
    
    [self.navigationController pushViewController:pubVC animated:YES];
    
}

#pragma mark- 视频回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    NSTimeInterval time = 0.f ;
    __block NSURL *url;
    //    获取时间
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        time = phAsset.duration;
        
    }else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        time = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
    }
    
    
    
    
    if (time>10) {
        
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            time = phAsset.duration;
            
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                
                NSString * sandboxExtensionTokenKey = info[@"PHImageFileSandboxExtensionTokenKey"];
                
                NSArray * arr = [sandboxExtensionTokenKey componentsSeparatedByString:@";"];
                
                NSString * filePath = [arr[arr.count - 1]substringFromIndex:9];
                
                url = [NSURL URLWithString:[NSString stringWithFormat:@"file:///%@",filePath]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    VideoCutViewController *pubVC = [[VideoCutViewController alloc]initClipVideoVCWithAssetURL:url];
                    pubVC.videoClipComplete = ^(NSURL *aPhotoUrl) {
                        
                        
                        
                        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                        
                        NSString *url = [NSString stringWithFormat:@"%@",aPhotoUrl];
                        url = [url stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                        
                        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:aPhotoUrl]) {
                            [library writeVideoAtPathToSavedPhotosAlbum:aPhotoUrl
                                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                                            
                                                            
                                                            PHFetchResult *ass = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
                                                            
                                                            //                                                            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                                            
                                                            dispatch_async( dispatch_get_main_queue(), ^{
                                                                
                                                                PublishViewController *pubVC = [[PublishViewController alloc]init];
                                                                pubVC.selectedAsset = assetURL;
                                                                pubVC.selectedVideo = url;
                                                                pubVC.lib = library;
                                                                pubVC.assetLater = ass[0];
                                                                
                                                                pubVC.publishComplete = ^(NSString *aUrl) {
                                                                    
                                                                };
                                                                
                                                                [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
                                                                [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIPhoto];
                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                
                                                                [self.navigationController pushViewController:pubVC animated:YES];
                                                                
                                                            });
                                                            
                                                            
                                                            //                                                            } failureBlock:^(NSError *error) {
                                                            //
                                                            //                                                            }];
                                                            
                                                        }];
                        };
                        
                        
                    };
                    [self.navigationController pushViewController:pubVC animated:YES];
                });
                
                
            }];
            
        }else if ([asset isKindOfClass:[ALAsset class]]) {
            
            ALAsset *alAsset = asset;
            time = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
            
            ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
            NSString *uti = [defaultRepresentation UTI];
            url = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                VideoCutViewController *pubVC = [[VideoCutViewController alloc]initClipVideoVCWithAssetURL:url];
                pubVC.videoClipComplete = ^(NSURL *aPhotoUrl) {
                    
                    
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    
                    NSString *url = [NSString stringWithFormat:@"%@",aPhotoUrl];
                    url = [url stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                    
                    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:aPhotoUrl]) {
                        [library writeVideoAtPathToSavedPhotosAlbum:aPhotoUrl
                                                    completionBlock:^(NSURL *assetURL, NSError *error){
                                                        
                                                        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                                            
                                                            dispatch_async( dispatch_get_main_queue(), ^{
                                                                
                                                                PublishViewController *pubVC = [[PublishViewController alloc]init];
                                                                pubVC.selectedAsset = assetURL;
                                                                pubVC.selectedVideo = url;
                                                                pubVC.lib = library;
                                                                pubVC.assetLater = asset;
                                                                pubVC.publishComplete = ^(NSString *aUrl) {
                                                                    
                                                                };
                                                                
                                                                [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
                                                                [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIPhoto];
                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                
                                                                [self.navigationController pushViewController:pubVC animated:YES];
                                                                
                                                            });
                                                            
                                                            
                                                            
                                                        } failureBlock:^(NSError *error) {
                                                            
                                                        }];
                                                        
                                                    }];
                    };
                    
                    
                };
                [self.navigationController pushViewController:pubVC animated:YES];
            });
            
        }
        
        
    }else{
        
        PublishViewController *pubVC = [[PublishViewController alloc]init];
        pubVC.selectedAssets = [NSMutableArray arrayWithObject:asset];
        pubVC.selectedPhotos = [NSMutableArray arrayWithObject:coverImage];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIPhoto];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        分享回调
        pubVC.publishComplete = ^(NSString *aUrl) {
            
        };
        
        [self.navigationController pushViewController:pubVC animated:YES];
    }
   
}

- (IBAction)choosePhoto:(UIButton *)sender {
    [self chooseCamera:sender];
}


- (IBAction)chooseSearch:(UIButton *)sender {
    
    SearchTagViewController *tagVC= [[SearchTagViewController alloc]init];
    tagVC.type = 2;
    [self.navigationController pushViewController:tagVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
@end

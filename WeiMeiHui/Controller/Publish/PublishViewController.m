//
//  PublishViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PublishViewController.h"
#import "UITextView+Placeholder.h"
#import "CustomImagePickerViewController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZCollectionViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "PublishFooterCollectionReusableView.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>

#import "AllShopViewController.h"
#import "AllRangeViewController.h"

#import "CameraViewController.h"

#import "BANetManager_OC.h"
#import "PopView.h"
#import "ShareService.h"
#import "ZYKeyboardUtil.h"

#define DefaultLocationTimeout  10
#define DefaultReGeocodeTimeout 10
#define MAXPICCOUNT 9
#import "GBTagListView.h"

#import "UIImage+Orientation.h"
#import "VideoCutViewController.h"

@interface PublishViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,PublishFooterViewDelegate,AMapLocationManagerDelegate,PopViewDelegate>

{
//    NSMutableArray *_selectedPhotos;
//    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    YYHud *hud;
    NSString *group_type;
    NSMutableArray *shareAry;
    NSString *tagIDs;
}

@property (strong, nonatomic) GBTagListView *bubbleView;
@property (copy, nonatomic) NSArray *tagAry;

//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (weak, nonatomic) IBOutlet UIView *contentBgView;

//内容
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
//相册
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
//图片展示
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) TZCollectionViewFlowLayout *layout;
@property (nonatomic, strong) PublishFooterCollectionReusableView *footView;

@property (weak, nonatomic) IBOutlet UIView *tagBgVeiw;
@property (weak, nonatomic) IBOutlet UILabel *catLab;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tagIDs = @"";
    
    [self configNavView];
    
    [self getTagData];
    self.tabBarController.tabBar.hidden = YES;
    
    if (_selectedImg) {
        
        _selectedPhotos = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        
        [self addSelectedImageIntoLocation:_selectedImg];
        
        
    }else if(_selectedAsset){
        
        _selectedPhotos = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        
        [self addSelectedVideoIntoLocation:_selectedAsset];
        
    }else if(_assetLater){
        
        _selectedPhotos = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        
        [self addSelectedVideoIntoLocation:_selectedAsset];
        
    }else{
        
        [self.collectionView reloadData];
        
    }
    
    shareAry = [NSMutableArray array];
    [self customUI];
//    判断是否是手艺人
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    if ([[dic objectForKey:@"level"] integerValue] != 3) {
        
        [self getData];
        
    }
//else{
//
//
//
//    }
    

}


- (void)getData{
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:GetShopID paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        self.shopID = [dict[@"data"] objectForKey:@"id"];
        self.shopName = [dict[@"data"] objectForKey:@"shop_name"];
        
//        添加标签
//        if ([[dict[@"data"] objectForKey:@"filtrate"] isKindOfClass:[NSArray class]]) {
//
//            self.tagAry = [dict[@"data"] objectForKey:@"filtrate"];
//
//        }
        
//       默认选择
        [self.collectionView reloadData];
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
    
}

- (void)getTagData{
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:IGetTag paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
//                添加标签
                if ([dict[@"data"]  isKindOfClass:[NSArray class]]) {
        
                    self.tagAry = dict[@"data"];
                    
                }

    } faild:^(id responseObject) {
        
        
        
    }];
    
    
}

#pragma mark- 界面
- (void) customUI{
    
    [self locationUI];
//    [self configNavView];
    self.contentTextView.placeholder = @"此时此刻，想随便说点什么呢";
    [self configCollectionView];
    
    if (!_shopID) {
        _shopID = @"";
    }
    
    if (!_rangeID) {
        _rangeID = @"1";
    }
    
}

#pragma mark- 图片展示
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[TZCollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(5, 5,5, 5);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    //注册footerView Nib的view需要继承UICollectionReusableView
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PublishFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PublishFooterCollectionReusableView"];
    
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
    
    
}


- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 43, kWidth, 0)];
        _bubbleView.isDefaultSelect = NO;
        /**允许点击 */
        _bubbleView.canTouch=YES;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=NO;
        _bubbleView.signalTagColor=MJRefreshColor(242, 242, 242);
        
       
    }
    
    return _bubbleView;
    
}
- (void)setTagAry:(NSArray *)tagAry{
    _tagAry = tagAry;
    [_bubbleView removeFromSuperview];
    [self.tagBgVeiw addSubview:self.bubbleView];
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *obj in tagAry) {
        [temp addObject:obj[@"name"]];
    }
    
    
    
    [_bubbleView setDidselectItemBlock:^(NSArray *arr) {
        //        //            更改数据
        NSMutableString *tagTemp = [NSMutableString string];
        for (int i =0 ; i<arr.count ; i++)  {
            
            NSString *obj = arr[i];
            NSUInteger index = [temp indexOfObject:obj];
            
            NSString *ID = [[tagAry objectAtIndex:index] objectForKey:@"id"];
            [tagTemp appendString:ID];
            
            if (i != arr.count-1) {
                [tagTemp appendString:@","];
            }
            
        }
        
        self->tagIDs = tagTemp;
        
    }];
    
   
    
    [self.bubbleView setTagWithTagArray:temp];
//    _cellHeight = _bubbleView.frame.size.height;/
    
    [_tagBgVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(weakSelf.bubbleView.frame.size.height+30+14);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(Space);
    }];
    
    [_catLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(14);
        make.left.mas_equalTo(self.tagBgVeiw.mas_left).offset(Space);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(Space*2);
    }];
    
    [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(kHeight*0.12+10);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.tagBgVeiw.mas_bottom).offset(1);
    }];
    
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(kHeight*0.12);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.tagBgVeiw.mas_bottom).offset(1);
    }];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSInteger contentSizeH = CGRectGetMaxY(self.contentBgView.frame);
    
    _margin = 10;
    _itemWH = (kWidth - 3*_margin) / 4 ;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
//    _layout.sectionInset = UIEdgeInsetsMake(0, 5, 0,5);
    
    [self.collectionView setCollectionViewLayout:_layout];
    self.collectionView.contentSize = CGSizeMake(kWidth, kHeight-contentSizeH);
    self.collectionView.scrollEnabled = YES;
    self.collectionView.frame = CGRectMake(0, contentSizeH, self.view.tz_width, kHeight-contentSizeH);
    
//    self.collectionView.frame = CGRectMake(0, contentSizeH, self.view.tz_width, self.view.tz_height-contentSizeH-49);
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    BOOL isHidden = NO;
    if (_selectedAssets.count) {
        id  asset = _selectedAssets[0];
        //    若果是视频
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isHidden = phAsset.mediaType == PHAssetMediaTypeVideo;
            
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isHidden =  [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        
    }
    
    if (isHidden || _selectedPhotos.count == 9) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIPhoto];
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return _selectedPhotos.count;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIPhoto];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    
    if (_selectedPhotos.count == 0) {
        cell.imageView.image = [UIImage imageNamed:@"添加"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
        return cell;
    }
    
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"添加"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        PublishFooterCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"PublishFooterCollectionReusableView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        reusableView = footerview;
        footerview.delegate = self;
        self.footView = footerview;
        
        if (self.rangeName.length) {
            footerview.rangeLab.text = _rangeName;
            self.footView.viewsBtn.selected = YES;
        }
        
        if (self.shopName.length) {
            footerview.shopName.text = _shopName;
            self.footView.addressBtn.selected = YES;
        }
        
        [self addToolTab];
    }
    return reusableView;
}

-(CGSize)collectionView: (UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection: (NSInteger)section{
    
    CGSize size= {kWidth,1000};
    
    return size;
    
}

-(CGSize)collectionView: (UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection: (NSInteger)section{
    
    CGSize size={0,0};
    
    return size;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
//       [self pushTZImagePickerController];
        [self chooseSelectedAction];
        
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
         if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = MAXPICCOUNT;
            imagePickerVc.allowPickingGif = NO;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.allowPickingMultipleVideo = NO;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
                [self->_collectionView reloadData];
                self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

- (void)chooseSelectedAction{
    
    UIView *bg = [[UIView alloc]initWithFrame:self.view.bounds];
    bg.tag = 10000;
    bg.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.5];
    [self.view addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [bg addGestureRecognizer:tap];
    
    PopView *view = [PopView popView];
    view.delegate = self;
    view.center = self.view.center;
    [bg addSubview:view];
    
}



- (void)didClickMenuIndex:(NSInteger)index{
    
    [[self.view viewWithTag:10000] removeFromSuperview];
    [self popOverViewDidClickMenuIndex:index];
    
}

- (void)popOverViewDidClickMenuIndex:(NSInteger)index
{

    if (index == 1) {
        
        [self pushTZImagePickerController];
        
    }else{
        [self pushCameraController];
        
    }
}

#pragma mark - 添加到显示
- (void)addSelectedImageIntoLocation:(NSData *)image{
    
        NSMutableArray *imageIds = [NSMutableArray array];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            UIImage *img = [UIImage imageWithData:image];
            
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:img];
            //记录本地标识，等待完成后取到相册中的图片对象
            
            [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success)
            {
                //成功后取相册中的图片对象
                __block PHAsset *imageAsset = nil;
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    imageAsset = obj;
                    *stop = YES;
                    
                    [self->_selectedAssets addObject:imageAsset];
                    UIImage *img = [UIImage imageWithData:image];
                    img =  [img fixOrientation:img];
                    [self->_selectedPhotos addObject:img];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //Update UI in UI thread here
                        
                        [self.collectionView reloadData];
                        
                    });
                    
                }];
                
            }
            
        }];
    
}

- (void)addSelectedVideoIntoLocation:(NSURL *)url{
    
    if (_assetLater) {
        
        [self->_selectedAssets addObject:_assetLater];
        UIImage *img = [self getScreenShotImageFromVideoPath:self->_selectedVideo];
        [self->_selectedPhotos addObject:img];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
            
        });
        
        
        
    }else{
        
        
        ALAssetsLibrary *libraryT = _lib;
        [libraryT assetForURL:url resultBlock:^(ALAsset *asset) {
            
            if (asset) {
                         
                         [self->_selectedAssets addObject:asset];
                         UIImage *img = [self getScreenShotImageFromVideoPath:self->_selectedVideo];
                         [self->_selectedPhotos addObject:img];
                         [self.collectionView reloadData];
                         
            }else{
                         
                         [self.collectionView reloadData];
                     }
                     
            } failureBlock:^(NSError *error) {
                
            }];
            
        
        

        
    }
    
   
    
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    [tap.view removeFromSuperview];
    
    
}

#pragma mark -跳相机
- (void)pushCameraController {
   
    CameraViewController *imgVC= [[CameraViewController alloc]init];
    imgVC.recordComplete = ^(NSString *aVideoUrl, NSString *aThumUrl) {
        
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
                        
                        self.selectedVideo = aVideoUrl;
                        self.assetLater = obj;
                        [self addSelectedVideoIntoLocation:[NSURL urlWithNoBlankDataString:aVideoUrl]];
                        
                    }];
                    
                    
                } if (error) {
                    
                    NSLog(@"%@",error);
                    
                }
                
            }];
            
            
            
        }else{
            
            //录制完的视频保存到相册
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            
            NSURL *url = [NSURL fileURLWithPath:aVideoUrl];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:url]) {
                [library writeVideoAtPathToSavedPhotosAlbum:url
                                            completionBlock:^(NSURL *assetURL, NSError *error){
                                                
                                                [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                                    
                                                    self.selectedAsset = assetURL;
                                                    self.selectedVideo = aVideoUrl;
                                                    self.lib = library;
                                                    [self addSelectedVideoIntoLocation:assetURL];
                                                    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                    
                                                } failureBlock:^(NSError *error) {
                                                    
                                                }];
                                                
                                            }];
            };
            
        }
        
        
    };
    
    //        拍照之后保存到相册
    imgVC.photoComplete = ^(NSData *aPhotoUrl) {
        
        [self addSelectedImageIntoLocation:aPhotoUrl];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
    };
    
    [self presentViewController:imgVC animated:YES completion:nil];

    
}

#pragma mark -跳相册
- (void)pushTZImagePickerController {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:WEIPhoto]) {
        return;
    }
    CustomImagePickerViewController *imagePickerVc = [[CustomImagePickerViewController alloc] initWithMaxImagesCount:MAXPICCOUNT columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    if (MAXPICCOUNT > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark- 图片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_collectionView reloadData];
    
    
}

#pragma mark- 视频回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    
    
//    判断时长
    NSTimeInterval time = 0.f ;
    __block NSURL *url;
    
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
                        self->_lib = library;
                        NSString *url = [NSString stringWithFormat:@"%@",aPhotoUrl];
                        url = [url stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                        
                        if ([self->_lib videoAtPathIsCompatibleWithSavedPhotosAlbum:aPhotoUrl]) {
                            [self->_lib writeVideoAtPathToSavedPhotosAlbum:aPhotoUrl
                                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                                            
//                                                            [self->_lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                                                            
                                                                PHFetchResult *ass = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
                                                                dispatch_async( dispatch_get_main_queue(), ^{
                                                                    
                                                                    self->_selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
                                                                    self->_selectedAssets = [NSMutableArray arrayWithArray:@[ass]];
                                                                    [self->_collectionView reloadData];
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
            
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            time = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
            
            ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
            NSString *uti = [defaultRepresentation UTI];
            url = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
            
            VideoCutViewController *pubVC = [[VideoCutViewController alloc]initClipVideoVCWithAssetURL:url];
            
            pubVC.videoClipComplete = ^(NSURL *aPhotoUrl) {
                
                
                
            };
            
            [self.navigationController pushViewController:pubVC animated:YES];
        }
        
        
    }else{
        _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
        _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    }
    
    // open this code to send video / 打开这段代码发送视频
    
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIPhoto];
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_collectionView reloadData];
   
}

#pragma mark- 删除照片
- (void)deleteBtnClik:(UIButton *)sender {
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    if (_selectedPhotos.count == 0 && _selectedAssets.count == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIVIDEO];
        [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIPhoto];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [_collectionView reloadData];
    

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
                
                NSLog(@"success%f,%f",location.coordinate.latitude, location.coordinate.longitude);
                
            }
            
        }
    };
}


- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 发布
- (IBAction)publishAction:(UIButton *)sender {
    //    判断
    
    if (tagIDs.length == 0 ) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请选择作品类别！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
        return;
    }
    
    if (!_selectedAssets.count || !_selectedPhotos.count) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"至少要选择一张照片或者视频哦" iconImage:[UIImage imageNamed:@"error"]];
        toast.toastType = FFToastTypeError;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
        return;
    }
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    [self sendMessage];
}

#pragma mark-相册

- (IBAction)photoAction:(UIButton *)sender {
    
//    判断是不是可以选相册
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:WEIPhoto] boolValue]) {
        [self pushTZImagePickerController];
    }
    
}
#pragma mark-拍照
- (IBAction)cameraAction:(UIButton *)sender {
    
    //    判断是不是可以录像
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:WEIPhoto] boolValue]) {
        [self pushCameraController];
    }
    
    
}
#pragma mark-关联活动

- (IBAction)activityAction:(UIButton *)sender {
}

#pragma mark- 商家名称
- (void)chooseShopAction:(UIButton *)sender{
    
    AllShopViewController *shopVC = [[AllShopViewController alloc]init];
    shopVC.selectComplete = ^(NSString *aShopID, NSString *aShopName) {
        
        self->_shopID = aShopID;
        self->_shopName = aShopName;
        
        [self.collectionView reloadData];
        
    };
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark- 选择可见范围
- (void)chooseRangeAction:(UIButton *)sender{
    
    AllRangeViewController *shopVC = [[AllRangeViewController alloc]init];
    shopVC.selectComplete = ^(NSString *aRangeID, NSString *aRangeName) {
        self->_rangeID = aRangeID;
        self->_rangeName = aRangeName;
        [self.collectionView reloadData];
    };
    
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

#pragma mark- 分享
- (void)chooseShareAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    SSDKPlatformType type = 0;
    
    switch (sender.tag) {
        case 1:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 3:
            type = SSDKPlatformSubTypeQZone;
            break;
        case 2:
            type = SSDKPlatformTypeSinaWeibo;
            break;
        default:
            break;
    }
    
    if (sender.selected) {
        
        [shareAry addObject:@(type)];
    }else{
        
        [shareAry removeObject:@(type)];
        
    }
    
}

- (void)shareAction:(NSDictionary *)data{
    
    if (shareAry.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    SSDKPlatformType type = [self->shareAry[0] integerValue];
    
//    [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:data[@"share_url"]] img:data[@"sharePic"] titleText:data[@"shareTitle"] text:data[@"shareContent"] andShareType:SSDKContentTypeAuto copyUrl:data[@"share_url"]];
    
//    [self->shareAry removeObjectAtIndex:0];
//    [self shareAction:data];
    
    
    NSString *text = data[@"shareContent"];
    if (!text.length) {
        text = @"来自微美惠的分享";
    }

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:data[@"sharePic"] //传入要分享的图片
                                        url:[NSURL urlWithNoBlankDataString:data[@"share_url"]]
                                      title:data[@"shareTitle"]
                                       type:SSDKContentTypeAuto];

    //    [shareParams ssdksetupshar];

    //进行分享
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];

         if (state == SSDKResponseStateCancel) {
             [self->shareAry removeObjectAtIndex:0];
             [self shareAction:data];
         }

         if (state == SSDKResponseStateSuccess) {

             [self->shareAry removeObjectAtIndex:0];
             [self shareAction:data];


         }


     }];
    
}


#pragma mark- 发布
-(void)sendMessage{
    

    
    BOOL isHidden = NO;
    if (_selectedAssets.count) {
        id  asset = _selectedAssets[0];
        //    若果是视频
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isHidden = phAsset.mediaType == PHAssetMediaTypeVideo;
            
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isHidden =  [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        
    }
    
    if (isHidden) {
        [self compressVideo];
    }else{
        [self uploadPics];
    }
    
    
    
}

#pragma mark - 压缩并上传视频
- (void)compressVideo {
    
    id asset = _selectedAssets[0];
    UIImage *img = _selectedPhotos[0];
    
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
        
        
        BAFileDataEntity *videoEntity = [BAFileDataEntity new];
        videoEntity.filePath = [NSString stringWithFormat:@"file://%@",outputPath];;
        videoEntity.urlString = SENDGroup;
        
        
        NSString *city_id = @"";
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
            city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
        }else{
            city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
        }
        
        
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
        NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
        
        NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        
        NSString *url = [PublicMethods dataTojsonString:@{@"group_type":@"3",@"price":self.footView.priceTF.text,@"content":self.contentTextView.text,@"activity_id":@"",@"view_authority":self->_rangeID,@"shop_id":self->_shopID,@"uuid":uuid,@"city_id":city_id,@"lat":lat,@"lng":lng,@"tag_id":self->tagIDs}];
        
        videoEntity.parameters = @{@"json":url};
//        [BANetManager ba_uploadVideoWithEntity:videoEntity successBlock:^(id response) {
//            [hud dismiss];
//            NSLog(@"上传完成");
//
//            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIVIDEO];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"上传成功" iconImage:[UIImage imageNamed:@"success"]];
//            toast.toastType = FFToastTypeSuccess;
//            toast.toastPosition = FFToastPositionCentreWithFillet;
//            [toast show];
//            [self.navigationController popViewControllerAnimated:YES];
//
//
////            判断是否需要跳转分享界面
//
//        } failureBlock:^(NSError *error) {
//
//            NSLog(@"上传失败%@",error);
//            [hud dismiss];
//            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"上传失败" iconImage:[UIImage imageNamed:@"error"]];
//            toast.toastType = FFToastTypeError;
//            toast.toastPosition = FFToastPositionCentreWithFillet;
//            [toast show];
//
//        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//
//        }];
        
        
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//        [manager.requestSerializer setValue:token forHTTPHeaderField:@"utf-8"];
        
        
        
        [manager POST:SENDGroup parameters:@{@"json":url} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 获取图片视频名称
            NSDate *date = [NSDate new];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyyMMddHHmmss"];
            NSString *time = [df stringFromDate:date];
            NSString *imagesName = [NSString stringWithFormat:@"%@.jpg", time];
            NSString *videoName = [NSString stringWithFormat:@"%@.mp4", time];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",outputPath]];
            
            [formData appendPartWithFileData:[NSData dataWithContentsOfURL:url] name:@"video" fileName:videoName mimeType:@"video/mp4"];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.8) name:@"pic" fileName:imagesName mimeType:@"image/jpeg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress:%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic =  [solveJsonData changeType:responseObject];
            
            BOOL dataS = [dic[@"success"] boolValue];
            NSDictionary *data = dic[@"data"];
            [self->hud dismiss];
            NSLog(@"上传完成");
            
            if (dataS) {
                
                [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:WEIVIDEO];
                [[NSUserDefaults standardUserDefaults] synchronize];
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"上传成功" iconImage:[UIImage imageNamed:@"success"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionCentreWithFillet;
                [toast show];
                
                //            通知刷新首页
                
                
                if (self->shareAry.count) {
                    
                    for (int i=0; i<self->shareAry.count; i++) {
                        
                        SSDKPlatformType type = [self->shareAry[i] integerValue];
                        
                        [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:data[@"share_url"]] img:data[@"share_pic"] titleText:data[@"shareTitle"] text:data[@"shareContent"] andShareType:SSDKContentTypeAuto copyUrl:data[@"share_url"]];
                        
                    }
                    
                }
                
                
            }else{
                
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"msg"] iconImage:[UIImage imageNamed:@"error"]];
                toast.toastType = FFToastTypeError;
                toast.toastPosition = FFToastPositionCentreWithFillet;
                [toast show];
                
            }
            
        
            if (self->shareAry.count) {
                
                [self shareAction:data];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"task:%@", task);
            NSLog(@"error:%@", error);
            
            [self->hud dismiss];
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"上传失败" iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
        }];
        
        
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    
    
    
}

#pragma mark - 压缩并上传图片
#pragma mark- 上传图片
- (void)uploadPics{
    
   
    //链接网络
    NSMutableArray *imgAry = [NSMutableArray array];
    for (int i=0; i<_selectedPhotos.count; i++) {
        YYNetModel *model = [[YYNetModel alloc]init];
        model.fileData = [self imageToData:_selectedPhotos[i]];
        model.fileName = [NSString stringWithFormat:@"%i.png",arc4random()%10];
        model.name = [NSString stringWithFormat:@"image%i",i+1];
        model.mimeType = @"image/png";
        [imgAry addObject:model];
    }
    
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"group_type":@"2",@"price":self.footView.priceTF.text,@"content":self.contentTextView.text,@"activity_id":@"",@"view_authority":_rangeID,@"shop_id":_shopID,@"uuid":uuid,@"city_id":city_id,@"lat":lat,@"lng":lng,@"tag_id":tagIDs}];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:SENDGroup parameters:@{@"json":url} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (YYNetModel *model in imgAry) {
            [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *data = dic[@"data"];
        [self->hud dismiss];
        NSLog(@"上传图片成功返回：%@",dic);
        if ([dic[@"status"] integerValue] == 1) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"上传成功" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
        
//            通知刷新
            
            
            //            判断是否需要跳转分享界面
            if (self->shareAry.count) {
                
                [self shareAction:data];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"msg"] iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
        }
        
       
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self->hud dismiss];
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"网络连接超时" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
        
    }];
    
}

/**
 *  获取视频的缩略图方法
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}
    
#pragma mark- 压缩图像，裁剪图像
 -(NSData *)imageToData:(UIImage *)myimage
    {
        NSData *data = UIImageJPEGRepresentation(myimage, 1);
        
        if (data.length>100*1024) {
            if (data.length>1024*1024) {//3M以及以上
                data=UIImageJPEGRepresentation(myimage, 0.1);
            }else if (data.length>512*1024) {//1.5M-3M
                data=UIImageJPEGRepresentation(myimage, 0.5);
            }else if (data.length>200*1024) {//0.25M-1.5M
                data=UIImageJPEGRepresentation(myimage, 0.9);
            }
        }
        
//        data = UIImageJPEGRepresentation(myimage, 0.01);
        NSLog(@"图片压缩%lu",data.length/1024);
        
        return data;
    }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
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
    [self.footView.priceTF setInputAccessoryView:topView];
    [self.contentTextView setInputAccessoryView:topView];
    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:20];
    MJWeakSelf
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.footView.priceTF, nil];
    }];
    
}

- (void)doneWithIt{
    [self.view endEditing:YES];
    
    if (self.footView.priceTF.text.length) {
        self.footView.priceBtn.selected = YES;
    }
    
}
@end

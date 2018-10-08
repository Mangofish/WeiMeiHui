//
//  FeedbackViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UITextView+Placeholder.h"
#import "TZCollectionViewFlowLayout.h"
#import "TZTestCell.h"
#import "CustomImagePickerViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+Layout.h"
#import "ZYKeyboardUtil.h"

@interface FeedbackViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>{
    
    YYHud *hud;
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *sectionOne;
@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UIView *sectionTwo;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *inforLab;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) TZCollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *inforLabT;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UIView *line1;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray   array];
    [self configNavView];
    
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
    
    [_sectionOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(234);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(Space);
    }];
    
    [_inforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.sectionOne.mas_left).offset(Space);
        make.top.mas_equalTo(self.sectionOne.mas_top).offset(15);
    }];
    
    _contentTF.placeholder = @"任何意见或建议，请留在这里，感谢您对微美惠的支持。";
    [_contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(180);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.top.mas_equalTo(self.inforLab.mas_bottom).offset(15);
    }];
    
    [self addToolTab];
    
    
    
//    [self configCollectionView];
    
    [_sectionTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(264);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.sectionOne.mas_bottom).offset(Space);
    }];
    
    [_inforLabT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(10);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.sectionTwo.mas_top).offset(Space*2);
    }];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.inforLabT.mas_bottom).offset(Space*2);
    }];
    
    [_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.btn1.mas_right).offset(Space);
        make.top.mas_equalTo(self.inforLabT.mas_bottom).offset(Space*2);
    }];
    
    [_telLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-40*2);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.btn1.mas_right).offset(Space);
        make.top.mas_equalTo(self.lab1.mas_bottom).offset(Space);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-40*2);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.telLab.mas_bottom).offset(0);
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(Space*2);
    }];
    
    [_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.btn1.mas_right).offset(Space);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(Space*2);
    }];
    
    [_telTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-40*2);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.btn1.mas_right).offset(Space);
        make.top.mas_equalTo(self.lab2.mas_bottom).offset(Space);
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-40*2);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.telTF.mas_bottom).offset(0);
    }];
    
    
    [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(kWidth-Space*2);
       make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(Space*2);
    }];
    
    [_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.btn1.mas_right).offset(Space);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(Space*2);
    }];
   
    NSMutableString *str = [NSMutableString stringWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"phone"]];
    
    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _telLab.text = str;
    
    [ZZLimitInputManager limitInputView:self.contentTF maxLength:240];
     [ZZLimitInputManager limitInputView:self.telTF maxLength:11];
    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:5];
    MJWeakSelf
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.telTF, nil];
    }];
}

#pragma mark- 图片展示
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[TZCollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Space, 125, kWidth-Space*2, 100) collectionViewLayout:_layout];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(5, 5,5, 5);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.sectionOne addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_selectedPhotos.count == 4) {
        return 4;
    }
    
    return _selectedPhotos.count+1;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
        cell.imageView.image = _selectedPhotos[indexPath.item];
        cell.asset = _selectedAssets[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

#pragma mark- 删除照片
- (void)deleteBtnClik:(UIButton *)sender {
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView reloadData];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _margin = 10;
    _itemWH = (kWidth - 3*_margin) / 4 ;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        //       [self pushTZImagePickerController];
        [self pushTZImagePickerController];
        
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
            
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 4;
            imagePickerVc.allowPickingGif = NO;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.allowPickingMultipleVideo = NO;
            imagePickerVc.isSelectOriginalPhoto = NO;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                
                [self->_collectionView reloadData];
                self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark -跳相册
- (void)pushTZImagePickerController {
    
    CustomImagePickerViewController *imagePickerVc = [[CustomImagePickerViewController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowPickingVideo = NO;
    
        // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark- 图片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];

    [_collectionView reloadData];
    
    _inforLab.text = [NSString stringWithFormat:@"添加照片说明：（%li/4）",photos.count];
    
}

- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(UIButton *)sender {
    
    if (!_contentTF.text.length) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请输入要反馈的内容！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        return;
        
        return;
    }
    
   
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *phone = @"";
    if (self.btn1.selected) {
        phone = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"phone"];;
    }
    
    if (self.btn2.selected) {
        
        if (self.telTF.text.length < 11) {
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请输入正确的新号码！" iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            return;
        }
        
        phone = self.telTF.text;
    }
    
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"phone":phone,@"content":_contentTF.text}];
    
    if (_selectedPhotos.count) {
        
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
        
        AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        [manager POST:MineFeedback parameters:@{@"json":url} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (YYNetModel *model in imgAry) {
                [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
            }
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSDictionary *data = dic[@"data"];
            [self->hud dismiss];
            NSLog(@"上传图片成功返回：%@",dic);
            if ([dic[@"status"] integerValue] == 1) {
                
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"反馈成功" iconImage:[UIImage imageNamed:@"success"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionCentreWithFillet;
                [toast show];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self->hud dismiss];
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"网络连接超时" iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            return;
            
        }];
        
    }else{
        
        [YYNet POST:MineFeedback paramters:@{@"json":url} success:^(id responseObject) {
            
            [self->hud dismiss];
            NSDictionary *dic = [solveJsonData changeType:responseObject];
            if ([dic[@"status"] integerValue] == 1) {
                
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"反馈成功" iconImage:[UIImage imageNamed:@"success"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionCentreWithFillet;
                [toast show];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"反馈失败，请重试" iconImage:[UIImage imageNamed:@"success"]];
                toast.toastType = FFToastTypeSuccess;
                toast.toastPosition = FFToastPositionCentreWithFillet;
                [toast show];
                
                
            }
            
        } faild:^(id responseObject) {
            [self->hud dismiss];
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"反馈失败" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
        }];
        
    }
    
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
    [self.contentTF setInputAccessoryView:topView];
    [self.telTF setInputAccessoryView:topView];
}

- (void)doneWithIt{
    [self.view endEditing:YES];
}

- (IBAction)selectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    _btn3.selected = NO;
    _btn1.selected = NO;
}

- (IBAction)notNotify:(UIButton *)sender {
    sender.selected = !sender.selected;
    _btn1.selected = NO;
    _btn2.selected = NO;
}

- (IBAction)defaultNotify:(UIButton *)sender {
    sender.selected = !sender.selected;
    _btn3.selected = NO;
    _btn2.selected = NO;
}

@end

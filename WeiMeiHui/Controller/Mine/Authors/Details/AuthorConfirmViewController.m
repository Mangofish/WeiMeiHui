//
//  AuthorConfirmViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorConfirmViewController.h"
#import "PersonalTableViewCell.h"
#import "AuthorPriceRangeTableViewCell.h"
#import "ZYKeyboardUtil.h"
#import "AuthorWaitTableViewCell.h"
#import "CustomImagePickerViewController.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AuthorConfirmViewController ()<UITableViewDelegate, UITableViewDataSource,PersonalTableViewCellDelegate,TZImagePickerControllerDelegate>
{
    NSArray *_dataAry;
    CGFloat _cellHeight;
    NSMutableArray *selectedImgAry;
    NSMutableArray *selectedAsset;
    YYHud *hud;
}
@property (strong, nonatomic)  UITextView *cellNoteTF;
@property (strong, nonatomic)  UITextField *cellPriceTF;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@end

@implementation AuthorConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedAsset = [NSMutableArray array];
    selectedImgAry = [NSMutableArray array];
    
    self.tabBarController.tabBar.hidden = YES;
    
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
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space-44);

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

- (IBAction)sendAction:(UIButton *)sender {
    
    if (!_cellPriceTF.text.length) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请认真填写报价！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    hud = [[YYHud alloc]init];
    if (selectedImgAry.count) {
        [self uploadPics];
    }else{
        [self getData];
    }
    
    
    
}

#pragma mark - 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        return 2;
    }
    
    return 1;
    
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
        return _cellHeight;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
            return 155;
            
        }else{
            return 100;
        }
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
     
        AuthorWaitTableViewCell *cell = [AuthorWaitTableViewCell authorWaitTableViewCellWait];
        
        if (_dataDic) {
              cell.orderDetail = [AuthorOrdersModel orderInfoWithDict:_dataDic];
        }
        
        _cellHeight = cell.cellHeight;
        return cell;
        
    }else if (indexPath.section == 1){
        
        AuthorPriceRangeTableViewCell *cell =[AuthorPriceRangeTableViewCell authorPriceRangeTableViewCell];
        self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:5];
        __weak AuthorConfirmViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
        [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
            [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:cell.priceTF, nil];
        }];
        
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
        [cell.priceTF setInputAccessoryView:topView];
        _cellPriceTF = cell.priceTF;
        [ZZLimitInputManager limitInputView:_cellPriceTF maxLength:9];
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            
            PersonalTableViewCell *cell = [PersonalTableViewCell personalTableViewCellThreeWithString:@"上传您给客户的参考照片（0/4）"];
            cell.type = 1;
            cell.delegate = self;
            cell.selectedAry = selectedImgAry;
            cell.stateStr = @"上传您给客户的参考照片";
            return cell;
            
        }else{
            
            PersonalTableViewCell *cell = [PersonalTableViewCell personalTableViewCellFour];
            _cellNoteTF = cell.noteTF;
            self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:5];
            __weak AuthorConfirmViewController *weakSelf = self;

#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
            [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
                [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:cell.noteTF, nil];
            }];
            [ZZLimitInputManager limitInputView:cell.noteTF maxLength:120];
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
            [cell.noteTF setInputAccessoryView:topView];
            
            return cell;
            
        }
        
    }
    
    
}

- (void)doneWithIt{
    
    [self.view endEditing:YES];
    
}

- (void)chooseDelPic:(NSUInteger)index{
    
    [selectedAsset removeObjectAtIndex:index];
    [selectedImgAry removeObjectAtIndex:index];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
    
    [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
    
}

#pragma mark- 上传图片
- (void)uploadPics{
    
    [hud showInView:self.view];
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
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *ID = _dataDic[@"id"];
    
    if (!ID) {
        ID = _dataDic[@"send_id"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":ID,@"uuid":uuid,@"custom_id":_dataDic[@"custom_id"],@"content":_cellNoteTF.text,@"price":_cellPriceTF.text}];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:AuthorConfirmOrder parameters:@{@"json":url} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (YYNetModel *model in imgAry) {
            [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self->hud dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"上传图片成功返回：%@",dic);
        if ([dic[@"status"] integerValue] == 1) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"接单成功，请等待用户确认" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
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
    
}

- (void)getData{
    
    //网络请求
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *ID = _dataDic[@"id"];
    if (!ID) {
        ID = _dataDic[@"send_id"];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"id":ID,@"uuid":uuid,@"custom_id":_dataDic[@"custom_id"],@"content":_cellNoteTF.text,@"price":_cellPriceTF.text}];
    
    [hud showInView:self.view];
    
    [YYNet POST:AuthorConfirmOrder paramters:@{@"json":url} success:^(id responseObject) {
        
        [self->hud dismiss];
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已接单" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"接单失败" iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            return;
        }
        
    } faild:^(id responseObject) {
        
        [self->hud dismiss];
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"接单失败" iconImage:[UIImage imageNamed:@"error"]];
        toast.toastType = FFToastTypeError;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
 
        
    }];
    
}



- (void)chooseAddPic {
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
        //        imagePickerVc.allowPickingGif = NO;
        //        imagePickerVc.allowPickingOriginalPhoto = NO;
        //        imagePickerVc.allowPickingMultipleVideo = NO;
        //        imagePickerVc.isSelectOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            selectedImgAry = [NSMutableArray arrayWithArray:photos];
            selectedAsset = [NSMutableArray arrayWithArray:assets];
            [self.mainTableView reloadData];
            //            [self->_collectionView reloadData];
            //            self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}

@end

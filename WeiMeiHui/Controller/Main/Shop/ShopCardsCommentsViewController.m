//
//  ShopCardsCommentsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopCardsCommentsViewController.h"

#import "OrderCommentTableViewCell.h"
#import "PersonalTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "CustomImagePickerViewController.h"
#import "ZYKeyboardUtil.h"

#import "FamousGoodsTableViewCell.h"
#import "ThreeStarsTableViewCell.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ChooseAuthorViewController.h"
#import "MyCardsListsViewController.h"

@interface ShopCardsCommentsViewController ()<UITableViewDelegate, UITableViewDataSource,PersonalTableViewCellDelegate,TZImagePickerControllerDelegate,OrderCommentTableViewCellDelegate,ThreeStarsDelegate>

{
    YYHud *hud;
    CGFloat qualityS;
    CGFloat technicalS;
    CGFloat environmentS;
    
    NSString *finaltagID;
    CGFloat cellHeight;
}

@property (strong, nonatomic)  UITextView *contentTF;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (copy, nonatomic)  NSDictionary *orderDataDic;
@property (strong, nonatomic)  NSMutableArray *selectedImgAry;
@property (strong, nonatomic)  NSMutableArray *selectedAsset;



@end

@implementation ShopCardsCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    finalscore = 5;
    finaltagID = @"";
    [self configNavView];
    [self getData];
}

- (void)configNavView {
    
    _selectedImgAry = [NSMutableArray array];
    _selectedAsset = [NSMutableArray array];
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1-44);
    
    //    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [self getData];
    //    }];
    
    //    [_mainTableView.mj_header beginRefreshing];
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (self.orderDataDic) {
        return 5;
    }
    
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrderComment];
        
        cell.orderComment = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
        
        
        return cell;
        
    }
    
    if (indexPath.section == 1) {
        
        if (!self.authorDic.count) {
            
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            cell.textLabel.text = @"请选择为您服务的手艺人";
            cell.textLabel.textColor = FontColor;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }else{
            
            ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            
            cell.authorChoose = [ShopAuthor shopAuthorWithDict:self.authorDic];
           
            return cell;
            
        }
        
        
    }
    
    if (indexPath.section == 2) {
        ThreeStarsTableViewCell *cell = [ThreeStarsTableViewCell threeStarView];
        cell.delegate = self;
        return cell;
        
    }
    
    
    if (indexPath.section == 3) {
        
        OrderCommentTableViewCell *cell = [OrderCommentTableViewCell orderCommentTableViewCell];
        cell.finalTag  = self.orderDataDic[@"service_tag"];
        cellHeight = cell.cellHeight;
        cell.delegate = self;
        self.contentTF = cell.contentTF ;
        [self addToolTab];
        
        self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:5];
        MJWeakSelf
        [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
            [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.contentTF, nil];
        }];
        [ZZLimitInputManager limitInputView:self.contentTF maxLength:120];
        return cell;
        
    }else{
        
        PersonalTableViewCell *cell = [PersonalTableViewCell personalTableViewCellThreeWithString:@"上传图片有机会获得额外抽奖机会(0/4)"];
        cell.stateStr = @"上传图片有机会获得额外抽奖机会(0/4)";
        cell.delegate = self;
        cell.selectedAry = _selectedImgAry;
        cell.selectedAsset = _selectedAsset;
        
        return cell;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            return 88;
        }
        
    }
    
    if (indexPath.section == 2) {
        
        return 100;
        
    }
    
    if (indexPath.section == 3) {
        
        return cellHeight;
        
    }
    
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    
    return 155;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}


- (void)getData{
    
    //网络请求
        NSString *uuid = @"";
        if ([PublicMethods isLogIn]) {
            uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        }
    
   
    NSString *url = [PublicMethods dataTojsonString:@{@"log_id":_ID,@"uuid":uuid}];
    
    [YYNet POST:MyCardsCom paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.orderDataDic = dic[@"data"];
        
        if ([self.orderDataDic[@"type"] integerValue] == 2) {
              self.authorDic = self.orderDataDic[@"author_single"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTableView reloadData];
        });
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (void)chooseAddPic {
    [self pushTZImagePickerController];
}

- (void)chooseLookPic:(NSUInteger)index{
    
    id asset = _selectedAsset[index];
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
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAsset selectedPhotos:_selectedImgAry index:index];
        imagePickerVc.maxImagesCount = 4;
        //        imagePickerVc.allowPickingGif = NO;
        //        imagePickerVc.allowPickingOriginalPhoto = NO;
        //        imagePickerVc.allowPickingMultipleVideo = NO;
        //        imagePickerVc.isSelectOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.selectedImgAry = [NSMutableArray arrayWithArray:photos];
            self.selectedAsset = [NSMutableArray arrayWithArray:assets];
            [self.mainTableView reloadData];
            //            [self->_collectionView reloadData];
            //            self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark- 跳转相册
- (void)pushTZImagePickerController {
    
    CustomImagePickerViewController *imagePickerVc = [[CustomImagePickerViewController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = self.selectedAsset;
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark- 图片选择回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    [self.selectedAsset setArray:assets];
    [self.selectedImgAry setArray: photos];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:4];
    
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


- (void)didClickTagID:(NSString *)tagID{
    
    finaltagID = tagID;
}

- (void)didClickScore:(CGFloat)score{
    
    
    
}
#pragma mark- 提交评价
- (IBAction)sendComment:(UIButton *)sender {
    
    if (self.selectedImgAry.count) {
        [self uploadPics];
        return;
    }
    
    if (!finaltagID.length) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请至少选择一个评价标签！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    if (!self.authorDic.count) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"请选择一个手艺人进行评价！" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;
    }
    
    NSString *uuid =@"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *author_uuid= self.authorDic[@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"author_uuid":author_uuid,@"uuid":uuid,@"log_id":_ID,@"tag_id":finaltagID,@"content":_contentTF.text,@"technical":@(technicalS),@"environment":@(environmentS),@"quality":@(qualityS)}];
    
//    NSString *path = SendGroupComments;
//    if ([self.type integerValue] == 4) {
//        path = WeiOrderEvaluate;
//    }
    
    
    [YYNet POST:CardsEvaluate paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        if ([dict[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"评价成功！" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [self popAction:nil];
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"评价失败！" iconImage:[UIImage imageNamed:@"error"]];
            toast.toastType = FFToastTypeError;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            
        }
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}


#pragma mark- 上传图片
- (void)uploadPics{
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    //链接网络
    NSMutableArray *imgAry = [NSMutableArray array];
    for (int i=0; i<self.selectedImgAry.count; i++) {
        YYNetModel *model = [[YYNetModel alloc]init];
        model.fileData = [self imageToData:self.selectedImgAry[i]];
        model.fileName = [NSString stringWithFormat:@"%i.png",arc4random()%10];
        model.name = [NSString stringWithFormat:@"image%i",i+1];
        model.mimeType = @"image/png";
        [imgAry addObject:model];
    }
    
    NSString *uuid =@"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *author_uuid= self.authorDic[@"uuid"];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"author_uuid":author_uuid,@"uuid":uuid,@"log_id":_ID,@"tag_id":finaltagID,@"content":_contentTF.text,@"technical":@(technicalS),@"environment":@(environmentS),@"quality":@(qualityS)}];
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
//    NSString *path = SendGroupComments;
//    if ([self.type integerValue] == 4) {
//        path = WeiOrderEvaluate;
//    }
    
    
    
    [manager POST:CardsEvaluate parameters:@{@"json":url} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (YYNetModel *model in imgAry) {
            [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [self->hud dismiss];
        NSLog(@"上传图片成功返回：%@",dic);
        if ([dic[@"status"] integerValue] == 1) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
           [self popAction:nil];
            
            
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

- (IBAction)serviceAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",self.orderDataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
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
    
}

- (void)doneWithIt{
    
    [self.view endEditing:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}


- (void)chooseDelPic:(NSUInteger)index{
    
    [self.selectedAsset removeObjectAtIndex:index];
    [self.selectedImgAry removeObjectAtIndex:index];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:4];
    
    [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
    
}

- (IBAction)popAction:(UIButton *)sender {
    
//    扫完直接
    if ([self.status integerValue] == 1) {
        
        for (UIViewController *obj in self.navigationController.viewControllers) {
            if ([obj isKindOfClass:[MyCardsListsViewController class]]) {
                [self.navigationController popToViewController:obj animated:YES];
            }
        }
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

#pragma mark- 星星✨

- (void)didClickStarView:(CGFloat)scoreOne andScore:(CGFloat)scoreTwo andScoreT:(CGFloat)scoreThree{
    
    technicalS = scoreOne;
    environmentS = scoreTwo;
    qualityS = scoreThree;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && [self.orderDataDic[@"type"] integerValue] == 1) {
        
        ChooseAuthorViewController *authorVc= [[ChooseAuthorViewController alloc]init];
        authorVc.dataAry = self.orderDataDic[@"author_data"];
        authorVc.selectComplete = ^(NSDictionary *obj) {
            self.authorDic = obj;
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
            
            [self.mainTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
            
        };
        [self.navigationController pushViewController:authorVc animated:YES];
        
    }
    
}


@end

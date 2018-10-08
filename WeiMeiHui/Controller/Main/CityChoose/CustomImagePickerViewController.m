//
//  CustomImagePickerViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CustomImagePickerViewController.h"

@interface CustomImagePickerViewController ()

@end

@implementation CustomImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    self.isSelectOriginalPhoto = YES;
    
    self.allowTakePicture = NO; // 在内部显示拍照按钮

    
    // 4. 照片排列按修改时间升序
    self.sortAscendingByModificationDate = YES;
    
    self.showSelectBtn = NO;
//    self.allowCrop = YES;
//    self.needCircleCrop = YES;
//    // 设置竖屏下的裁剪尺寸
//    NSInteger left = 30;
//    NSInteger widthHeight = kWidth - 2 * left;
//    NSInteger top = (kHeight - widthHeight) / 2;
//    self.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    self.statusBarStyle = UIStatusBarStyleLightContent;
    // 设置首选语言
    self.preferredLanguage = @"zh-Hans";
    
}


@end

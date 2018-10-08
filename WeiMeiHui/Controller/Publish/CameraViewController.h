//
//  CameraViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UMClickViewController

@property (nonatomic, assign) BOOL savePhotoAlbum;

@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, copy) NSString *outputVideoPath;//视频路径 不设置将使用默认路径
@property (nonatomic, copy) NSString *outputVideoThumPath;//视频缩略图
@property (nonatomic, copy) NSString *outputImagePath;//拍照图片路径

@property (nonatomic, copy) void(^recordComplete)(NSString * aVideoUrl,NSString *aThumUrl);
@property (nonatomic, copy) void(^photoComplete)(NSData * aPhotoUrl);



@end

//
//  PublishViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PublishViewController : UMClickViewController

@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, copy) NSString *selectedVideo;
@property (nonatomic, copy) NSURL *selectedAsset;
@property (nonatomic, copy) NSData *selectedImg;

@property (nonatomic, strong) id lib;
@property (nonatomic, strong) id assetLater;

@property (nonatomic, copy) NSString *shopID;
@property (nonatomic, copy) NSString *rangeID;
@property (nonatomic, copy) NSString *rangeName;
@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) void(^publishComplete)(NSString * aUrl);

@end

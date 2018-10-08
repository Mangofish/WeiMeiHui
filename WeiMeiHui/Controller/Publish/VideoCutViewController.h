//
//  VideoCutViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCutViewController : UMClickViewController

- (instancetype)initClipVideoVCWithAssetURL:(NSURL *)assetUrl;

@property (nonatomic, copy) void(^videoClipComplete)(NSURL * aPhotoUrl);

@end

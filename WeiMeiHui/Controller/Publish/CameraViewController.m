//
//  CameraViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "LLMicroVideoConfig.h"
#import "LLPlayerView.h"
#import "LLPreview.h"
#import "LLCameraController.h"
#import "LLBottomView.h"
#import "NSURL+ImageUrl.h"
#import "LLPhotoView.h"
#import "TZImagePickerController.h"

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface CameraViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) LLPreview *preview;
@property (nonatomic, strong) LLBottomView *bottomView;
@property (nonatomic, strong) LLPlayerView *playerView;
@property (nonatomic, strong) LLPhotoView *photoView;

@property (nonatomic, strong) LLVideoModel *currentRecord;
@property (nonatomic, strong) LLCameraController *cameraController;
//@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, copy) NSData *imgData;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self setupVideo];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.bottomView showBtn];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)makeUI
{
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(230));
    }];
    
    WEAKSELF(weakSelf);
    self.bottomView.startRecord = ^(){
        [weakSelf startRecord];
    };
    
    self.bottomView.stopRecord = ^(CFTimeInterval recordTime){
        if (recordTime < 1.) {
            NSLog(@"录制时间太短");
            [weakSelf cleanPath];
            return ;
        }
        [weakSelf.cameraController stopRecordingComplete:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error.localizedDescription);
                return ;
            }
            
            [weakSelf addPlayerView];
        }];
    };
    
    self.bottomView.sendComplete = ^{
        
        if (weakSelf.recordComplete && weakSelf.currentRecord.videoAbsolutePath) {
        weakSelf.recordComplete(weakSelf.currentRecord.videoAbsolutePath,weakSelf.currentRecord.thumAbsolutePath);
            
        }else if(weakSelf.photoComplete){
            
            [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:WEIVIDEO];
            [[NSUserDefaults standardUserDefaults] synchronize];
            weakSelf.photoComplete(weakSelf.imgData);
            
        }
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    self.bottomView.switchComplete = ^{
        
        [weakSelf.cameraController switchSession];
        
    };
    
    self.bottomView.cancelComplete = ^{
        [weakSelf.playerView stop];
        [weakSelf.playerView removeFromSuperview];
        weakSelf.playerView = nil;
        [weakSelf startSession];
        [weakSelf cleanPath];
        
        [weakSelf.photoView removeFromSuperview];
        
    };
    
    self.bottomView.backComplete = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
//    拍照
    
    self.bottomView.photoComplete = ^{
        
        [weakSelf.cameraController startPhoto];
        
        weakSelf.cameraController.completePhoto = ^(NSData *data) {
            weakSelf.imgData = data;
             [weakSelf addPhotoView:data];
        };
        
        
    };
    
}

- (void)addPlayerView {
    NSURL *videoURL = [NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath];
    
    self.playerView = [[LLPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds videoUrl:videoURL];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.playerView play];
    [self stopSession];
    
    [self.view insertSubview:self.playerView aboveSubview:self.preview];
}

- (void)addPhotoView :(NSData *)videoUrl{
    
    self.photoView = [[LLPhotoView alloc] initWithFrame:self.view.bounds videoUrl:videoUrl];
     [self.view insertSubview:self.photoView aboveSubview:self.preview];
    
}

#pragma mark - 权限

- (void)setupVideo {
    NSString *unUseInfo = nil;
    
    NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
    NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
    
    if (TARGET_IPHONE_SIMULATOR) {
        unUseInfo = @"模拟器不可以的..";
    }
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied){
        unUseInfo = @"相机访问受限...";
        
        if (iOS8Later) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSBundle tz_localizedStringForKey:@"Can not use camera"] message:message delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"Cancel"] otherButtonTitles:[NSBundle tz_localizedStringForKey:@"Setting"], nil];
            alert.delegate = self;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSBundle tz_localizedStringForKey:@"Can not use camera"] message:message delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"OK"] otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
        }
        
    }
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusDenied){
        unUseInfo = @"录音访问受限...";
        
        if (iOS8Later) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用麦克风" message:message delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"Cancel"] otherButtonTitles:[NSBundle tz_localizedStringForKey:@"Setting"], nil];
            alert.delegate = self;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用麦克风" message:message delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"OK"] otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
        }
        
    }
    
    [self configureSession];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)configureSession
{
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        [self.preview setSession:self.cameraController.captureSession];
        [self startSession];
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}


- (void)cleanPath
{
    if(self.currentRecord.videoAbsolutePath.length > 0) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentRecord.videoAbsolutePath error:nil];
    }
    
    if (self.currentRecord.thumAbsolutePath.length > 0) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentRecord.thumAbsolutePath error:nil];
    }
}

//开始录制
- (void)startRecord
{
    
    self.currentRecord = [LLVideoUtil createNewVideo];
    NSURL *outURL = [NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath];
    NSLog(@"视频开始录制%@",outURL);
    self.cameraController.outputURL = outURL;
    [self.cameraController startRecording];
}

// 停止录制
- (void)stopRecord
{
    [self.cameraController stopRecording];
//    self.recordComplete(self.currentRecord.videoAbsolutePath, self.currentRecord.videoAbsolutePath);
}

- (void)startSession
{
    [self.cameraController startSession];
}

- (void)stopSession
{
    [self.cameraController stopSession];
}

//MARK: getter
- (NSString *)outputVideoPath
{
    if (_outputVideoPath.length > 0) {
        return _outputVideoPath;
    }
    
    //从默认配置中取
    return nil;
}

- (NSString *)outputVideoThumPath
{
    if (_outputVideoThumPath.length > 0) {
        return _outputVideoThumPath;
    }
    
    //从默认配置中取
    return nil;
}

- (NSString *)outputImagePath
{
    if (_outputImagePath.length > 0) {
        return _outputImagePath;
    }
    
    //从默认配置中取
    return nil;
}

//MARK: lazy
- (LLBottomView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[LLBottomView alloc] init];
        
        [self.view addSubview:_bottomView];
    }
    
    return _bottomView;
}

- (LLCameraController *)cameraController
{
    if(!_cameraController){
        _cameraController = [[LLCameraController alloc] init];
    }
    return _cameraController;
}

- (LLPreview *)preview
{
    if(!_preview){
        _preview = [[LLPreview alloc] init];
        [self.view addSubview:_preview];
    }
    return _preview;
}


//- (void)temp{
//
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) && iOS7Later) {
//        // 无权限 做一个友好的提示
//        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
//        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
//        NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
//        if (iOS8Later) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSBundle tz_localizedStringForKey:@"Can not use camera"] message:message delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"Cancel"] otherButtonTitles:[NSBundle tz_localizedStringForKey:@"Setting"], nil];
//            [alert show];
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSBundle tz_localizedStringForKey:@"Can not use camera"] message:message delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"OK"] otherButtonTitles:nil];
//            [alert show];
//        }
//    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
//        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
//        if (iOS7Later) {
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                if (granted) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
////                        [self pushImagePickerController];
//                    });
//                }
//            }];
//        } else {
////            [self pushImagePickerController];
//        }
//    } else {
////        [self pushImagePickerController];
//    }
//
//}

@end

//
//  LLPhotoView.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLPhotoView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSData *)photoUrl;

@property (nonatomic, strong, readonly) NSData *photoUrl;
@end

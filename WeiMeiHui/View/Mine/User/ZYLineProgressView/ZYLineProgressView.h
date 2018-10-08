//
//  ZYLineProgressView.h
//  ZYLineProgressViewDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/3/1.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYLineProgressViewConfig.h"

@interface ZYLineProgressView : UIView

/** 配置 */
@property (nonatomic, strong, readonly) ZYLineProgressViewConfig *config;
/** 进度 */
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UILabel *percentLab;

@property (nonatomic, copy) NSString *progressText;
@property (nonatomic, copy) NSString *percentText;

/**
 统一更新配置，在block中修改config的值
 
 @param configBlock 修改配置的block
 */
- (void)updateConfig:(void(^)(ZYLineProgressViewConfig *config))configBlock;

@end

//
//  LLBottomView.h
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/9/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLBottomView : UIView

@property (nonatomic, copy) void(^startRecord)(void);
@property (nonatomic, copy) void(^stopRecord)(CFTimeInterval recordTime);
@property (nonatomic, copy) void(^sendComplete)(void);
@property (nonatomic, copy) void(^cancelComplete)(void);
@property (nonatomic, copy) void(^backComplete)(void);
@property (nonatomic, copy) void(^switchComplete)(void);

@property (nonatomic, copy) void(^startPhoto)(void);
@property (nonatomic, copy) void(^photoComplete)(void);


- (void)showBtn;
@end

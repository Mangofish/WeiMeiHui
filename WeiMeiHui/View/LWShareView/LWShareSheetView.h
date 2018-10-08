//
//  ArtShareSheetView.h
//  LWShareView
//
//  Created by LeeWong on 2018/1/9.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWShareSheetView : UIView
@property (nonatomic, copy) void (^shareBtnClickBlock)(NSUInteger index);
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, assign) NSUInteger type;

+ (NSInteger)sectionCount;

+(instancetype)shareSheetViewWithType:(NSUInteger)type;


@end

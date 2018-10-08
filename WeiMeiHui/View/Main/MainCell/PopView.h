//
//  PopView.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopViewDelegate <NSObject>


- (void)didClickMenuIndex:(NSInteger)index;

@end

@interface PopView : UIView

@property (nonatomic,   weak) id<PopViewDelegate> delegate;

+(instancetype)popView;

@end

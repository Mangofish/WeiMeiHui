//
//  AlertView.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AlertViewDelegate <NSObject>


- (void)didClickMenuIndex:(NSInteger)index;

@end
@interface AlertView : UIView
+(instancetype)alertViewWithFrame:(CGRect)frame;
@property (nonatomic,   weak) id<AlertViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

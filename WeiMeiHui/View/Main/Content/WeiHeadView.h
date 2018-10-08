//
//  WeiHeadView.h
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiContent.h"
#import "CommentList.h"

@protocol WeiHeadViewDelegate <NSObject>

- (void)didSelectedMoreBtn:(UIButton *)sender;
- (void)didSelectedIconBtn:(UIButton *)sender;

@end

@interface WeiHeadView : UIView

@property(strong,nonatomic)WeiContent *homeCellViewModel;
@property(strong,nonatomic)CommentList *model;

@property(strong,nonatomic)UIButton *moreBtn;
@property(strong,nonatomic)UIButton *contactAvatarView;

@property (nonatomic, weak) id<WeiHeadViewDelegate> delegate;
@property (nonatomic, weak) id<WeiHeadViewDelegate> commentdelegate;
@end

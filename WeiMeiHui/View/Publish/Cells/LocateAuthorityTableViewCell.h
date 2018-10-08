//
//  LocateAuthorityTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocateAuthorityDelegate <NSObject>

- (void)openAction;

@end

@interface LocateAuthorityTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (nonatomic, weak) id<LocateAuthorityDelegate> delegate;
@end

//
//  SystemNotifyTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemNotifyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *content;

+(instancetype)systemNotifyTableViewCell;

@end

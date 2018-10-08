//
//  AuthorWorkListTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AuthorWorkListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataAry;

+(instancetype)authorWorkListTableViewCell:(NSArray *)data;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

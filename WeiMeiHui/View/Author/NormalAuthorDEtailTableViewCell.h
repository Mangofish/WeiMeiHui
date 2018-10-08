//
//  NormalAuthorDEtailTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderComment.h"
@interface NormalAuthorDEtailTableViewCell : UITableViewCell

+(instancetype)normalAuthorDEtailTableViewCell;
+(instancetype)normalAuthorDEtailTableViewCellFooter;
+(instancetype)normalAuthorDEtailTableViewCellTwo;

@property(strong,nonatomic)OrderComment *comment;

@end

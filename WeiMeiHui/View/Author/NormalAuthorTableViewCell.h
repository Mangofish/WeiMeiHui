//
//  NormalAuthorTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorOrdersModel.h"

@interface NormalAuthorTableViewCell : UITableViewCell

+(instancetype)normalAuthorTableViewCell;

@property(strong,nonatomic) AuthorOrdersModel *author;
@property(strong,nonatomic) AuthorOrdersModel *authorDetail;

@end

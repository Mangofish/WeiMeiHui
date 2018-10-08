//
//  AuthorListTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthorListTableViewCellDelegate <NSObject>

- (void)selectAuthor:(NSUInteger)index;
- (void)followAction:(NSUInteger)index;

@end


@interface AuthorListTableViewCell : UITableViewCell

@property(strong,nonatomic)NSArray *author;
@property(weak,nonatomic)id <AuthorListTableViewCellDelegate>delegate;
@end

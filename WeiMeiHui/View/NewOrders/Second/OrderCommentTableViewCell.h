//
//  OrderCommentTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderCommentTableViewCellDelegate <NSObject>

- (void)didClickTagID:(NSString*) tagID;

- (void)didClickScore:(CGFloat) score;

@end

@interface OrderCommentTableViewCell : UITableViewCell

+ (instancetype)orderCommentTableViewCell;

@property(weak,nonatomic) id  <OrderCommentTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (nonatomic,copy) NSArray *finalTag;
@property (nonatomic,copy) NSArray *finaStrTag;

@property (nonatomic,assign) CGFloat cellHeight;
@end

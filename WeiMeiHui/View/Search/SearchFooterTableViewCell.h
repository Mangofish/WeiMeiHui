//
//  SearchFooterTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchFooterDelegate <NSObject>

-(void)lookMore:(NSUInteger)index;

@end

@interface SearchFooterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (nonatomic, weak) id<SearchFooterDelegate> delegate;

+(instancetype)searchFooterTableViewCell;
+(instancetype)searchFooterTableViewCellFooter;

@end

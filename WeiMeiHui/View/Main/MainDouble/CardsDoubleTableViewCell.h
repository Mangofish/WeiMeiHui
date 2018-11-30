//
//  CardsDoubleTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCard.h"


NS_ASSUME_NONNULL_BEGIN

@protocol CardsDoubleTableViewCellDelegate <NSObject>

-(void)leftOrRightAtIndex:(NSUInteger)index andCellIndex:(NSUInteger)cellIndex;

@end


@interface CardsDoubleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgRight;
@property (weak, nonatomic) IBOutlet UILabel *buyLeft;
@property (weak, nonatomic) IBOutlet UILabel *buyRight;
@property (weak, nonatomic) IBOutlet UILabel *priceLeft;
@property (weak, nonatomic) IBOutlet UILabel *priceRight;
@property (weak, nonatomic) IBOutlet UILabel *nameLeft;
@property (weak, nonatomic) IBOutlet UILabel *nameRight;
@property (weak, nonatomic) IBOutlet UILabel *introLeft;

@property (weak, nonatomic) IBOutlet UILabel *introRight;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

+(instancetype)cardsDoubleTableViewCellDouble;
+(instancetype)cardsDoubleTableViewCellSingle;

@property(strong,nonatomic) ShopCard *cardLeft;
@property(strong,nonatomic) ShopCard *cardright;

@property (weak,nonatomic) id <CardsDoubleTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

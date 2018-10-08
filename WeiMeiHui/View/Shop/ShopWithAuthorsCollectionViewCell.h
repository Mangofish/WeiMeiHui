//
//  ShopWithAuthorsCollectionViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"
#import "ShopAuthor.h"

@protocol ShopWithAuthorsCellDelegate <NSObject>

- (void)followingAction:(NSUInteger)index;

@end


@interface ShopWithAuthorsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property(strong,nonatomic) ShopAuthor *author;
@property (strong, nonatomic)   XHStarRateView *starRateView;
@property (nonatomic, assign) id <ShopWithAuthorsCellDelegate> delegate;
@end

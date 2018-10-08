//
//  PublishFooterCollectionReusableView.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublishFooterViewDelegate <NSObject>

- (void)chooseShopAction:(UIButton *)sender;
- (void)chooseRangeAction:(UIButton *)sender;
- (void)chooseShareAction:(UIButton *)sender;

@end

@interface PublishFooterCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UILabel *rangeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) id <PublishFooterViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *viewsBtn;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@end

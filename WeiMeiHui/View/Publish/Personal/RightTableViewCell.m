//
//  RightTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "RightTableViewCell.h"


@interface RightTableViewCell ()


@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation RightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 44)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
//        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 45, 200, 30)];
//        self.priceLabel.font = [UIFont systemFontOfSize:14];
//        self.priceLabel.textColor = [UIColor redColor];
//        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)setModel:(AreaModel *)model
{
    
    if (!model.shop_count.length) {
        
        self.nameLabel.text =[NSString stringWithFormat:@"%@",model.name];
        
    }else{
        
        self.nameLabel.text =[NSString stringWithFormat:@"%@（%@）",model.name,model.shop_count];
        
    }
    
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",@(model.min_price)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

@end

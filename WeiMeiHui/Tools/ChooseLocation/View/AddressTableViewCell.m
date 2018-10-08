//
//  AddressTableViewCell.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressItem.h"

@interface AddressTableViewCell ()

@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic)  UIImageView *selectFlag;

@end
@implementation AddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 44)];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_addressLabel];
        
        _selectFlag = [[UIImageView alloc]initWithFrame:CGRectMake(150, 10, 25, 20)];
        [self.contentView addSubview:_selectFlag];
        _selectFlag.image = [UIImage imageNamed:@"btn_check"];
        
    }
    return self;
}

- (void)setItem:(AddressItem *)item{
    
    _item = item;
    _addressLabel.text = item.name;
    _addressLabel.textColor = item.isSelected ? FontColor :LightFontColor ;
    _selectFlag.hidden = !item.isSelected;
}
@end

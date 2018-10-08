//
//  PackageTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PackageTableViewCell.h"

@implementation PackageTableViewCell

+ (instancetype)packageTableViewCellOne{
    
    PackageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PackageTableViewCell" owner:nil options:nil][0];
    
    return cell;
}

+ (instancetype)packageTableViewCellTwo{
    
    PackageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PackageTableViewCell" owner:nil options:nil][1];
    //    内容
    cell.detail = [[TYAttributedLabel alloc]init];
    cell.detail.delegate = cell;
    
    cell.detail.font = [UIFont systemFontOfSize:14];
    cell.detail.highlightedLinkBackgroundColor = nil;
    cell.detail.highlightedLinkColor=[UIColor redColor];
    [cell.contentView addSubview:cell.detail];
    return cell;
}

+ (instancetype)packageTableViewCellRemark{
    
    PackageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PackageTableViewCell" owner:nil options:nil][2];
    
    return cell;
}

-(void)setGoodsDetail:(RulesItem *)goodsDetail{
    
    [_img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goodsDetail.detail_pic] placeholderImage:[UIImage imageNamed:@"test"]];
    _title.text = goodsDetail.detail_name;
    _count.text = goodsDetail.detail_unit;
//    _remarkLab.text =
}

- (void)setNeedknow:(RulesItem *)needknow{
    
    _item.text = needknow.title;
    
    _detail.frame = CGRectMake(Space,50,kWidth-CELL_SIDEMARGIN*2,needknow.contentHeight);
    [_detail  setTextContainer:needknow.textContainer];
    
    _cellHeight = 60 + needknow.contentHeight;
    
}
@end

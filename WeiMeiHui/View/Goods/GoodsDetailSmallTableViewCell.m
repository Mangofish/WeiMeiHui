//
//  GoodsDetailSmallTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GoodsDetailSmallTableViewCell.h"
#import "UIButton+WebCache.h"

@interface GoodsDetailSmallTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *joinGroupBtn;

@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *activityDetail;

@property (weak, nonatomic) IBOutlet UILabel *couponLab;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *groupPrice;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *priceStrLab;

@end

@implementation GoodsDetailSmallTableViewCell

+ (instancetype)goodsDetailSmallTableViewCellThree{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][2];
    
    return cell;
}

+ (instancetype)goodsDetailSmallTableViewCellTwo{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][1];
    
    return cell;
}

+ (instancetype)goodsDetailSmallTableViewCellOne{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][0];
    cell.tagLab.layer.cornerRadius = 5;
    cell.tagLab.layer.masksToBounds = YES;
    return cell;
}

+ (instancetype)goodsDetailSmallTableViewCellFour{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][3];
    
    return cell;
}

+ (instancetype)goodsDetailSmallTableViewCellFive{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][4];
    cell.joinGroupBtn.layer.cornerRadius = 5;
    cell.joinGroupBtn.layer.masksToBounds = YES;
    return cell;
}

+ (instancetype)goodsDetailSmallTableViewCellOrder{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][5];
    
    return cell;
}

+ (instancetype)goodsDetailSmallTableViewCellOrderComment{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][6];
    
    return cell;
}

+ (instancetype)goodsDetailSmallTableViewCellWeiOrder{
    
    GoodsDetailSmallTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsDetailSmallTableViewCell" owner:nil options:nil][5];
    
    return cell;
}

- (void)setGoodsDetail:(GoodsDetail *)goodsDetail{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goodsDetail.pic] forState:UIControlStateNormal];
    _nameLab.text = goodsDetail.nickname;
    
    
    _countLab.text = [NSString stringWithFormat:@"已发起了%@人团",goodsDetail.group_num];
    
    _tagLab.text = [NSString stringWithFormat:@" %@ ",goodsDetail.activity_name];
    
    _activityDetail.text = goodsDetail.activity_dis;
    _couponLab.text = goodsDetail.coupon_dis;
    
    if (goodsDetail.org_price.length) {
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",goodsDetail.org_price] attributes:attribtDic];
        
        // 赋值
        _price.attributedText = attribtStr;
    }else{
        _price.hidden = YES;
        _priceStrLab.hidden = YES;
    }
  
    
    if (goodsDetail.group_num.length) {
        _groupPrice.text = [NSString stringWithFormat:@"%@人拼团价：¥%@",goodsDetail.group_num,goodsDetail.group_price];
        _goodsName.text = goodsDetail.goods_name;
        
    }else if (goodsDetail.pay_price.length) {
        
        _groupPrice.text = [NSString stringWithFormat:@"¥%@",goodsDetail.pay_price];
        _goodsName.text = goodsDetail.title;

        
    }
    
}

- (void)setGroupList:(GoodsDetail *)groupList{
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:groupList.pic] forState:UIControlStateNormal];
    _nameLab.text = groupList.nickname;
    _joinGroupBtn.hidden = NO;
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",groupList.org_price] attributes:attribtDic];
    
    // 赋值
    _price.attributedText = attribtStr;
    
    if (groupList.group_num.length) {
        _groupPrice.text = [NSString stringWithFormat:@"%@人拼团价：¥%@",groupList.group_num,groupList.group_price];
        _goodsName.text = groupList.tag_name;
        
    }
}


-(void)setOrder:(GoodsDetail *)order{
    
    _orderNum.text =[NSString stringWithFormat:@"订单编号：%@",order.order_number];

    _time.text = [NSString stringWithFormat:@"下单时间：%@",order.create_time];
    
    
}

-(void)setWeiorder:(GoodsDetail *)weiorder{
    
    _orderNum.text =[NSString stringWithFormat:@"%@",weiorder.title];
    
    _time.text = [NSString stringWithFormat:@"%@",weiorder.detail];
    
    _status.text = [NSString stringWithFormat:@"¥%@",weiorder.pay_price];
    
       
}

-(void)setRealorder:(GoodsDetail *)realorder{
    
    _orderNum.text =[NSString stringWithFormat:@"%@",realorder.title];
    
    _time.text = [NSString stringWithFormat:@"%@",realorder.pay_price];
    
    _status.hidden = YES;
    
    
}

- (void)setOrderComment:(GoodsDetail *)orderComment{
    
    _orderNum.text = [NSString stringWithFormat:@"订单编号：%@",orderComment.order_number];
    _time.text = [NSString stringWithFormat:@"使用时间：%@",orderComment.end_time];
    
    if (!orderComment.end_time) {
        _time.text = [NSString stringWithFormat:@"使用时间：%@",orderComment.create_time];
    }
    
    if (!orderComment.create_time) {
        _time.text = [NSString stringWithFormat:@"使用时间：%@",orderComment.use_time];
    }
    
}

- (void)setKillorder:(GoodsDetail *)killorder{
    
    _goodsName.text = killorder.goods_name;
     _groupPrice.text = [NSString stringWithFormat:@"¥%@",killorder.sec_price];
    
    if (killorder.org_price.length) {
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",killorder.org_price] attributes:attribtDic];
        
        // 赋值
        _price.attributedText = attribtStr;
    }else{
        _price.hidden = YES;
        _priceStrLab.hidden = YES;
    }
    
    _tagLab.text = [NSString stringWithFormat:@" %@ ",killorder.activity_name];
    
    _activityDetail.text = killorder.activity_content;
    
}
@end

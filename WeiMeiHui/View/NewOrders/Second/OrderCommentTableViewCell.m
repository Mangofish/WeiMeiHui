//
//  OrderCommentTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "OrderCommentTableViewCell.h"
#import "GBTagListView.h"
#import "XHStarRateView.h"
#import "UITextView+Placeholder.h"

@interface OrderCommentTableViewCell ()<XHStarRateViewDelegate>{
    
    NSString *tagID;
    
}


@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;



@property (weak, nonatomic) IBOutlet UILabel *tagLab;

@property (strong, nonatomic)  GBTagListView *bubbleView;
@property (strong, nonatomic) XHStarRateView *starRateView;

@end

@implementation OrderCommentTableViewCell


+(instancetype)orderCommentTableViewCell{
    
    OrderCommentTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"OrderCommentTableViewCell" owner:self options:nil][0];
    
//    cell.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(kWidth/3, 12, kWidth/3, 20)];
//    cell.starRateView.isAnimation = YES;
//    cell.starRateView.rateStyle = HalfStar;
//    cell.starRateView.currentScore = 5;
//    [cell.contentView addSubview:cell.starRateView];
//    cell.starRateView.delegate = cell;
//    cell.contentTF.placeholder = @"请详细描述您对手艺人的评价";
    return cell;
    
}

- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 50, kWidth, 0)];
        /**允许点击 */
        _bubbleView.canTouch=YES;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=NO;
        _bubbleView.canTouchNum = 3;
        _bubbleView.signalTagColor=MJRefreshColor(242, 242, 242);

        __block NSArray *tag = _finalTag;
        __block NSArray *tagStr = _finaStrTag;
        _bubbleView.didselectItemBlock = ^(NSArray *arr) {
            
            NSMutableString *temp = [NSMutableString string];
            for (int i=0; i<arr.count ; i++) {
                
                NSString *obj = arr[i];
                NSUInteger index = [tagStr indexOfObject:obj];
                NSString *ids = [tag[index] objectForKey:@"id"];
                [temp appendString:ids];
                
                if (i == arr.count-1) {
                    
                }else{
                    [temp appendString:@","];
                }
                
            }
            
            
            [self.delegate didClickTagID:temp];
            
            self.tagLab.text = [NSString stringWithFormat:@"选择标签：（%lu/3）",(unsigned long)arr.count];
//            代理方法
            
        };
        
    }
    
    return _bubbleView;
    
}

- (void)setFinalTag:(NSArray *)finalTag{
    
    _finalTag = finalTag;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *obj in finalTag) {
        
        NSString *num = [NSString stringWithFormat:@"%@",obj[@"num"]];
        
        if (num.length) {
             [temp addObject:[NSString stringWithFormat:@"%@（%@）",obj[@"name"],obj[@"num"]]];
        }else{
             [temp addObject:[NSString stringWithFormat:@"%@",obj[@"name"]]];
        }
        
       
    }
    
    _finaStrTag = temp;
     [self.bubbleView setTagWithTagArray:_finaStrTag];
    [self.contentView addSubview:self.bubbleView];
    
    self.cellHeight =  CGRectGetMaxY(self.bubbleView.frame) + 92;
}

- (void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore {
    [self.delegate didClickScore:currentScore];
}


@end

//
//  PublicMethods.m
//  WMHUser
//
//  Created by Mac on 16/10/19.
//  Copyright © 2016年 罗大勇. All rights reserved.
//

#import "PublicMethods.h"
#import <CommonCrypto/CommonDigest.h>
#import "DyPayByAliTool.h"
#import "getIPhoneIP.h"
#import "XMLDictionary.h"
#import "DataMD5.h"
#import "Order.h"
#import "DataSigner.h"

//获取手机型号需要导入

#import "sys/utsname.h"
//获取运行商需要导入

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation PublicMethods

//MD5
+(NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//转json
+(NSString*)dataTojsonString2:(id)object
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:object];
    
    NSMutableArray *dataAry = [NSMutableArray arrayWithArray:[dic allValues]];
    NSArray *keyAry = dic.allKeys;
    for (int i =0; i<dataAry.count; i++) {
        
        NSString *str = [dataAry objectAtIndex:i];
        if ([str containsString:@"+"]) {
            
            str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2b"];
            [dataAry replaceObjectAtIndex:i withObject:str];
        }
        
        [dic setObject:dataAry[i] forKey:keyAry[i]];
    }
    
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
     return jsonString;
    
}

//转json
+(NSString*)dataTojsonString:(id)object
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:object];
    NSString *temp = [self addSecret:object];
    [dic setObject:temp forKey:@"sign"];
        NSString *jsonString = nil;
        NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
    
    return jsonString;
}

+(id)addSecret:(NSDictionary *)object{
    //排序
    NSArray *keyAry = object.allKeys;
    NSArray *afterSortKeyArray = [keyAry sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [object objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    
    NSMutableString *str = [NSMutableString string];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        //排好序字典
        NSDictionary *dic =@{afterSortKeyArray[i]:valueArray[i]};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString* string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSMutableString *tempStr = [NSMutableString stringWithString:string];
        //去大括号
        
        if (i==0) {
            string = [string substringToIndex:string.length-1];
        }else if (i == afterSortKeyArray.count-1){
            string = [string substringFromIndex:1];
        }else{
            string = [string substringWithRange:NSMakeRange(1, string.length-2)];
        }
        if ( i == 0) {
            [str appendString:string];
        }else{
            [str appendFormat:@"&%@",string];
        }
        

        NSString *subStr = [NSMutableString stringWithString:str];
        if ([str hasPrefix:@"{"] ) {
            subStr = [str substringWithRange:NSMakeRange(1, str.length-1)];
        }
       
        if ([subStr hasSuffix:@"}"]) {
            subStr = [subStr substringWithRange:NSMakeRange(0, subStr.length-2)];
        }
        

        subStr = [subStr stringByReplacingOccurrencesOfString:@":" withString:@"="];
        subStr = [subStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        str = [NSMutableString stringWithString:subStr];
    }
    
  
   
    [str appendString:@"!@#%weimeihui!#$%^&"];
    NSString *finalStr = nil;
    //1. 去除掉首尾的空白字符和换行字符
//    finalStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //2. 去除掉其它位置的空白字符和换行字符
    finalStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    finalStr = [finalStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    finalStr = [self md5:finalStr];
    finalStr = [self md5:finalStr];
    return finalStr;
}

+(BOOL)isHaveAddress{
    
    NSDictionary *dic  =[[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    if ([dic[@"is_address"] integerValue] == 1) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isLogIn{
   
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"]) {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isHaveMessage{
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:UNREAD] integerValue] == 1) {
        return YES;
    }
    
    return NO;
}

+(BOOL)isInternetAlright:(NSDictionary *)dic{
    return [dic[@"success"] boolValue];
}


#pragma - mark- 发起支付宝支付
+ (void)aliPayActionWithOrderNum:(NSString *)orderNum andPrice:(double)price andNotify:(NSString *)url{
    
    [DyPayByAliTool payByAliWithSubjects:@"微美惠" body:nil price:price  orderId:orderNum partner:@"2088121396257125" seller:@"13039191181@163.com" url:url privateKey:@"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANH27Cv3PDkSR1rD4zjruf8M3smeaBLITr0IVVbI0Jvesx+7UY1Vd+vMegvrXFms4tNkZb8KIyzk2WYYEeyC500romA+92Ro534wqW1Z4u+ZctgooYBRbUig1LDCi5VfxLmhQDIV3INIaZLvpzRDF0RoV6OFfdGgO+P7qM2TlKgfAgMBAAECgYBzjmd65w4xBttYm/jhafMq6QVwh4sV00JqjTySj+En+BAzhZ+jnodqslX1W2qvPBR2bYoF82lamvT/WH384iqz8cqfAzn5oLPMXNKMYwMV/88H9N6T3RV8QggnpNX/NScgOJADMxCafN1VxHecx9Ad7wIW+l8CKQ3dpyDxPC6PWQJBAPE96CHDKxfEIiINylAeROSYypZVKjdPvKcNORrYgNp6/5Ex77KTkaqkS4rky/tB1ayl4LA2R1mxGbXKt1/i1G0CQQDezy5+In7PmTaXjhRCvmDbjeQt9PmaQ/o0Ez4hPWOUJ6f3XnEKCQFrS14bZZk8dtiKvFCuPkYsrbu1eLtTFp87AkEAgBds4DBu+ymLLiXAXJYV4oM2XmhOCBxwgQrGXXjDwj444PFw4pL0b3TZH6CopnqoaAmTqjzH2dntWteOUn1waQJAU0RCL8lccuDjUgg68iaLtAF3AOXIUiqNWuDGG04B5OBdGUkmHYX4Dc0AwmRZvAr+Kfrue++x8giLWepgt1CA+QJBALo6bjHkpTk9ueYjA8/mvrRwgk7/l4tiLaypCcJonHfuWMEzm6odMKEOZryHUQRQDf+f8L7/p1WrmNh+uPw4ZgE=" success:^(NSDictionary *info) {
        
        if ([[info objectForKey:@"resultStatus"] integerValue] == 9000) {
            
            
        }
        
    }];
    
    
    
    
    
}



#pragma - mark- 发起微信支付
+ (void)wxPayActionWithOrderNum:(NSString *)orderNum andPrice:(NSString *)price andNotify:(NSString *)url{
    
    [self jumpToBizPayWithOrderNum:orderNum andPrice:price andNotify:url];
    
}

+ (void)jumpToBizPayWithOrderNum:(NSString*)orderNum andPrice:(NSString*)price andNotify:(NSString *)url{
    
    //判断是否安装了微信
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"您没有安装微信");
        return;
    }else if (![WXApi isWXAppSupportApi]){
        NSLog(@"您安装的微信版本过低");
        return ;
    }
    NSLog(@"安装了微信并支持支付");
    
    //统一下单
    NSString *appid,*mch_id,*nonce_str,*sign,*body,*out_trade_no,*total_fee,*spbill_create_ip,*notify_url,*trade_type,*partner;
    //应用APPID
    appid = @"wxbb6becd4bf51596e";
    //微信支付商户号
    mch_id = @"1401015502";
    //产生随机字符串，这里最好使用和安卓端一致的生成逻辑
    nonce_str =[self generateTradeNO];
    body =@"微美惠";
    //随机产生订单号用于测试，正式使用请换成你从自己服务器获取的订单号
    out_trade_no = orderNum;
    //交易价格1表示0.01元，10表示0.1元
    total_fee =price;
    //获取本机IP地址，请再wifi环境下测试，否则获取的ip地址为error，正确格式应该是8.8.8.8
    spbill_create_ip =[getIPhoneIP getIPAddress:YES];
    //交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
    notify_url =[NSString stringWithFormat:@"%@/order_number/%@",url,orderNum];
    trade_type =@"APP";
    //商户密钥
    partner = @"WMHweixinmiyao20161022922weixinp";
    
//    NSLog(@"appid%@ mch_id%@ nonce_str%@ sign%@ body%@ out_trade_no%@ total_fee%@ spbill_create_ip%@ notify_url%@ trade_type%@ partner%@",appid,mch_id,nonce_str,sign,body,out_trade_no,total_fee,spbill_create_ip,notify_url,trade_type,partner);
    
    //获取sign签名
    DataMD5 *data = [[DataMD5 alloc] initWithAppid:appid mch_id:mch_id nonce_str:nonce_str partner_id:partner body:body out_trade_no:out_trade_no total_fee:total_fee spbill_create_ip:spbill_create_ip notify_url:notify_url trade_type:trade_type];
    sign = [data getSignForMD5];
    NSLog(@"签名%@",sign);
    //设置参数并转化成xml格式
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:appid forKey:@"appid"];//公众账号ID
    [dic setValue:mch_id forKey:@"mch_id"];//商户号
    [dic setValue:nonce_str forKey:@"nonce_str"];//随机字符串
    [dic setValue:sign forKey:@"sign"];//签名
    [dic setValue:body forKey:@"body"];//商品描述
    [dic setValue:out_trade_no forKey:@"out_trade_no"];//订单号
    [dic setValue:total_fee forKey:@"total_fee"];//金额
    [dic setValue:spbill_create_ip forKey:@"spbill_create_ip"];//终端IP
    [dic setValue:notify_url forKey:@"notify_url"];//通知地址
    [dic setValue:trade_type forKey:@"trade_type"];//交易类型
    // 转换成xml字符串
    NSString *string = [dic XMLString];
    [self http:string];
}

#pragma mark - 拿到转换好的xml发送请求
+(void)http:(NSString *)xml {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //这里传入的xml字符串只是形似xml，但是不是正确是xml格式，需要使用af方法进行转义
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return xml;
    }];
    //发起请求
    [manager POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:xml progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        [MBProgressHUD hideHUD];
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        NSLog(@"responseString is %@",responseString);
        //将微信返回的xml数据解析转义成字典
        NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
        //判断返回的许可
        if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"] &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
            //发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.openID = [dic objectForKey:@"appid"];
            request.partnerId = [dic objectForKey:@"mch_id"];
            request.prepayId= [dic objectForKey:@"prepay_id"];
            request.package = @"Sign=WXPay";
            request.nonceStr= [dic objectForKey:@"nonce_str"];
            //将当前事件转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp= timeStamp;
            
            // 签名加密
            DataMD5 *md5 = [[DataMD5 alloc] init];
            request.sign=[md5 createMD5SingForPay:request.openID partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
            NSLog(@"%@",request.sign);
            // 调用微信
            //            [self showRoundProgressWithTitle:@"正在生成订单..."];
            [WXApi sendReq:request];
            
        }else{
            
            NSLog(@"参数不正确，请检查参数");
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
        //        [MBProgressHUD hideHUD];
        //        [MBProgressHUD showError:@"未完成支付"];
    }];
    
}


#pragma mark - 产生随机订单号
+(NSString *)generateTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0)); // 此行代码有警告:
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - 获取设备信息
+(NSArray *)requestDeviceInfo{
   
    NSMutableArray *infoAry  = [NSMutableArray array];
    
    //设备唯一标识符
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"设备唯一标识符:%@",identifierStr);
    //设备名称
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString * phoneModel =  [PublicMethods deviceVersion];
    NSLog(@"手机型号:%@",phoneModel);

    [infoAry addObjectsFromArray:@[identifierStr,phoneVersion,phoneModel]];
    
    return infoAry;
    
}

+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return  deviceString;
}

#pragma mark - 判断座机号
+ (BOOL)isLocatedNumber:(NSString *)mobileNum{
    
    //验证输入的固话中不带 "-"符号
    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    //验证输入的固话中带 "-"符号
    //    NSString * strNum = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|14[5|7|9]|15[0-9]|17[0|1|3|5|6|7|8]|18[0-9])\\d{8}$)";
    
    
    NSPredicate *checktest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    
    return [checktest evaluateWithObject:mobileNum];
    
    //    return YES;
}

/**
 * 手机号码格式验证
 */
+(BOOL)isTelphoneNumber:(NSString *)telNum{
    
    telNum = [telNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] != 11) {
        return NO;
    }
    
    /**
     * 规则 -- 更新日期 2017-03-30
     * 手机号码: 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     *
     * [数据卡]: 14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147,中国电信的是149等等。
     * [虚拟运营商]: 170[1700/1701/1702(电信)、1703/1705/1706(移动)、1704/1707/1708/1709(联通)]、171（联通）
     * [卫星通信]: 1349
     */
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147(数据卡),150,151,152,157,158,159,170[5],178,182,183,184,187,188
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[8])|(18[2-4,7-8]))\\d{8}|(170[5])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145(数据卡),155,156,170[4,7-9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[156])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149(数据卡),153,170[0-2],173,177,180,181,189
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNum];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNum];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNum];
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}

+ (double) couponCaculatePrice:(NSDictionary *)couponDic beforePrice:(double)beforePrice{
    
    double finalPrice = 0.0;

//        门槛金额
    double holdPrice = [couponDic[@"threshold"] doubleValue];
//         满减金额
    double decPrice = [couponDic[@"par_value"] doubleValue];
    
    if (beforePrice >= holdPrice) {
        finalPrice = beforePrice - decPrice;
    }
    
    return finalPrice;
}

// 百度地图经纬度转换为高德地图经纬度
+ (CLLocationCoordinate2D)getGaoDeCoordinateByBaiDuCoordinate:(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(coordinate.latitude - 0.006, coordinate.longitude - 0.0065);
    
}

// 高德地图经纬度转换为百度地图经纬度
+ (CLLocationCoordinate2D)getBaiDuCoordinateByGaoDeCoordinate:(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065);
    
}




@end




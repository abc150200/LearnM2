#import "AESenAndDe.h"
#import "FBEncryptorAES.h"
#import "GTMBase64.h"

#warning 注意修改每个项目不同的 key 值
#define kKey @"b7be61cc3aa32b38"

@implementation AESenAndDe


/*!
 *  加密以后再 base64 转成字符串
 *
 *  @param str 需要加密的字符串
 *
 *  @return NSData数据
 */
+(NSData *)En_AESandBase64ToData:(NSString *)str
{
    NSData *data_aes = [FBEncryptorAES encryptData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                               key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];

    return [[NSString stringWithFormat:@"%@",[GTMBase64 stringByEncodingData:data_aes]] dataUsingEncoding:NSUTF8StringEncoding];
}

/*!
 *  加密以后再 base64 转成字符串
 *
 *  @param str 需要加密的字符串
 *
 *  @return NSString数据
 */
+(NSString *)En_AESandBase64EnToString:(NSString *)str keyValue:(NSString *)keyValue
{
    NSData *data_aes = [FBEncryptorAES encryptData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                               key:[keyValue dataUsingEncoding:NSASCIIStringEncoding]];
    
//    return [NSString stringWithFormat:@"%@",[GTMBase64 stringByEncodingData:data_aes]];

    return [[self byteToString:data_aes] uppercaseString];
}

+(NSString*)byteToString:(NSData*)data
{
    Byte *plainTextByte = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",plainTextByte[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


/* 以上为加密
 =================================== ===================================
 =================================== ===================================
  以下为解密*/

/*!
 *  base64 转换以后解密
 *
 *  @param str 需要解密的 base64字符串
 *
 *  @return 解密后字符串
 */
+(NSString *)De_Base64andAESDeToString:(NSString *)str keyValue:(NSString *)keyValue
{
    NSData *data_dec = [FBEncryptorAES decryptData:[self stringToByte:str]
                                               key:[keyValue dataUsingEncoding:NSASCIIStringEncoding]];

    return [[NSString alloc]initWithData:data_dec encoding:NSUTF8StringEncoding];
    
}

/*!
 *  base64 转换以后解密
 *
 *  @param str 需要解密的 base64字符串
 *
 *  @return 解密后NSData
 */
+(NSData *)De_Base64andAESToData:(NSString *)str
{
    return [FBEncryptorAES decryptData:[GTMBase64 decodeString:str]
                                   key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
}

/*!
 *  base64 转换以后解密
 *
 *  @param str 需要解密的 base64字符串
 *
 *  @return 解密后字典
 */
+(NSDictionary *)De_Base64andAESToDictionary:(NSString *)str
{
    NSData *data_dec = [FBEncryptorAES decryptData:[GTMBase64 decodeString:str]
                                               key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString *str_dec = [[NSString alloc]initWithData:data_dec encoding:NSUTF8StringEncoding];
    if (!str_dec) {
        return nil;
    }

    NSDictionary *jsonObjects =[[NSDictionary alloc]init];
    NSError *e = nil;

    jsonObjects = [NSJSONSerialization JSONObjectWithData: [str_dec dataUsingEncoding:NSUTF8StringEncoding]
                                                  options: NSJSONReadingMutableContainers
                                                    error: &e];

    if (e) {
        return  nil;
    }

    return jsonObjects;
    
}


+(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}



//+(NSData*)stringToByte:(NSString*)string
//{
////    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ([string length]%2!=0) {
//        return nil;
//    }
//    Byte tempbyt[1]={0};
//    NSMutableData* bytes=[NSMutableData data];
//    for(int i=0;i<[string length];i++)
//    {
//        unichar hex_char1 = [string characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
//        int int_ch1;
//        if(hex_char1 >= '0' && hex_char1 <='9')
//        int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
//        else if(hex_char1 >= 'A' && hex_char1 <='F')
//        int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
//        else
//        return nil;
//        i++;
//        
//        unichar hex_char2 = [string characterAtIndex:i]; ///两位16进制数中的第二位(低位)
//        int int_ch2;
//        if(hex_char2 >= '0' && hex_char2 <='9')
//        int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
//        else if(hex_char2 >= 'A' && hex_char2 <='F')
//        int_ch2 = hex_char2-55; //// A 的Ascll - 65
//        else
//        return nil;
//        
//        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
//        [bytes appendBytes:tempbyt length:1];
//    }
//    return bytes;
//}


@end

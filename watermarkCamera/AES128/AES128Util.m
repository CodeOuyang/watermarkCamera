//
//  AES128Util.m
//  ASE128Demo
//
//  Created by zhenghaishu on 11/11/13.
//  Copyright (c) 2013 Youku.com inc. All rights reserved.
//

#import "AES128Util.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation AES128Util

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [GTMBase64 stringByEncodingData:resultData];
    }
    free(buffer);
    return nil;
}


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

// 普通字符串转换为十六进

+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
        
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        
        hexStr = [hexStr stringByAppendingString:newHexStr];
        
    }
    return hexStr;
}

//参考：http://blog.csdn.net/linux_zkf/article/details/17124577
//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            
            byte = *ch - '0';
        }else if ('a' <= *ch && *ch <= 'f') {
            
            byte = *ch - 'a' + 10;
        }else if ('A' <= *ch && *ch <= 'F') {
            
            byte = *ch - 'A' + 10;
            
        }
        
        ch++;
        
        byte = byte << 4;
        
        if (*ch) {
            
            if ('0' <= *ch && *ch <= '9') {
                
                byte += *ch - '0';
                
            } else if ('a' <= *ch && *ch <= 'f') {
                
                byte += *ch - 'a' + 10;
                
            }else if('A' <= *ch && *ch <= 'F'){
                
                byte += *ch - 'A' + 10;
                
            }
            
            ch++;
            
        }
        
        [data appendBytes:&byte length:1];
        
    }
    
    return data;
}

@end

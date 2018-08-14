//
//  SocketManager.m
//  socketDemo
//
//  Created by 李鹏辉-PC on 17/8/24.
//  Copyright © 2017年 李鹏辉. All rights reserved.
//

#import "SocketManager.h"
#import "GCDAsyncSocket.h"

@interface SocketManager ()<GCDAsyncSocketDelegate>
{
    NSInteger dataLength;//长度
    NSInteger action;
    NSTimer *timer;
    
}
@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation SocketManager

+ (SocketManager *)shareSocketManager {
    static SocketManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[SocketManager alloc] init];
    });
    return manager;
}

- (void)connect {
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    //这里需要host和port
    [self.socket connectToHost:@"192.168.2.10" onPort:8888 error:&error];
    if (error) {
        NSLog(@"连接服务器失败");
    } else {
        NSLog(@"连接服务器成功");
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }
}

- (void)timerFireMethod:(NSTimer *)timers {
     [self.socket readDataWithTimeout:-1 tag:0];
}

// 代理方法
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功:%@, %d", host, port);
}

- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    NSLog(@"%@",err);
    NSError *error = nil;
    [self.socket connectToHost:@"192.168.2.10" onPort:8888 error:&error];
}

//接收读取数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSData *tempData = data;
    NSLog(@"%@",tempData);
    
}
//将data转换为16进制字符串
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
/**
 * 十六进制的字符串转换为十进制数字
 */
- (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}


/**
 十六进制转换为二进制
 
 @param hex 十六进制数
 @return 二进制数
 */
- (NSString *)getBinaryByHex:(NSString *)hex {
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}

#pragma mark - 主动断开连接
- (void)executeDisconnectServer
{
    //更新sokect连接状态
    [self disconnect];
    NSLog(@"连接状态更新");
}

#pragma mark - 连接中断
- (void)serverInterruption
{
    //更新soceket连接状态
    [self disconnect];
}

- (void)disconnect
{
    NSLog(@"连接中断");
}

#pragma mark - 发送心跳
- (void)sendBeat
{
    //定时发送心跳开启
}

@end

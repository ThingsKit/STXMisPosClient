//
//  STXDataExchange.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-13.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "STXDataExchange.h"
#import <ShuaTianXiaMispos.h>
#import <AsyncSocket.h>

@interface STXDataExchange()<STXConnectionDelegate,AsyncSocketDelegate>
@property (nonatomic, strong) AsyncSocket *asyncSocket;
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, assign) BOOL isReceiving;
@property (nonatomic, strong) NSData *receiveData;
@end
@implementation STXDataExchange
+ (instancetype)shared
{
    static dispatch_once_t pred;
    static STXDataExchange *sharedinstance = nil;
    dispatch_once(&pred, ^{ sharedinstance = [[self alloc] init]; });
    return sharedinstance;
}

- (void)prepareChangeData
{
    if (_condition == nil)
    {
        _condition = [[NSCondition alloc]init];
    }
    if (_asyncSocket == nil)
    {
        _asyncSocket = [[AsyncSocket alloc]initWithDelegate:self];
    }
    
    [_asyncSocket disconnect];
    
    NSString *IP = [[NSUserDefaults standardUserDefaults]objectForKey:@"IP"];
    NSString *port = [[NSUserDefaults standardUserDefaults]objectForKey:@"Port"];
    IP = (IP == nil ? @"121.201.104.202" :IP);
    port = (port == nil ? @"9002" : port);
    
    NSError *error = nil;
    [_asyncSocket connectToHost:IP onPort:[port intValue] error:&error];
    [[ShuaTianXiaMispos sharedInstance]setSTXPOSPConnectionDelegate:self];
}

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
    LogFUNC;
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    LogFUNC;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    LogFUNC;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    LogFUNC;
    [self.condition lock];
    self.receiveData = nil;
    self.isReceiving = NO;
    [self.condition signal];
    [self.condition unlock];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    LogFUNC;
    if (self.isReceiving)
    {
        [self.condition lock];
        self.receiveData = data;
        self.isReceiving = NO;
        [self.condition signal];
        [self.condition unlock];
    }
}

- (void)exAsycGlobalQueue:(void (^)())queue
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue
{
    dispatch_async(dispatch_get_main_queue(), queue);
}


- (NSData*)exchangeDataWithServer:(NSData *)data STXMessage:(STXMisposResponsePacket *)response
{
    LogFUNC;
    WEAKSELF;
    [self exAsycGlobalQueue:^{
        [self exMainQueue:^{
            STRONGSELF;
            [strongSelf.asyncSocket writeData:data withTimeout:8000 tag:0];
            [strongSelf.asyncSocket readDataWithTimeout:-1 tag:0];
        }];
    }];
    
    self.isReceiving = YES;
    [self.condition lock];
    [self.condition wait];
    [self.condition unlock];
    return self.receiveData;
}

@end

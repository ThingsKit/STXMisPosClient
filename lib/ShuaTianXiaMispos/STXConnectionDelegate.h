//
//  STXConnectionDelegate.h
//  ShuaTianXiaMispos
//
//  Created by huanggq on 14-8-7.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STXMisposResponsePacket.h"
@protocol STXConnectionDelegate <NSObject>
//-(void)sendToServer:(NSData*)data STXMessage:(STXMisposResponsePacket*)response;
-(NSData*)exchangeDataWithServer:(NSData*)data STXMessage:(STXMisposResponsePacket*)response;
@end

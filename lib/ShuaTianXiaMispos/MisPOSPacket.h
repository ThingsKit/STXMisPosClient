//
//  MisPOSPacket.h
//  MisposTemplate
//
//  Created by huanggq on 14-6-4.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MisPOSPacket <NSObject>
-(NSData*)toBytes;
+(id)fromBytes:(NSData*)data;
@end

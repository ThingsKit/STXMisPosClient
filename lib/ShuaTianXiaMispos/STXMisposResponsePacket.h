//
//  STXMisposResponsePacket.h
//  ShuaTianXiaMispos
//
//  Created by huanggq on 14-8-5.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import "BaseMisposResponsePacket.h"

static NSString* kTAG_ONLINEDEAL_COUNT = @"01";
static NSString* kTAG_OFFLINE_DEAL_COUNT = @"02";

@interface STXMisposResponsePacket : BaseMisposResponsePacket<NSCopying>
@property(nonatomic,strong) NSString*   onlineDealCount;
@property(nonatomic,strong) NSString*   offlineDealCount;
@property(nonatomic,strong) NSArray*    records;//查询结果
@property(nonatomic,strong) NSString*   printResult;
-(id)initWithData:(NSData*)data;
@end

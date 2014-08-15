//
//  STXMisposRequestPacket.h
//  ShuaTianXiaMispos
//
//  Created by huanggq on 14-8-5.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import "BaseMisposRequestPacket.h"
@interface STXMisposRequestPacket : BaseMisposRequestPacket
@property(nonatomic, strong) NSString* Index;
@property(nonatomic, strong) NSString* Count;
@end

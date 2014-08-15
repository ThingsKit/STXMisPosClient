//
//  BaseMisposRequestPacket.h
//  ShuaTianXiaMispos
//
//  Created by huanggq on 14-8-5.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractMisPOSPacket.h"

@interface BaseMisposRequestPacket : AbstractMisPOSPacket<MisPOSPacket>
@property(nonatomic, strong) NSString* Amount;

@property(nonatomic, strong) NSString* CardNum;

@property(nonatomic, strong) NSString* OldRefferNO;

@property(nonatomic, strong) NSString* OldTerminalID;

@property(nonatomic, strong) NSString* OldVoucherNO;

@property(nonatomic, strong) NSString* OldBatchNO;

@property(nonatomic, strong) NSString* OldCertificationNO;

@property(nonatomic, strong) NSString* OldTransDate;

@property(nonatomic, strong) NSString* OperatorID;

@property(nonatomic, strong) NSString* OperatorPassword;

@property(nonatomic, strong) NSData*   Apdu;

@property(nonatomic, strong) NSString* Tips;

@property(nonatomic, strong) NSString* MerchantNO;

@property(nonatomic, strong) NSString* TransType;

@property(nonatomic, strong) NSString* MerchantName;

@property(nonatomic, strong) NSString* TerminalID;

@property(nonatomic, strong) NSData*   Tpdu;

@property(nonatomic, strong) NSString* AuthCode;

@property(nonatomic, strong) NSString* NetworkManagementCode;

@property(nonatomic, strong) NSData*   SignData; ///签名信息

-(NSData*)TLVPackage:(NSString*)tag Value:(NSData*)value;

@end

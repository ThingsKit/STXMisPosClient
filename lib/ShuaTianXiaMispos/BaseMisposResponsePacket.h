//
//  BaseMisposResponsePacket.h
//  ShuaTianXiaMispos
//
//  Created by huanggq on 14-8-5.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractMisPOSPacket.h"

@interface BaseMisposResponsePacket : AbstractMisPOSPacket<NSCopying,MisPOSPacket>
@property(nonatomic,strong) NSString*   transType; ///交易类型
@property(nonatomic,strong) NSString*   resCode;  //2交易返回码
@property(nonatomic,strong) NSString*   amount;//3交易金额
@property(nonatomic,strong) NSString*   transDate;//4交易日期
@property(nonatomic,strong) NSString*   transTime;//5交易时间
@property(nonatomic,strong) NSString*   authNo;//6授权码
@property(nonatomic,strong) NSString*   cardNo;//7卡号
@property(nonatomic,strong) NSString*   refNo;//8交易参考号
@property(nonatomic,strong) NSString*   voucherNo;//9交易流水号
@property(nonatomic,strong) NSString*   merchantNO;//10商户代码
@property(nonatomic,strong) NSString*   merchantName;//11商户名称
@property(nonatomic,strong) NSString*   iss_bank_no;//12发卡行代码
@property(nonatomic,strong) NSString*   acq_bank_no;//13收单行代码
@property(nonatomic,strong) NSString*   trans_result_desc;//14交易结果说明
@property(nonatomic,strong) NSString*   terminalNo;//15终端号
@property(nonatomic,strong) NSString*   batchNo;//16批次号
@property(nonatomic,strong) NSString*   old_transDate;//17原交易日期
@property(nonatomic,strong) NSString*   old_merchantNO;//18原交易商户号
@property(nonatomic,strong) NSString*   old_refNo;//19原交易参考号
@property(nonatomic,strong) NSString*   old_batchNo;//20原交易批次号
@property(nonatomic,strong) NSString*   old_terminalNo;//21原交易终端号
@property(nonatomic,strong) NSString*   old_voucherNo;//22原交易流水号
@property(nonatomic,strong) NSString*   ic_card_data;//23IC卡数据域
@property(nonatomic,strong) NSString*   settle_data;// 结算数据
@property(nonatomic,strong) NSData*     apduCmdData; //apduCmd data
@property(nonatomic,strong) NSString*   termType;//25终端类型
@property(nonatomic,strong) NSString*   sn;//26硬件序列号
@property(nonatomic,strong) NSString*   featureCode;//特征码
@property(nonatomic,strong) NSString*   tpdu;
+(BOOL)makeUpDict:(NSMutableDictionary *)tlvs FromData:(unsigned char *)data DataSize:(unsigned long)size;
+(BaseMisposResponsePacket*)fromDictionary:(NSDictionary*)dic;
-(id)initWithData:(NSData*)data;
-(id)initWithDictionary:(NSDictionary*)dic;
@end

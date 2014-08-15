//
//  ShuaTianXiaMispos.h
//  ShuaTianXiaMispos
//
//  Created by huanggq on 14-8-5.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MisposTemplate.h"
#import "STXMisposRequestPacket.h"
#import "STXMisposResponsePacket.h"
#import "STXConnectionDelegate.h"

/*!
 *  过程消息
 *
 */
typedef void (^onTransProgressMsg)(NSString* msgCode , NSString* msgDesc);

/*!
 *  签到
 *
 *  @param  block
 */
typedef void (^onLoginSuccessBlock)(STXMisposResponsePacket* toe);

/*!
 *  消费
 *
 *  @param block
 */
typedef void (^onConsumeSuccessBlock)(STXMisposResponsePacket* toe);

/*!
 *  余额
 */
typedef void (^onBalanceSuccessBlock)(STXMisposResponsePacket* toe);

/*!
 *  撤销
 */
typedef void (^onCancelSuccessBlock)(STXMisposResponsePacket* toe);

/*!
 *  退货
 */

typedef void (^onRefundSuccessBlock)(STXMisposResponsePacket* toe);

/*!
 *  结算
 */
typedef void (^onSettleSuccessBlock)(STXMisposResponsePacket* toe);

/*!
 *   获取终端参数
 */
typedef void (^onGetTermParaSuccessBlock)(STXMisposResponsePacket* toe);

/*!
 *  交易数量查询
 */
typedef void (^onGetQueryDealCount)(STXMisposResponsePacket* toe);

/*!
 *  联机交易查询
 */
typedef void (^onQueryOnlineDealRecords)(STXMisposResponsePacket* toe);

/*!
 *  脱机交易查询
 */
typedef void (^onQueryOfflineDealRecords)(STXMisposResponsePacket* toe);

/*!
 *  末笔信息打印
 */
typedef void (^onPrintLastDeal)(STXMisposResponsePacket* toe);

/*!
 *  失败
 *
 *  @param code
 *  @param msg
 */
typedef void (^onFaildBlock )(NSString* code,NSString* msg);


@interface ShuaTianXiaMispos : MisposTemplate
+(id)sharedInstance;
-(void)setSTXPOSPConnectionDelegate:(id<STXConnectionDelegate>)delegate;

/*!
 *  签到
 *
 *  @param failBlock
 */
-(void)loginTran:(onLoginSuccessBlock)successBlock
  OnProcessBlock:(onTransProgressMsg)processBlock
   OnFailedBlock:(onFaildBlock)failBlock;

/*!
 *  消费
 *
 *  @param amount       金额
 *  @param successBlock 成功
 *  @param receiveBlock 接收数据
 *  @param failBlock    失败
 */
-(void)consumeTran:(NSString*)amount
    OnSuccessBlock:(onConsumeSuccessBlock)successBlock
    OnProcessBlock:(onTransProgressMsg)processBlock
     OnFailedBlock:(onFaildBlock)failBlock;


/**
 *  余额查询
 */
-(void)balanceTran:(onBalanceSuccessBlock)successBlock
    OnProcessBlock:(onTransProgressMsg)processBlock
     OnFailedBlock:(onFaildBlock)failBlock;


/**
 * 撤销交易
 *
 * @param oldRefNo 原参考号
 * @param oldAmount 原交易金额
 * @param oldVoucher 原流水号
 * @param oldBatchNo 原批次号
 */
-(void)cancelTran:(NSString*)oldRefNo
        OldAmount:(NSString*)oldAmount
       OldVoucher:(NSString*)oldVoucher
       OldBatchNo:(NSString*)oldBatchNo
   OnSuccessBlock:(onCancelSuccessBlock)successBlock
   OnProcessBlock:(onTransProgressMsg)processBlock
    OnFailedBlock:(onFaildBlock)failBlock;

/**
 * 退货交易
 *
 * @param refNo 原参考号
 * @param voucherNO 原交易流水号
 * @param batchNO 原交易批次号
 * @param transDate 原交易日期
 * @param amount 退货金额
 */
-(void)refundTran:(NSString*) refNO
          VoucherNO:(NSString*) voucherNO
          BatchNO:(NSString*) batchNO
        TransDate:(NSString*) transDate
           Amount:(NSString*) amount
   OnSuccessBlock:(onRefundSuccessBlock)successBlock
   OnProcessBlock:(onTransProgressMsg)processBlock
    OnFailedBlock:(onFaildBlock)failBlock;

/**
 * 结算
 */
-(void)settleTrans:(onSettleSuccessBlock)successBlock
    OnProcessBlock:(onTransProgressMsg)processBlock
     OnFailedBlock:(onFaildBlock)failBlock;

/**
 * 获取终端参数
 */
-(void)getTermPara:(onGetTermParaSuccessBlock)successBlock
    OnProcessBlock:(onTransProgressMsg)processBlock
     OnFailedBlock:(onFaildBlock)failBlock;


/**
 * 交易笔数查询
 */
-(void)queryDealCount:(onGetQueryDealCount)successBlock
       OnProcessBlock:(onTransProgressMsg)processBlock
        OnFailedBlock:(onFaildBlock)failBlock;

/**
 * 联机交易查询
 */
-(void)queryOnlineDealRecords:(int)index
                        Count:(int)count
               OnSuccessBlock:(onQueryOnlineDealRecords)successBlock
               OnProcessBlock:(onTransProgressMsg)processBlock
                OnFailedBlock:(onFaildBlock)failBlock;
/**
 * 脱机交易查询
 */
-(void)queryOfflineDealRecords:(int)index
                         Count:(int)count
                OnSuccessBlock:(onQueryOfflineDealRecords)successBlock
                OnProcessBlock:(onTransProgressMsg)processBlock
                 OnFailedBlock:(onFaildBlock)failBlock;


/**
 * 末笔交易信息打印
 */
-(void)printLastDeal:(onPrintLastDeal)successBlock
      OnProcessBlock:(onTransProgressMsg)processBlock
       OnFailedBlock:(onFaildBlock)failBlock;

@end

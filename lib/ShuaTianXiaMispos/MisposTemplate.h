//
//  MisposTemplate.h
//  MisposTemplate
//
//  Created by huanggq on 14-6-4.
//  Copyright (c) 2014年 Landicorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
#import "AbstractMisPOSPacket.h"

/**
 * 定义block
 */
//搜索到一个设备block
typedef void (^SearchOneDeviceBlock)(DeviceInfo *deviceInfo);

//搜索设备成功块block
typedef void (^SearchCompleteBlock)(NSMutableArray *deviceArray);

//打开设备成功block
typedef void (^OpenDeviceSuccessBlock)();

//打开设备失败block
typedef void (^OpenDeviceFailedBlock)();

//关闭设备block
typedef void (^CloseDeviceBlock)();

//下载固件成功
typedef void (^DownloadCompleteBlock)();

//下载固件progress
typedef void (^DownloadProgressBlock)(unsigned int current,unsigned int total);

//下载固件失败
typedef void (^DownloadErrorBlock)(int code);

typedef enum _enumMPOSDeviceCommunicationMode{
    MPOS_MASTERSLAVE,
    MPOS_DUPLEX,
}MPOSDeviceCommunicationMode;


@interface MisposTemplate : NSObject

/**
 * 查询设备
 */
- (BOOL)searchDevicesWithTimeout:(long)timeout searchOneDeviceBlcok:(SearchOneDeviceBlock)searchOneDeviceBlock completeBlock:(SearchCompleteBlock)searchCompleteBlock;

/**
 * 停止搜索
 */
- (void)stopSearching;

/**
 * 打开设备
 */
- (void)openDevice:(NSString *)identifier successBlock:(OpenDeviceSuccessBlock)successBlock failedBlock:(OpenDeviceFailedBlock)failedBlock;

/**
 * 关闭设备
 */
- (void)closeDevice:(CloseDeviceBlock)block;

/**
 * 同步打开设备
 */
-(BOOL)openDeviceSync:(NSString *)identifier;

/**
 * 同步关闭设备
 */
-(void)closeDeviceSync;

/**
 * 是否连接
 */
- (BOOL)isConnected;

/**
 * 更新固件
 */
- (void)download:(DeviceInfo *)dev path:(NSString *)filePath completeBlock:(DownloadCompleteBlock)downloadCompleteBlock progressBlock:(DownloadProgressBlock)downloadProgressBlock error:(DownloadErrorBlock)downloadErrorBlock;

/**
 * 获取lib版本号
 */
- (NSString*)getLibVersion;


/**
 * 发起交易
 */
-(void)start:(AbstractMisPOSPacket*)misPOSPacket;

/**
 * 收到POSP返回
 */
-(void)receiveFromPosp:(NSData*) serverData;


/**
 * 未收到POSP返回
 */
-(void)receivePospDataError;

/*!
 *  获取蓝牙ID
 *
 *  @return
 */
-(DeviceInfo *)getDeviceInfo;



@end

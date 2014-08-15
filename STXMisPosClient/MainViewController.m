//
//  MainViewController.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-11.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "MainViewController.h"
#import "Controllers/RadarViewController.h"
#import "Controllers/RefundTransViewController.h"

typedef NS_ENUM(NSInteger, AlertViewTag)
{
    ConsumeAlertViewTag = 100001,
    
};

@interface MainViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) DeviceInfo *deviceInfo;
@end

@implementation MainViewController

#pragma mark -
#pragma mark dealloc

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

#pragma mark -
#pragma mark viewDidLoad

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self enterRadarScanView];
}

- (void)enterRadarScanView
{
    // 软件启动进入后，启动扫描
    WEAKSELF;
    RadarViewController *radarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RadarViewController"];
    [radarVC execConnectDevice:^(DeviceInfo *deviceInfo)
     {
         STRONGSELF;
         strongSelf.deviceInfo = deviceInfo;
     }];
    [self addChildViewController:radarVC];
    [self.view addSubview:radarVC.view];
    radarVC = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UIButton Action
//TODO: 搜索设备
- (IBAction)clickToSearchDevice:(id)sender
{
    WEAKSELF;
    RadarViewController *radarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RadarViewController"];
    
    [radarVC execConnectDevice:^(DeviceInfo *deviceInfo)
    {
        STRONGSELF;
        strongSelf.deviceInfo = deviceInfo;
    }];
    [self addChildViewController:radarVC];
    [self.view addSubview:radarVC.view];
    [radarVC startSearchDevice];
}

//TODO: 断开
- (IBAction)clickToCloseDevice:(id)sender
{
    WEAKSELF;
    [[ShuaTianXiaMispos sharedInstance]closeDevice:^{
        DEBUG_METHOD(@"----成功断开连接---");
        [weakSelf enterRadarScanView];
    }];
}

//TODO: 签到
- (IBAction)clickToSignUp:(id)sender
{
    [[YZProgressHUD HUD]showOnWindow:self.view.window labelText:@"正在签到" detailText:nil];
    
    [[ShuaTianXiaMispos sharedInstance]loginTran:^(STXMisposResponsePacket *toe)
    {
        DEBUG_METHOD(@" -- login %@",toe);
        [[YZProgressHUD HUD]hideWithSuccess:@"签到成功" detailText:nil];
        
    } OnProcessBlock:^(NSString *msgCode, NSString *msgDesc) {
        
        DEBUG_METHOD(@" -- login %@",msgDesc);
        [[YZProgressHUD HUD]changeHUDWithText:msgDesc detailText:nil];
        
    } OnFailedBlock:^(NSString *code, NSString *msg) {
        
        DEBUG_METHOD(@" -- login %@  msg - %@",code,msg);
        [[YZProgressHUD HUD]hideWithError:msg detailText:nil];
    }];
}

//TODO: 余额查询
- (IBAction)clickToQueryBalance:(id)sender
{
    [[YZProgressHUD HUD]showOnWindow:self.view.window labelText:@"开始查询" detailText:nil];
    [[ShuaTianXiaMispos sharedInstance]balanceTran:^(STXMisposResponsePacket *toe)
    {
        DEBUG_METHOD(@" -- balance %@",toe.records);
        [[YZProgressHUD HUD]hideWithSuccess:@"查询成功" detailText:nil];
        
    } OnProcessBlock:^(NSString *msgCode, NSString *msgDesc) {
        
        DEBUG_METHOD(@" -- balance processMsg %@",msgDesc);
        [[YZProgressHUD HUD]changeHUDWithText:msgDesc detailText:nil];
        
    } OnFailedBlock:^(NSString *code, NSString *msg) {
        
        DEBUG_METHOD(@" -- balance %@  msg - %@",code,msg);
        [[YZProgressHUD HUD]hideWithError:msg detailText:nil];
    }];
}

//TODO: 结算
- (IBAction)clickToSettle:(id)sender
{
    [[YZProgressHUD HUD]showOnWindow:self.view.window labelText:@"开始计算" detailText:nil];
    [[ShuaTianXiaMispos sharedInstance]settleTrans:^(STXMisposResponsePacket *toe)
    {
        DEBUG_METHOD(@" -- settle %@",toe);
        [[YZProgressHUD HUD]hideWithSuccess:@"结算成功" detailText:nil];
        
    } OnProcessBlock:^(NSString *msgCode, NSString *msgDesc) {
        
        DEBUG_METHOD(@" -- settle %@",msgDesc);
        [[YZProgressHUD HUD]changeHUDWithText:msgDesc detailText:nil];
        
    } OnFailedBlock:^(NSString *code, NSString *msg) {
        
        DEBUG_METHOD(@" -- settle %@  msg - %@",code,msg);
        NSString *messge = (msg != nil ? msg : @"结算失败");
        [[YZProgressHUD HUD]hideWithError:messge detailText:nil];
    }];
}

//TODO: 参数
- (IBAction)clickToGetParams:(id)sender
{
    [[YZProgressHUD HUD]showOnWindow:self.view.window labelText:@"获取终端参数" detailText:nil];
    [[ShuaTianXiaMispos sharedInstance]getTermPara:^(STXMisposResponsePacket *toe)
    {
        DEBUG_METHOD(@" -- TermPara %@-%@-%@-%@",toe.termType,toe.terminalNo,toe.sn,toe.featureCode);
        NSString *detail = [NSString stringWithFormat:@"终端号:%@\n硬件序列号:%@",
                            toe.terminalNo,toe.sn];
        [[YZProgressHUD HUD]hide];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"终端参数"
                                                           message:detail
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        alertView = nil;
        
    } OnProcessBlock:^(NSString *msgCode, NSString *msgDesc) {
        
        DEBUG_METHOD(@" -- TermPara %@",msgDesc);
        [[YZProgressHUD HUD]changeHUDWithText:msgDesc detailText:nil];
        
    } OnFailedBlock:^(NSString *code, NSString *msg) {
        
        DEBUG_METHOD(@" -- TermPara %@  msg - %@",code,msg);
        [[YZProgressHUD HUD]hideWithError:msg detailText:nil];
    }];
}

//TODO: 消费
- (IBAction)clickToConsumeTran:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"请输入消费金额"
                                                      delegate:self
                                             cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [alertView setTag:ConsumeAlertViewTag];
    [alertView show];
    alertView = nil;
//
}

//TODO: 退货交易
- (IBAction)clickToRefund:(id)sender
{
    RefundTransViewController *refundTransVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RefundTransViewController"];
    
    WEAKSELF;
    [refundTransVC execRefund:^(NSString *freNo, NSString *voucherNO,
                                NSString *batchNO, NSString *transDate, NSString *amount) {
        STRONGSELF;
        sleep(1);
        [[YZProgressHUD HUD]showOnView:strongSelf.view labelText:@"正在退货" detailText:nil];
        
        [[ShuaTianXiaMispos sharedInstance]refundTran:freNo
                                            VoucherNO:voucherNO
                                              BatchNO:batchNO
                                            TransDate:transDate
                                               Amount:amount
                                       OnSuccessBlock:^(STXMisposResponsePacket *toe) {
                                           
            DEBUG_METHOD(@" -- refundTran %@",toe);
            [[YZProgressHUD HUD]hideWithSuccess:@"退货交易完成" detailText:nil];
                                                   
        } OnProcessBlock:^(NSString *msgCode, NSString *msgDesc) {
            
            DEBUG_METHOD(@" -- refundTran %@",msgDesc);
            [[YZProgressHUD HUD]changeHUDWithText:msgDesc detailText:nil];
            
        } OnFailedBlock:^(NSString *code, NSString *msg) {
            
            DEBUG_METHOD(@" -- refundTran %@  msg - %@",code,msg);
            [[YZProgressHUD HUD]hideWithError:msg detailText:nil];
        }];
    }];
    [self presentViewController:refundTransVC animated:YES completion:nil];
}

//TODO: 更新服务器IP和端口
- (IBAction)clickToUpdateIPAndPort:(id)sender
{
    
}


//TODO: 蓝牙状态
- (IBAction)clickToGetBluetoothStatus:(id)sender
{
    BOOL isConnected = [[ShuaTianXiaMispos sharedInstance]isConnected];
    NSString *messageBody = isConnected ? @"蓝牙连接OK" : @"失去蓝牙连接";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"蓝牙状态"
                                                       message:messageBody
                                                      delegate:nil
                                             cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    alertView = nil;
}


- (IBAction)clickToFetchTransRecord:(id)sender
{
    [[YZProgressHUD HUD]showOnWindow:self.view.window labelText:@"开始查询" detailText:nil];
    
//    [[ShuaTianXiaMispos sharedInstance]queryDealCount:^(STXMisposResponsePacket *toe)
//    {
//        DEBUG_METHOD(@" -- queryDealCount %@",toe.records);
//        [[YZProgressHUD HUD]hideWithSuccess:@"查询完成" detailText:nil];
//        
//    } OnProcessBlock:^(NSString *msgCode, NSString *msgDesc) {
//        
//         DEBUG_METHOD(@" -- refundTran %@",msgDesc);
//        [[YZProgressHUD HUD]changeHUDWithText:msgDesc detailText:nil];
//        
//    } OnFailedBlock:^(NSString *code, NSString *msg) {
//        
//        DEBUG_METHOD(@" -- refundTran %@  msg - %@",code,msg);
//        [[YZProgressHUD HUD]hideWithError:msg detailText:nil];
//    }];
    [[ShuaTianXiaMispos sharedInstance]queryOnlineDealRecords:0
                                                        Count:1000
                                               OnSuccessBlock:^(STXMisposResponsePacket *toe)
    {
        DEBUG_METHOD(@" -- queryDealCount %@",toe.records);
        [[YZProgressHUD HUD]hideWithSuccess:@"查询完成" detailText:nil];
        
    } OnProcessBlock:^(NSString *msgCode, NSString *msgDesc) {
        
         DEBUG_METHOD(@" -- refundTran %@",msgDesc);
        [[YZProgressHUD HUD]changeHUDWithText:msgDesc detailText:nil];
        
    } OnFailedBlock:^(NSString *code, NSString *msg) {
        
        DEBUG_METHOD(@" -- refundTran %@  msg - %@",code,msg);
        [[YZProgressHUD HUD]hideWithError:msg detailText:nil];
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ConsumeAlertViewTag)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text.length <= 0)
        {
            [self clickToConsumeTran:nil];
            return;
        }
        [[YZProgressHUD HUD]showOnWindow:self.view.window labelText:@"开始消费" detailText:nil];
        
        void (^onConsumeSuccessBlock)(STXMisposResponsePacket* ) = ^(STXMisposResponsePacket* toe){
            DEBUG_METHOD(@" -- consume %@",toe);
            
            DEBUG_METHOD(@"参考号:%@ \n 交易金额:%@ \n 流水号:%@ \n 批次号:%@ \n",
                  toe.refNo,toe.amount,toe.voucherNo,toe.batchNo);
            [[YZProgressHUD HUD]hide];
            NSString *msg = [NSString stringWithFormat:@"参考号:%@ \n 交易金额:%@ \n 流水号:%@ \n 批次号:%@ \n",toe.refNo,toe.amount,toe.voucherNo,toe.batchNo];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"消费结果"
                                                               message:msg
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            alertView = nil;
        };
        
        void (^onTransProgressMsg)(NSString *,NSString *) = ^(NSString* code, NSString* processMsg)
        {
            DEBUG_METHOD(@"-- consume :%@",processMsg);
            [[YZProgressHUD HUD]changeHUDWithText:processMsg detailText:nil];
        };

        [[ShuaTianXiaMispos sharedInstance]consumeTran:textField.text
                                        OnSuccessBlock:onConsumeSuccessBlock
                                        OnProcessBlock:onTransProgressMsg
                                         OnFailedBlock:^(NSString *code, NSString *msg)
        {
            DEBUG_METHOD(@" -- consume %@  msg - %@",code,msg);
            [[YZProgressHUD HUD]hideWithError:msg detailText:nil];
            
         }];
    }
}
@end

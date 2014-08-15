//
//  CancelTransViewController.h
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-13.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^refundBlock)(NSString *freNo,NSString *voucherNO,NSString *batchNO,NSString *transDate,NSString *amount);
@interface RefundTransViewController : UIViewController
- (void)execRefund:(refundBlock)refund;
@end

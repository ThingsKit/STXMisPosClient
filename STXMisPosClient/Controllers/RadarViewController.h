//
//  RadarViewController.h
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-12.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShuaTianXiaMispos.h>

@interface RadarViewController : UIViewController
- (void)startSearchDevice;
- (void)execConnectDevice:(SearchOneDeviceBlock)searchOne;
@end

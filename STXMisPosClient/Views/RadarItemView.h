//
//  RadarItemView.h
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-13.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShuaTianXiaMispos.h>

@interface RadarItemView : UIButton
@property (nonatomic, strong) DeviceInfo *deviceInfo;
- (id)initWithIdentifier:(NSString*)identifier;
@end

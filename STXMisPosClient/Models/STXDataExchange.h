//
//  STXDataExchange.h
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-13.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STXDataExchange : NSObject
+ (instancetype)shared;
- (void)prepareChangeData;
@end

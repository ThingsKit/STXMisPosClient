//
//  STXCellView.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-13.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "STXCellView.h"

@implementation STXCellView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 2.0;
    self.layer.masksToBounds = YES;
}

@end

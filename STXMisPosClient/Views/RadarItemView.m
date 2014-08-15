//
//  RadarItemView.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-13.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "RadarItemView.h"

@interface RadarItemView()
@property (nonatomic, strong) UILabel *identifierLabel;
@end

@implementation RadarItemView

- (id)initWithIdentifier:(NSString*)identifier
{
    self = [super initWithFrame:CGRectMake(0, 0, 45, 45)];
    if (self)
    {
        self.clipsToBounds = NO;
        UIImage *image = [UIImage imageNamed:@"bluetooth_normal@2x"];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        
        _identifierLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height, 80, 20)];
        _identifierLabel.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height+10);
        _identifierLabel.backgroundColor = [UIColor clearColor];
        _identifierLabel.textAlignment = NSTextAlignmentCenter;
        _identifierLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        _identifierLabel.textColor = [UIColor whiteColor];
        _identifierLabel.text = identifier;
        [self addSubview:_identifierLabel];
        
        [self startAnimationIfNeeded];
    }
    return self;
}

-(void)startAnimationIfNeeded{

    [self.identifierLabel.layer removeAllAnimations];
    CGSize textSize = [self.identifierLabel.text sizeWithFont:self.identifierLabel.font];
    CGRect lframe = self.identifierLabel.frame;
    lframe.size.width = textSize.width;
    self.identifierLabel.frame = lframe;
    self.identifierLabel.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height+10);
    const float oriWidth = 80;
    if (textSize.width > oriWidth)
    {
        float offset = (textSize.width - oriWidth)*0.5;
        [UIView animateWithDuration:3.0
                              delay:0
                            options:UIViewAnimationOptionRepeat //动画重复的主开关
         |UIViewAnimationOptionAutoreverse //动画重复自动反向，需要和上面这个一起用
         |UIViewAnimationOptionCurveLinear //动画的时间曲线，滚动字幕线性比较合理
                         animations:^{
                             self.identifierLabel.transform = CGAffineTransformMakeTranslation(-offset, 0);
                         }
                         completion:^(BOOL finished) {
                             
                         }
         ];
    }
}

@end

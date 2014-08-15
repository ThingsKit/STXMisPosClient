//
//  STXButton.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-11.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "STXButton.h"

static const CGFloat KButtonWidth = 75.0f;

@implementation STXButton

+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, KButtonWidth, KButtonWidth);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 128 / 256.0 )+0.5; //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    UIColor *borderColor = [UIColor colorWithRed:0.984 green:0.510 blue:0.000 alpha:1.0];
//    UIImage *image = [self.class createImageWithColor:[UIColor clearColor]];
//    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:self.frame.size.width*0.5];
    [self.layer setBorderColor:[self.class randomColor].CGColor];
    [self.layer setBorderWidth:2.0];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.layer setBorderColor:[self.class randomColor].CGColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.layer setBorderColor:[self.class randomColor].CGColor];
}

@end

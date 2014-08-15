//
//  RadarViewController.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-12.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "RadarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AsyncSocket.h>
#import <math.h>
#import "STXDataExchange.h"
#import "RadarItemView.h"
#import "STXButton.h"

@interface RadarViewController ()
@property (nonatomic, strong) NSURL *soundFileURL;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *radarTimer;
@property (nonatomic, strong) NSMutableArray *XYPointsArray;
@property (nonatomic, copy) SearchOneDeviceBlock searchOneBlock;
@property (nonatomic, weak) IBOutlet UIImageView *radarImageView;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation RadarViewController

#pragma mark -
#pragma mark dealloc

- (void)dealloc
{
    _radarTimer = nil;
    _soundFileURL = nil;
    _audioPlayer = nil;
    _radarImageView = nil;
    _XYPointsArray = nil;
}

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
#pragma mark getter

- (NSURL*)soundFileURL
{
    if (_soundFileURL == nil)
    {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"sonar_hold" ofType:@"aif"];
        _soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    }
    return _soundFileURL;
}

- (AVAudioPlayer*)audioPlayer
{
    if (_audioPlayer == nil && self.soundFileURL)
    {
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:self.soundFileURL error:nil];
        [_audioPlayer setCurrentTime:0];
        [_audioPlayer setNumberOfLoops:-1];
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}



#pragma mark -
#pragma mark 播放扫描动画和声音

- (void)stopScan
{
    [self.radarImageView.layer removeAnimationForKey:@"animation"];
}

- (void)startScanMispos
{
    [self.radarImageView.layer removeAnimationForKey:@"animation"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.delegate = self;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:2*M_PI];
    animation.duration = 5;
    animation.repeatCount = INT32_MAX;
    animation.cumulative = YES;//累积的
    //    animation.autoreverses = YES;//是否自动重复
    [self.radarImageView.layer addAnimation:animation forKey:@"animation"];
}


- (void)playOrStop
{
    if (self.audioPlayer.playing)
    {
        [self.audioPlayer stop];
        [self stopScan];
    }
    else
    {
        [self.audioPlayer play];
        [self startScanMispos];
    }
}

#pragma mark -
#pragma mark 视图加载

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)execConnectDevice:(SearchOneDeviceBlock)searchOne
{
    _searchOneBlock = searchOne;
}


- (IBAction)clickToSearchDevice:(id)sender
{
    LogFUNC;
    [self startSearchDevice];
}


- (void)startSearchDevice
{
    self.radarImageView.hidden = NO;
    self.searchView.hidden = YES;
    
    [self playOrStop];
    void (^searchOneBlock)(DeviceInfo*) = ^(DeviceInfo *deviceInfo){
        [self performSelectorOnMainThread:@selector(updateScanDevice:) withObject:deviceInfo waitUntilDone:NO];
    };
    WEAKSELF;
    [[ShuaTianXiaMispos sharedInstance]searchDevicesWithTimeout:INT32_MAX
                                           searchOneDeviceBlcok:searchOneBlock
                                                  completeBlock:^(NSMutableArray *deviceArray)
     {
         STRONGSELF;
         if (deviceArray.count <= 0)
         {
             strongSelf.radarImageView.hidden = YES;
             strongSelf.searchView.hidden = NO;
         }
         [weakSelf stopScan];
         [strongSelf.audioPlayer stop];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.radarImageView.hidden = YES;
    self.searchView.hidden = NO;
    
    WEAKSELF;
    [self XYPointArray:^(NSMutableArray *resultArray)
    {
        __typeof(self) __strong strongSelf = weakSelf;
        strongSelf.XYPointsArray = resultArray;
    }];
}

- (void)clickToConnectDevice:(RadarItemView*)sender
{
    WEAKSELF;
    [[ShuaTianXiaMispos sharedInstance]openDevice:sender.deviceInfo.getIdentifier successBlock:^{
        STRONGSELF;
        if (_searchOneBlock)
        {
            _searchOneBlock(sender.deviceInfo);
        }
        [self.audioPlayer stop];
        [self stopScan];
        [strongSelf removeFromParentViewController];
        [strongSelf.view removeFromSuperview];
        
    } failedBlock:^{
        
        DEBUG_METHOD(@"---蓝牙连接失败---");
    }];
    [[STXDataExchange shared]prepareChangeData];
}


- (void)updateScanDevice:(DeviceInfo*)deviceInfo
{
    int count = self.XYPointsArray.count;
    int index = arc4random()%count;
    if (index >= 0 && index < count)
    {
        NSString *XYPointString = [self.XYPointsArray objectAtIndex:index];
        CGPoint YXYPoint = CGPointFromString(XYPointString);
        RadarItemView *itemView = [[RadarItemView alloc]initWithIdentifier:deviceInfo.getName];
        [itemView setDeviceInfo:deviceInfo];
        [itemView setCenter:YXYPoint];
        [itemView addTarget:self action:@selector(clickToConnectDevice:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:itemView];
    }
}

- (void)exAsycGlobalQueue:(void (^)())queue
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue
{
    dispatch_async(dispatch_get_main_queue(), queue);
}

- (void)XYPointArray:(void(^)(NSMutableArray *resultArray))resultBlock
{
    __block NSMutableArray *result = nil;
    
    [self exAsycGlobalQueue:^{

        NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
        CGFloat centerX = 160;
        CGFloat centerY = 240;
        CGFloat radius = 24;// 目标结果的半径
        CGFloat x1 = radius, y1 = 80+radius ;
        CGFloat x2 = centerX*2-radius, y2 = 400 - radius;
        
        while ( x1 >= radius && x1 <= centerX*2-radius && y1 >= 80 + radius && y1 <= 400 - radius &&
               x2 >= radius && x2 <= centerX*2-radius && y2 >= 80 + radius && y2 <= 400 - radius &&
               array.count < 20)
        {
            if (powf((x1 -x2), 2.0)  + powf((y1 -y2),2.0) >= powf(2*radius, 2.0) &&
                powf(x1 -centerX, 2.0) + powf(y1 -centerY,2.0) <= powf(centerX-radius,2.0) &&
                powf(x2 -centerX, 2.0) + powf(y2 -centerY,2.0) <= powf(centerX-radius,2.0))
            {
                CGPoint point1 = CGPointMake(x1, y1);
                if ( ![array containsObject:NSStringFromCGPoint(point1)])
                {
                    [array addObject:NSStringFromCGPoint(point1)];
                }
                CGPoint point2 = CGPointMake(x2, y2);
                if ( ![array containsObject:NSStringFromCGPoint(point2)])
                {
                    [array addObject:NSStringFromCGPoint(point2)];
                }
            }
            
            x1 += arc4random()%5;
            y1 += arc4random()%5;
            x2 -= arc4random()%5;
            y2 -= arc4random()%5;
        }
        result = [NSMutableArray arrayWithArray:array];
        resultBlock(result);
    }];
}

@end

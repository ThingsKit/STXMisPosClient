//
//  IPPortsViewController.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-14.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "IPPortsViewController.h"
#import "STXDataExchange.h"

@interface IPPortsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *IPTextField;
@property (weak, nonatomic) IBOutlet UITextField *PortTextField;

@end

@implementation IPPortsViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithCoder:(NSCoder *)aDecoder
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)clickToUpdateIpAndPort:(id)sender
{
    if (self.IPTextField.text.length <= 0)
    {
        [[YZProgressHUD HUD]showWithError:self.view.window labelText:@"请输入IP地址" detailText:nil];
        return;
    }
    
    if (self.PortTextField.text.length <= 0)
    {
         [[YZProgressHUD HUD]showWithError:self.view.window labelText:@"请输入端口号" detailText:nil];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.IPTextField.text forKey:@"IP"];
    [userDefaults setObject:self.PortTextField.text forKey:@"Port"];
    [userDefaults synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        [[STXDataExchange shared]prepareChangeData];
    }];
}

- (IBAction)clickToBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
